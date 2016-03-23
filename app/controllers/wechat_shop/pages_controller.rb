class WechatShop::PagesController < WechatShop::ApplicationController

  def show
    @page = Page.find_by(slug: params[:id])
  end
    
end
