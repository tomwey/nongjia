class Order < ActiveRecord::Base
  belongs_to :product, counter_cache: true
  belongs_to :user, inverse_of: :orders
  
  has_one :express
  
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
  scope :paid,     -> { with_state(:paid) }
  scope :recent,   -> { order('id desc') }
  
  before_create :generate_order_no
  def generate_order_no
    self.order_no = Time.now.to_s(:number)[2,6] + (Time.now.to_i - Date.today.to_time.to_i).to_s + Time.now.nsec.to_s[0,6]
    self.shipment_id = user.current_shipment_id
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
    user.shipments.find_by(id: shipment_id) || user.shipment_info
  end
  
  # def send_msg(msg)
  #   Message.create!(content: msg, to_user_type: Message::TO_USER_TYPE_WX, user_id: self.user_id)
  # end
  
  def send_pay_msg
    values = []
    
    fee = [0, (self.total_fee - self.discount_fee)].max
    values << { keyword1: "#{fee}元"  }
    values << { keyword2: self.product.title }
    values << { keyword3: self.shipment_info.try(:region) + self.shipment_info.try(:address)}
    values << { keyword4: self.order_no }
    
    PushMessageJob.perform_later(self.user.id, SiteConfig.order_paid_msg_tpl, order_detail_url, { first: '您的订单支付成功，我们会尽快为您发货。', remark: '如有问题请直接在微信留言，我们会第一时间为您服务！', values: values })
  
    # 新建一条采购统计，不考虑创建失败，如果失败，还可以后台人为添加
    OrderProduct.create(order_id: self.id)
  end
  
  # 奖励推荐人, 如果订单已经支付
  def add_reward!
    if user && user.recommender.present?
      recommender = User.find_by(id: user.recommender)
      if recommender and recommender.marketer? # 推荐人是我们的市场推广人员
        money = Reward::Helper.calcu_rewards(self.total_fee - self.discount_fee, recommender.reward_stragy)
        Reward.create(order_id: self.id, 
                      recommending_id: recommender.id, 
                      recommended_id: user.id, 
                      money: money) if money > 0
      end
      
    end
  end
  
  # 删除奖励，如果订单已经取消
  def remove_reward!
    if user && user.recommender.present?
      reward = Reward.find_by(order_id: self.id, recommending_id: user.recommender)
      reward.delete unless reward.blank?
    end
  end
  
  def order_detail_url
    # return '' if self.order_no
    Setting.upload_url + Rails.application.routes.url_helpers.wechat_shop_order_path(self.order_no)
  end
  
  def send_order_state_msg(first, state, remark = '')
    values = []
    values << { OrderSn: self.order_no }
    values << { OrderStatus: state }
    
    PushMessageJob.perform_later(self.user.id, SiteConfig.order_state_msg_tpl, order_detail_url, { first: first, remark: remark, values: values })
  end
  
  state_machine initial: :pending do # 默认状态，待付款
    state :paid      # 已付款，待配送
    state :shipping  # 配送中
    state :canceled  # 已取消
    state :completed # 已完成
    
    # 支付
    after_transition :pending => :paid do |order, transition|
      order.send_pay_msg
      # 生成奖励记录
      order.add_reward!
    end
    event :pay do
      transition :pending => :paid
    end
    
    # 配送
    after_transition :paid => :shipping do |order, transition|
      order.send_order_state_msg('订单配送中，请耐心等待:)', '已发货')
    end
    event :ship do
      transition :paid => :shipping
    end
    
    # 取消订单
    # 只能系统管理员取消订单
    after_transition [:pending, :paid] => :canceled do |order, transition|
      # order.send_order_state_msg('系统取消了您的订单', '已取消')
      # 所有的取消都要移除采购统计，不考虑删除失败
      OrderProduct.where(order_id: order.id).delete_all
      
      # 取消订单会移除奖励
      order.remove_reward!
    end
    event :cancel do
      transition [:pending, :paid] => :canceled
    end
    
    # 确认完成订单，系统管理员确认
    after_transition :shipping => :completed do |order, transition|
      order.send_order_state_msg('您已经完成了本次购物，谢谢惠顾！', '已完成', '欢迎到微信跟我们留言互动，多提意见！我们会加倍努力的哟:)')
    end
    event :complete do
      transition :shipping => :completed
    end
    
  end
  
end
