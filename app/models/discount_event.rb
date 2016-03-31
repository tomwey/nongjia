class DiscountEvent < ActiveRecord::Base
  
  validates :title, :body, presence: true
  validates_uniqueness_of :code
  
  validate :coupon_empty_check
  def coupon_empty_check
    if self.coupon_ids.empty? or self.coupon_ids.compact.reject(&:blank?).empty?
      errors.add(:base, '至少需要关联一张优惠券')
      return false
    end
  end
  
  before_create :generate_code
  def generate_code
    if self.code.blank?
      # 如果没有输入优惠码，就随机生成一个5位数的优惠码
      begin
        self.code = rand(36**5).to_s(36) #SecureRandom.hex(3) #if self.nb_code.blank?
      end while self.class.exists?(:code => code)
    end
  end
  
  before_save :remove_blank_value_for_coupon_ids
  def remove_blank_value_for_coupon_ids
    self.coupon_ids = self.coupon_ids.compact.reject(&:blank?)
  end
  
end

# t.string  :code,           null: false # 活动码
# t.string  :title,          null: false # 活动简介
# t.text    :body,           null: false # 活动详情
# t.date    :expired_on                  # 如果该值为空，表示活动永久有效
# t.integer :score, default: 0           # 活动权重
# t.integer :coupon_ids, array: true, default: []  # 与活动相关的优惠券，不能为空值