class Discounting < ActiveRecord::Base
  belongs_to :coupon
  belongs_to :user
  
  validates_presence_of :user_id, :coupon_id
  
  scope :unused, -> { where(discounted_at: nil) }
  scope :unexpired, -> { where('expired_on > ?', Time.now - 1.days) }
  
  before_create :generate_expired_on
  def generate_expired_on
    self.expired_on = (Time.now + coupon.expired_days.days) if self.expired_on.blank?
  end
  
  # 通知用户获得了一张优惠券
  after_create :notify_user
  def notify_user
    # PushMessageJob.perform_later(self.user.id, SiteConfig.coupon_fetch_msg_tpl, my_coupons_url, { first: '送您一张优惠券', remark: '如有问题请直接在微信留言，我们会第一时间为您服务！', values: values })
  end
  
  def my_coupons_url
    # return '' if self.order_no
    Setting.upload_url + Rails.application.routes.url_helpers.wechat_shop_coupons_path
  end
  
  def expired?
    Time.now > self.expired_on.end_of_day
  end
  
  # 计算优惠的价格
  def discount_value_for(origin_value)
    return 0 if self.expired?
    return 0 if self.coupon.blank?
    
    self.coupon.discount_value_for(origin_value)
  end
  
end
