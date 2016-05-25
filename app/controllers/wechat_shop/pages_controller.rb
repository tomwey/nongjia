class WechatShop::PagesController < WechatShop::ApplicationController

  def show
    @page = Page.find_by(slug: params[:id])
    
    unless params[:code].blank?
      @ticket = WX::Base.fetch_qrcode_ticket(params[:code])
    end
    
    if @page.slug == 'help' && params[:from] == 'wx'
      @from = "#{settings_wechat_shop_user_path}"
    else
      if params[:from] == 'wx'
        @from = nil
      else
        @from = request.referer
      end
      puts request.referer
      # @from = 'javascript:history.go(-1)'
    end
  end
    
end
