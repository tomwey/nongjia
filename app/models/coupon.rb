########################################################################################
# 重要字段说明
# title 优惠券标题描述，不能为空，例如：5折优惠或抵扣5元
# body  优惠券详情描述，可以为空
# note  优惠券使用说明，可以为空，例如：仅限成都，最大优惠8元
# value 优惠额度，     不能为空，该值与coupon_type的值有关，
#                             如果为抵扣现金类型，那么该值为具体的抵扣额度，
#                             如果为打折类型，那么该值为折扣百分数，例如：6.5折该值为65
# max_value 最大优惠额度，不能为空，表示该优惠券的最大优惠额度，
#                               如果coupon_type为抵扣现金类型，那么该字段的值为value字段的值，
#                               如果coupon_type为打折类型，那么该字段的值为我们指定
# expired_days 有效天数，不能为空，从用户获取该优惠券的时间加上该字段所表示的过期天数，就是该优惠券的有效期
########################################################################################

class Coupon < ActiveRecord::Base
  
  has_many :discountings
  has_many :users, through: :discountings
  
  # 定义优惠券类型
  DISCOUNT = 1 # 打折类型
  CASH     = 2 # 抵扣现金类型
  
  # 定义优惠券发放方式
  USE_TYPE_SYS   = 1 # 系统直接发放
  USE_TYPE_EVENT = 2 # 通过活动获取
  
  COUPON_TYPES = [['打折', DISCOUNT], ['抵扣现金', CASH]]
  USE_TYPES    = [['系统直接发放', USE_TYPE_SYS], ['参加活动发放', USE_TYPE_EVENT]]
  
  validates :title, :value, :max_value, :expired_days, :coupon_type, :use_type, presence: true
  
  scope :recent, -> { order('id DESC') }
  
  def current_value_info
    case(coupon_type)
    when Coupon::DISCOUNT then "#{value / 10.0}折"
    when Coupon::CASH     then "¥#{value}"
    else ''
    end
  end
  
  before_save :remove_blank_value_for_except_products
  def remove_blank_value_for_except_products
    self.except_products = self.except_products.compact.reject(&:blank?)
  end
  
  def except_product_titles
    Product.where(id: self.except_products).map { |p| p.title }
  end
  
  def coupon_type_info
    case(coupon_type)
    when Coupon::DISCOUNT then "打折"
    when Coupon::CASH     then "抵扣现金"
    else '未知'
    end
  end
  
  def use_type_info
    case(use_type)
    when Coupon::USE_TYPE_SYS   then "系统直接发放"
    when Coupon::USE_TYPE_EVENT then "参加活动发放"
    else '未知'
    end
  end
  
  def send_all!
    if use_type == Coupon::USE_TYPE_SYS
      user_ids = self.users.pluck(:id)
      valid_users = User.where(verified: true).where.not(id: user_ids)
      if valid_users.any?
        self.users << valid_users
        self.save!
      end
    end
  end
  
  def send_random!
    if use_type == Coupon::USE_TYPE_SYS
      rand_num = User.count / 3
      user_ids = self.users.pluck(:id)
      valid_users = User.where(verified: true).where.not(id: user_ids).limit(rand_num).order("RANDOM()") # RANDOM()是postgresql的函数 RAND()是mysql的函数
      if valid_users.any?
        self.users << valid_users
        self.save!
      end
    end
  end
  
  # 计算优惠的价格
  def discount_value_for(origin_value)
    
    origin_value = origin_value.to_i
    
    case self.coupon_type
    when Coupon::DISCOUNT
      factor = ( 100 - self.value ) / 100.0
      [(factor * origin_value).ceil, self.max_value].min
    when Coupon::CASH then self.value
    else 0
    end
  end
  
end

