class WechatShop::HomeController < WechatShop::ApplicationController

  def index
    
    @products = Product.no_delete.saled.hot
    
  end
    
end
