class WechatShop::ProductsController < WechatShop::ApplicationController

  def show
    @product = Product.find(params[:id])
    @page_title = @product.title
    
    @wx_share = WXShare.new(@product.images.first.url(:small), "#{Setting.domain}/wx-shop/products/#{@product.id}", @product.title, '')
    
    fresh_when(etag: [@product, @page_title])
  end
    
end
