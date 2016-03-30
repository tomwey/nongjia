class DiscountEvent < ActiveRecord::Base
  
  attr_accessor :owners_raw, :coupon_ids_raw
  
  validates :title, :body, presence: true
  validates_uniqueness_of :code
  
  validate :coupon_ids_empty_check
  def coupon_ids_empty_check
    if self.coupon_ids.empty?
      errors.add(:base, '至少需要关联一张优惠券')
      return false
    end
  end
  
  # 生成唯一的优惠推荐码
  before_create :generate_code
  def generate_code
    # 生成6位随机码, 系统的推荐码是5位数
    begin
      self.code = SecureRandom.hex(3) #if self.nb_code.blank?
    end while self.class.exists?(:code => code)
  end
  
  def owners_raw
    self.owners.join('\n') if self.owners.present?
  end
  
  def owners_raw=(values)
    self.owners = []
    self.owners = values.split('\n')
  end
  
  def coupon_ids_raw
    self.coupon_ids.join('\n') if self.coupon_ids.present?
  end
  
  def coupon_ids_raw=(values)
    self.coupon_ids = []
    self.coupon_ids = values.split('\n')
  end
  
end

# t.string  :code,           null: false # 活动码
# t.string  :title,          null: false # 活动简介
# t.text    :body,           null: false # 活动详情
# t.date    :expired_on                  # 如果该值为空，表示活动永久有效
# t.integer :score, default: 0           # 活动权重
# t.integer :coupon_ids, array: true, default: [] # 与活动相关的优惠券，不能为空值
# t.integer :owners,     array: true, default: [] # 活动所有者，如果是系统搞营销，那么该字段为空值