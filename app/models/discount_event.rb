class DiscountEvent < ActiveRecord::Base
  
  attr_accessor :owners_raw
  
  validates :title, :body, :coupon_id, presence: true
  validates_uniqueness_of :code
  
  belongs_to :coupon
  
  # 生成唯一的优惠推荐码
  before_create :generate_code
  def generate_code
    # 生成6位随机码, 系统的推荐码是5位数
    begin
      self.code = rand(36**5).to_s(36) #SecureRandom.hex(3) #if self.nb_code.blank?
    end while self.class.exists?(:code => code)
  end
  
  def owners_raw
    self.owners.join('\n') if self.owners.present?
  end
  
  def owners_raw=(values)
    self.owners = []
    self.owners = values.split('\n')
  end
  
end

# t.string  :code,           null: false # 活动码
# t.string  :title,          null: false # 活动简介
# t.text    :body,           null: false # 活动详情
# t.date    :expired_on                  # 如果该值为空，表示活动永久有效
# t.integer :score, default: 0           # 活动权重
# t.integer :coupon_id   # 与活动相关的优惠券，不能为空值
# t.integer :owners,     array: true, default: [] # 活动所有者，如果是系统搞营销，那么该字段为空值