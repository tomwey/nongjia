class WechatShop::PagesController < WechatShop::ApplicationController

  def show
    @page = Page.find_by(slug: params[:id])
    
    unless params[:code].blank?
      @ticket = WX::Base.fetch_qrcode_ticket(params[:code])
    end
    
    if @page.slug == 'help' && params[:from] == 'wx'
      @from = "#{settings_wechat_shop_user_path}"
    else
      if request.referer and request.referer.include?('nj.afterwind.cn')
        @from = request.referer
      else
        @from = nil
      end
    end
    
  end
    
end
