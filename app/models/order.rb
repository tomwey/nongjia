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
    # Message.create!(content: '成功下单，快去支付吧！如果超过30分钟未支付，系统会自动取消订单哦！', to_user_type: Message::TO_USER_TYPE_WX, user_id: user.id)
    CancelOrderJob.set(wait: 30.minutes).perform_later(self.id)
  end
  
  def state_info
    case self.state.to_sym
    when :pending then '待付款'
    when :paid then '待配送'
    when :shipping then '配送中'
    when :canceled then '已取消'
    when :completed then '已完成'
    else ''
    end
  end
  
  def shipment_info
    user.shipment_info
  end
  
  # def send_msg(msg)
  #   Message.create!(content: msg, to_user_type: Message::TO_USER_TYPE_WX, user_id: self.user_id)
  # end
  
  state_machine initial: :pending do # 默认状态，待付款
    state :paid      # 已付款，待配送
    state :shipping  # 配送中
    state :canceled  # 已取消
    state :completed # 已完成
    
    # 支付
    after_transition :pending => :paid do |order, transition|
      PushMessageJob.perform_later(order.user.id, SiteConfig.order_paid_msg_tpl, '', { first: '我们已收到您的货款，开始打包商品，请耐心等待:)', remark: '如有问题请直接在微信留言，我们会第一时间为您服务！', values: ["#{order.total_fee - order.discount_fee}元", "#{order.product.title}"] })
    end
    event :pay do
      transition :pending => :paid
    end
    
    # 配送
    after_transition :paid => :shipping do |order, transition|
      PushMessageJob.perform_later(order.user.id, SiteConfig.order_state_msg_tpl, '', { first: '订单配送中，请耐心等待:)', remark: '', values: ["#{order.order_no}", "已发货"] })
      # order.send_msg('订单配送中，请耐心等待')
      # Message.create!(content: '订单配送中，请耐心等待', to_user_type: Message::TO_USER_TYPE_WX, user_id: self.user_id)
    end
    event :ship do
      transition :paid => :shipping
    end
    
    # 取消订单
    # 只能系统管理员取消订单
    after_transition [:pending, :paid] => :canceled do |order, transition|
      # order.send_msg('系统取消了您的订单')
      PushMessageJob.perform_later(order.user.id, SiteConfig.order_state_msg_tpl, '', { first: '系统人工取消了您的订单', remark: '', values: ["#{order.order_no}", "已取消"] })
      # Message.create!(content: '系统取消了您的订单', to_user_type: Message::TO_USER_TYPE_WX, user_id: self.user_id)
    end
    event :cancel do
      transition [:pending, :paid] => :canceled
    end
    
    # 确认完成订单，系统管理员确认
    after_transition :shipping => :completed do |order, transition|
      # order.send_msg('已经完成了本次订单，谢谢惠顾！')
      PushMessageJob.perform_later(order.user.id, SiteConfig.order_state_msg_tpl, '', { first: '您已经完成了本次购物，谢谢惠顾！', remark: '欢迎到微信跟我们留言互动，多提意见！我们会加倍努力的哟:)', values: ["#{order.order_no}", "已完成"] })
      # Message.create!(content: '已经完成了本次订单，谢谢惠顾！', to_user_type: Message::TO_USER_TYPE_WX, user_id: self.user_id)
    end
    event :complete do
      transition :shipping => :completed
    end
    
  end
  
end
