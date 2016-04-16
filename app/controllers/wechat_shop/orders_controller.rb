class WechatShop::OrdersController < WechatShop::ApplicationController

  before_filter :require_user
  before_filter :check_user
  
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
      redirect_to wechat_shop_orders_path
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
    
    @order = Order.new
    @order.product = product
    @order.quantity = user_order_quantity
    @order.total_fee = product.price * @order.quantity
    @order.discount_fee = 0
    
    if params[:coupon_id].present?
      @discounting = current_user.valid_discountings.find_by(id: params[:coupon_id])
      if @discounting.present?
        @coupon = @discounting.coupon
        @order.discount_fee = @discounting.discount_value_for(@order.total_fee)
        session[:current_discounting_id] = params[:coupon_id]
      end
    end
    
    @page_title = '确认订单'
    
  end
  
  def create
    
    @allow_commit = true
    if current_user.current_shipment_id.blank?
      @allow_commit = false
    end
    
    if @allow_commit
      @success = false
    
      @order = current_user.orders.new(order_params)
      @order.product_id = user_product_id
      @order.quantity   = user_order_quantity
    
      if @order.save
        session.delete(user_session_key)
        # flash[:success] = '下单成功'
    
        # 激活优惠券
        if session[:current_discounting_id].present?
          discounting = current_user.valid_discountings.find_by(id: session[:current_discounting_id])
          if discounting && discounting.update_attribute(:discounted_at, Time.now)
            session[:current_discounting_id] = nil
          end
        end
    
        @success = true
        
        @unified_order_success = false
        
        @result = WX::Pay.unified_order(@order, request.remote_ip)
        if @result and @result['return_code'] == 'SUCCESS' and @result['return_msg'] == 'OK' and @result['result_code'] == 'SUCCESS'
          @jsapi_params = WX::Pay.generate_jsapi_params(@result['prepay_id'])
          @unified_order_success = true
        else
          @unified_order_success = false
        end
        
      else
        # render :new
        @success = false
      end
    end
    
  end
  
  def notify
    puts params
  end
  
  private
  def order_params
    params.require(:order).permit(:note, :quantity, :product_id, :total_fee, :discount_fee)
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
