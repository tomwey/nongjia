class WechatShop::OrdersController < WechatShop::ApplicationController

  before_filter :require_user, except: :wx_pay_notify
  skip_before_filter :verify_authenticity_token, :only => [:wx_pay_notify]
  before_filter :check_user,   except: :wx_pay_notify
  
  def index
    @orders = current_user.orders.order('id DESC')
    @current = 'orders_index'
    @page_title = '我的订单'
    
    fresh_when(etag: [@orders, @current])
  end
  
  def no_pay
    @orders = current_user.orders.no_pay.order('id DESC')
    @current = 'orders_no_pay'
    render :index
    
    # fresh_when(etag: [@orders, @current])
  end
  
  def shipping
    @orders = current_user.orders.shipping.order('id DESC')
    @current = 'orders_shipping'
    render :index
    
    # fresh_when(etag: [@orders, @current])
  end
  
  def show
    @order = current_user.orders.find_by(order_no: params[:id])
    if @order.blank?
      flash[:error] = '没有该订单'
      @current = 'orders_index'
      redirect_to orders_wechat_shop_user_path #orders_wechat_shop_user_path
    end
    
  end
  
  def new
    # 放到session里面
    
    session[:from_for_shipments] = nil
    session[:from_for_coupons] = nil
    
    save_pid_and_quantity_to_session(params[:pid], params[:q])
    
    product = Product.find_by(id: user_product_id)
    if product.blank?
      flash[:error] = '未找到产品'
      redirect_to wechat_shop_root_path
      return
    end
    
    if not product.has_stock?
      flash[:error] = '该产品无货'
      redirect_to wechat_shop_root_path
      return
    end
    
    @order = Order.new
    @order.product = product
    @order.quantity = user_order_quantity
    @order.total_fee = product.price * @order.quantity
    @order.discount_fee = 0
    
    @coupon_counts ||= current_user.valid_coupons.where.not('except_products @> ?', "{#{product.id}}").count
    
    if params[:coupon_id].present?
      @coupon_ids = current_user.valid_coupons.where.not('except_products @> ?', "{#{product.id}}").pluck(:id)
      @discounting = Discounting.where(coupon_id: @coupon_ids).find_by(id: params[:coupon_id])
      # @discounting = current_user.valid_discountings.find_by(id: params[:coupon_id])
      if @discounting.present?
        @coupon = @discounting.coupon
        @order.discount_fee = @discounting.discount_value_for(@order.total_fee)
        session[:current_discounting_id] = params[:coupon_id]
      end
    end
    
    @page_title = '确认订单'
    
  end
  
  def create
    
    @has_shipment = current_user.current_shipment_id.present?
    
    if @has_shipment
      
      product = Product.find_by(id: user_product_id)
      if product.blank?
        @has_product = false
      else
        @has_product = true
        
        @has_stock = check_stock?(product)
        
        if @has_stock
          @success = false
    
          @order = current_user.orders.new(order_params)
          @order.product_id = user_product_id
          @order.quantity   = user_order_quantity
    
          if @order.save
            # 删除session里面的用户下单相关信息
            session.delete(user_session_key)
      
            @success = true
      
            # 激活优惠券
            if session[:current_discounting_id].present?
              discounting = current_user.valid_discountings.find_by(id: session[:current_discounting_id])
              if discounting && discounting.update_attribute(:discounted_at, Time.now)
                session[:current_discounting_id] = nil
              end
            end
      
            # 调起微信支付统一下单接口
            @result = WX::Pay.unified_order(@order, request.remote_ip)
            if @result and @result['return_code'] == 'SUCCESS' and @result['return_msg'] == 'OK' and @result['result_code'] == 'SUCCESS'
              $redis.set(@order.order_no, @result['prepay_id'])
        
              @jsapi_params = WX::Pay.generate_jsapi_params(@result['prepay_id'])
        
            else
              # 微信统一下单失败
              # 关闭当前订单
              WX::Pay.close_order(@order)
              @jsapi_params = nil
            end # end 结束调用微信支付
      
          else
            # 创建订单失败
            @success = false
          end
        end # end stock check
        
      end # end product blank check
      
    end # end shipment check
    
  end
  
  def payment
    @order = Order.find_by(order_no: params[:order_no])
    @is_order_detail = params[:is_order_detail].to_i == 1
    if @order.present? and @order.can_pay?
      
      prepay_id = $redis.get(@order.order_no)
      if prepay_id.present?
        @jsapi_params = WX::Pay.generate_jsapi_params(prepay_id)
      else
        @result = WX::Pay.unified_order(@order, request.remote_ip)
        if @result and @result['return_code'] == 'SUCCESS' and @result['return_msg'] == 'OK' and @result['result_code'] == 'SUCCESS'
          $redis.set(@order.order_no, @result['prepay_id'])
          
          @jsapi_params = WX::Pay.generate_jsapi_params(@result['prepay_id'])
        else
          # 微信统一下单失败
          # 关闭当前订单
          WX::Pay.close_order(@order)
          @jsapi_params = nil
        end
        
      end
      
    end
  end
  
  def wx_pay_notify
    @output = {
      return_code: '',
      return_msg: 'OK',
    }
    
    result = params['xml']
    if result and result['return_code'] == 'SUCCESS' and WX::Pay.notify_verify?(result)
      # 支付成功，更改订单状态
      order = Order.find_by(order_no: result['out_trade_no'])
      if order.present? and order.can_pay?
        $redis.del(order.order_no)
        order.pay
      end
      @output[:return_code] = 'SUCCESS'
      
    else
      # 支付失败
      @output[:return_code] = 'FAIL'
    end
    
    respond_to do |format|
      format.xml { render xml: @output.to_xml(root: 'xml', skip_instruct: true, dasherize: false) }
    end
    
  end
  
  private
  def order_params
    params.require(:order).permit(:note, :quantity, :product_id, :total_fee, :discount_fee)
  end
  
  def check_stock?(product)
    user_order_quantity.to_i <= product.stock.to_i
  end
  
  def save_pid_and_quantity_to_session(pid, quantity)
    if pid.blank? or quantity.blank?
      return
    end
    
    session[user_session_key] = "#{params[:pid]}-#{params[:q]}"
  end
  
  def user_session_key
    "order_for_#{current_user.id.to_s}".to_sym
  end
  
  def user_product_id
    session[user_session_key].split('-').first if session[user_session_key].present?
  end
  
  def user_order_quantity
    session[user_session_key].split('-').last if session[user_session_key].present?
  end
    
end
