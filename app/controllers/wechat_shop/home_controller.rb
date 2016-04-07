class WechatShop::HomeController < WechatShop::ApplicationController

  def index
    @products = Product.no_delete.saled.hot
    @current  = 'home_index' 
    
    fresh_when(etag: [@products])
  end
    
end
