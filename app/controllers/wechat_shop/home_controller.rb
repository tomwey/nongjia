class WechatShop::HomeController < WechatShop::ApplicationController

  def index
    @products = Product.no_delete.saled.sorted.hot.recent
    @current  = 'home_index' 
    
    # 加载广告，最多5个
    @banners = Banner.sorted.recent.limit(5)
    
    fresh_when(etag: [@products, @banners, @current])
  end
    
end
