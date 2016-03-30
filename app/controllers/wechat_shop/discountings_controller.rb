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
  
  def create
    # puts params
    code = params[:code]
    if current_user.nb_code == code
      # 不能自己兑换自己的优惠码
      flash[:error] = '您不能兑换自己的优惠码'
      redirect_to new_wechat_shop_coupon_path
      return
    end
    
    event = DiscountEvent.find_by(code: code)
    if event.present?
      
    end
    
    flash[:error] = '无效的优惠码'
    redirect_to new_wechat_shop_coupon_path
  end
  
end
