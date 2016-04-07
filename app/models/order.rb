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
  
  # 提示下单成功
  after_create :notify_user
  def notify_user
    
  end
  
  state_machine initial: :pending do # 默认状态，待付款
    state :paid      # 已付款，待配送
    state :shipping  # 配送中
    state :canceled  # 已取消
    state :completed # 已完成
    
    # 支付
    after_transition :pending => :paid do |order, transition|
      Message.create!(content: '您已成功支付订单，我们会尽快发货，谢谢！', to_user_type: Message::TO_USER_TYPE_WX, user_id: user.id)
    end
    event :pay do
      transition :pending => :paid
    end
    
    # 配送
    after_transition :paid => :shipping do |order, transition|
      Message.create!(content: '订单配送中，请耐心等待', to_user_type: Message::TO_USER_TYPE_WX, user_id: user.id)
    end
    event :ship do
      transition :paid => :shipping
    end
    
    # 取消订单
    # 只能系统管理员取消订单
    after_transition [:pending, :paid] => :canceled do |order, transition|
      Message.create!(content: '系统取消了您的订单', to_user_type: Message::TO_USER_TYPE_WX, user_id: user.id)
    end
    event :cancel do
      transition [:pending, :paid] => :canceled
    end
    
    # 确认完成订单，系统管理员确认
    after_transition :shipping => :completed do |order, transition|
      Message.create!(content: '已经完成了本次订单，谢谢惠顾！', to_user_type: Message::TO_USER_TYPE_WX, user_id: user.id)
    end
    event :complete do
      transition :shipping => :completed
    end
    
  end
  
end
