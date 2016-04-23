class WechatShop::CouponsController < WechatShop::ApplicationController
  
  before_filter :require_user
  before_filter :check_user
  
  def index
    @coupons = current_user.valid_coupons
    
    if params[:from]
      session[:from_for_coupons] = params[:from]
    end
    @from = params[:from] || session[:from_for_coupons]
    if @from.blank?
      @from = "#{settings_wechat_shop_user_path}"
    end
  end
  
end
