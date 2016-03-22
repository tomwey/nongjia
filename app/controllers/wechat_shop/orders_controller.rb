class WechatShop::OrdersController < WechatShop::ApplicationController

  before_filter :require_user
  before_filter :check_user

  def new
    # 放到session里面
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
    
    @page_title = '确认订单'
    
  end
  
  def create
    
    @order = current_user.orders.new(order_params)
    @order.product_id = user_product_id
    @order.quantity   = user_order_quantity
    
    if @order.save
      session.delete(user_session_key)
      flash[:success] = '下单成功'
      redirect_to wechat_shop_orders_path
    else
      render :new
    end
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
    session[user_session_key].split('-').first
  end
  
  def user_order_quantity
    session[user_session_key].split('-').last
  end
    
end
