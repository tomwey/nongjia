class WechatShop::PagesController < WechatShop::ApplicationController

  def show
    @page = Page.find_by(slug: params[:id])
    
    unless params[:code].blank?
      @ticket = WX::Base.fetch_qrcode_ticket(params[:code])
    end
    
  end
    
end
