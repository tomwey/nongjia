class WechatShop::PagesController < WechatShop::ApplicationController

  def show
    @page = Page.find_by(slug: params[:id])
    
    unless params[:code].blank?
      @ticket = WX::Base.fetch_qrcode_ticket(params[:code])
    end
    
    if @page.slug == 'help' && params[:from] == 'wx'
      @from = "#{settings_wechat_shop_user_path}"
    else
      @from = 'javascript:history.go(-1)'
    end
  end
    
end
