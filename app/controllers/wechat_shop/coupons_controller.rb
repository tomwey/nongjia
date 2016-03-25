class WechatShop::CouponsController < WechatShop::ApplicationController
  
  before_filter :require_user
  before_filter :check_user
  
  def index
    @coupons = current_user.unused_coupons.unexpired.order('expired_on asc')
    
    if params[:from]
      session[:from_for_coupons] = params[:from]
    end
    @from = params[:from] || session[:from_for_coupons]
  end
  
end
