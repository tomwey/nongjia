class WechatShop::DiscountingsController < WechatShop::ApplicationController
  
  before_filter :require_user
  before_filter :check_user
  
  def index
    # @coupons = current_user.valid_coupons
    if params[:pid].present?
      @coupon_ids = current_user.valid_coupons.where.not('except_products @> ?', "{#{params[:pid]}}").pluck(:id)
      @discountings = Discounting.where(coupon_id: @coupon_ids).order('expired_on asc, id DESC')
    else
      @discountings = current_user.valid_discountings.order('expired_on asc, id DESC')
    end
    
    if params[:from]
      session[:from_for_coupons] = params[:from]
    end
    @from = params[:from] || session[:from_for_coupons]
    
    if @from.blank?
      @from = "#{settings_wechat_shop_user_path}"
    end
    
    fresh_when(etag: [@discountings, @from])
    
  end
  
  def create
    # puts params
    code = params[:code]
    code = code.downcase if code.present?
    event = DiscountEvent.find_by(code: code)
    if event.blank? or event.coupon_ids.size != 1
      flash[:error] = '无效的优惠码'
      redirect_to new_wechat_shop_coupon_path
      return
    end
    
    coupon = Coupon.find_by(id: event.coupon_ids.first)
    if coupon.present?
      discounting = Discounting.find_by(user_id: current_user.id, coupon_id: coupon.id)
      if discounting.blank?
        Discounting.create!(user_id: current_user.id, coupon_id: coupon.id, expired_on: Time.now + coupon.expired_days.days)
      else
        flash[:error] = '此优惠码已经存入您账户'
      end
      redirect_to wechat_shop_coupons_path(from: settings_wechat_shop_user_path)
    else
      flash[:error] = '无效的优惠码'
      redirect_to new_wechat_shop_coupon_path
    end
    
  end
  
end
