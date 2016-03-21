class WechatShop::OrdersController < WechatShop::ApplicationController

  def new
    # puts request.url
    # puts params
    product = Product.find_by(id: params[:pid])
    if product.blank?
      flash[:error] = '未找到产品'
      redirect_to wechat_shop_root_path
      return
    end
    
    @order = Order.new
    @order.product = product
    @order.quantity = params[:q]
    
    @page_title = '确认订单'
    
  end
  
  def create
    
  end
    
end
