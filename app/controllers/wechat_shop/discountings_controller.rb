class WechatShop::DiscountingsController < WechatShop::ApplicationController
  
  before_filter :require_user
  before_filter :check_user
  
  def index
    # @coupons = current_user.valid_coupons
    @discountings = current_user.valid_discountings.order('expired_on asc, id DESC')
    
    
    if params[:from]
      session[:from_for_coupons] = params[:from]
    end
    @from = params[:from] || session[:from_for_coupons]
  end
  
end
