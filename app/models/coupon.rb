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
# expired_on 有效期，不能为空，服务器通过检测当前使用时间是否小于有效期当天23:59:59来判断是否有效；
#                           如果想要保证当前优惠券不过期，可以设置一个很大的日期，例如：3999-12-31
# actived_at 激活优惠券的时间，可以为空，如果为空表示未使用过，否则表示已经使用了该优惠券，自动失效
########################################################################################

class Coupon < ActiveRecord::Base
  # belongs_to :user
  
  # 定义优惠券类型
  DISCOUNT = 1 # 打折类型
  CASH     = 2 # 抵扣现金类型
  
  validates :title, :value, :max_value, :expired_on, :coupon_type, presence: true
  
  scope :no_active, -> { where(actived_at: nil) }
  scope :recent, -> { order('id DESC') }
  scope :unexpired, -> { where('expired_on > ?', Time.now - 1.days) }
  
  def self.for_owners(user_ids)
    # 查询属于指定用户的或者属于所有用户的优惠券
    if user_ids.is_a?(Array)
      id_values = user_ids.join(',')
    else
      id_values = user_ids
    end
    where("owners = '{}' or owners @> ?", "{#{id_values}}")
  end
  
  def expired?
    Time.now > self.expired_on.end_of_day
  end
  
  def actived?
    self.actived_at.present?
  end
  
  def current_value_info
    case(coupon_type)
    when Coupon::DISCOUNT then "#{value / 10.0}折"
    when Coupon::CASH     then "¥{value}"
    else ''
    end
  end
  
  # 计算优惠的价格
  def discount_value_for(origin_value)
    return 0 if self.expired?
    return 0 if self.actived?
    
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

# t.string :title,      null: false # 优惠券标题描述
# t.string :body                    # 优惠券详情描述
# t.string :note                    # 优惠券使用说明
# t.integer :value,     null: false # 优惠券的优惠额度，与coupon_type相关
# t.integer :max_value, null: false # 最大优惠额度，与coupon_type相关
# t.date :expired_on,   null: false # 有效期
# t.datetime :actived_at            # 优惠券使用时间
# t.integer :coupon_type, default: Coupon::DISCOUNT # 默认是打折类型
# t.references :user, index: true, foreign_key: true

