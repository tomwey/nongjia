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
