class Order < ActiveRecord::Base
  belongs_to :product, counter_cache: true
  belongs_to :user, inverse_of: :orders
  
  validates :user_id, :product_id, presence: true
  validate :total_fee_greator_discount_fee
  def total_fee_greator_discount_fee
    if total_fee <= discount_fee
      errors.add(:base, '商品总价必须大于优惠')
      return false
    end
  end
  
  scope :no_pay,   -> { with_state(:pending) }
  scope :shipping, -> { with_state(:shipping) }
  
  before_create :generate_order_no
  def generate_order_no
    self.order_no = Time.now.to_s(:number)[2,6] + (Time.now.to_i - Date.today.to_time.to_i).to_s + Time.now.nsec.to_s[0,6]
  end
  
  state_machine initial: :pending do # 默认状态，待付款
    state :paid      # 已付款，待配送
    state :shipping  # 配送中
    state :canceled  # 已取消
    state :completed # 已完成
    
    # 支付
    event :pay do
      transition :pending => :paid
    end
    
    # 配送
    event :ship do
      transition :paid => :shipping
    end
    
    # 取消订单
    # 只能系统管理员取消订单
    event :cancel do
      transition [:pending, :paid] => :canceled
    end
    
    # 确认完成订单，系统管理员确认
    event :complete do
      transition :shipping => :completed
    end
    
  end
  
end
