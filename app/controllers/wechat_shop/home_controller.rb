class WechatShop::HomeController < WechatShop::ApplicationController

  def index
    @products = Product.no_delete.saled.sorted.hot.recent
    @current  = 'home_index' 
    
    # 加载广告，最多5个
    @banners = Banner.sorted.recent.limit(5)
    
    # 加载限时活动
    @sale = FlashSale.order('id desc').limit(1).first
    if not @sale.blank?
      @product = Product.where(id: @sale.product_ids).order('id desc').first
    
      @start = (@sale.begin_time - Time.now).to_i
      @end   = (@sale.end_time - Time.now).to_i
    
      @duration = @start > 0 ? @start : @end
    
      @hour = @duration / 3600
      @min  = ( @duration - 3600 * @hour ) / 60
      @sec  = @duration - @hour * 3600 - @min * 60;
    end
    
    # 加载腰风
    @ad = Ad.order('sort desc, id desc').limit(1).first
    
    fresh_when(etag: [@products, @banners, @current, @ad, @sale, @product])
  end
    
end
