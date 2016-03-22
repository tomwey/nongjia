class WechatShop::HomeController < WechatShop::ApplicationController

  def index
    puts params
    @products = Product.no_delete.saled.hot
    @current  = 'home_index' 
  end
    
end
