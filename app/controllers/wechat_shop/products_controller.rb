class WechatShop::ProductsController < WechatShop::ApplicationController

  def show
    @product = Product.find(params[:id])
    @page_title = @product.title
    
    @wx_share = WXShare.new(@product.images.first.url(:small), "#{Setting.upload_url}/wx-shop/products/#{@product.id}", "农家风味商城", @page_title)
    
    # fresh_when(etag: [@product])
  end
    
end
