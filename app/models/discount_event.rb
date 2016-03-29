class DiscountEvent < ActiveRecord::Base
  validates :title, :body, presence: true
  validates_uniqueness_of :code
  
  validate :coupon_ids_empty_check
  def coupon_ids_empty_check
    if self.coupon_ids.empty?
      errors.add(:base, '至少需要关联一张优惠券')
      return false
    end
  end
  
end

# t.string  :code,           null: false # 活动码
# t.string  :title,          null: false # 活动简介
# t.text    :body,           null: false # 活动详情
# t.date    :expired_on                  # 如果该值为空，表示活动永久有效
# t.integer :score, default: 0           # 活动权重
# t.integer :coupon_ids, array: true, default: [] # 与活动相关的优惠券，不能为空值
# t.integer :owners,     array: true, default: [] # 活动所有者，如果是系统搞营销，那么该字段为空值