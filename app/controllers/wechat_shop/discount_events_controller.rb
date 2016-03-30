class WechatShop::DiscountEventsController < WechatShop::ApplicationController
  
  before_filter :require_user
  before_filter :check_user
  
  def index
    @event = DiscountEvent.where('owners @> ?', "{#{current_user.id}}").order('score DESC').first
    @page_title = "推荐顾客得优惠"
  end
  
end
