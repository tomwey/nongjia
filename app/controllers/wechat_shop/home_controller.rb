class WechatShop::HomeController < WechatShop::ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  def index
    
    @products = Product.no_delete.saled.hot
    
  end
    
end
