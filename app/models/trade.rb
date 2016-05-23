class Trade < ActiveRecord::Base
  validates :money, :partner_id, :operator, presence: true
  validates_numericality_of :money
  
  belongs_to :partner
  belongs_to :admin_user, foreign_key: :operator
  
  validate :orders_empty_check
  def orders_empty_check
    if orders.empty?
      errors.add(:base, '至少需要一个结算订单')
      return false
    end
  end
  
  def pay_orders
    Order.where(id: self.orders)
  end
  
  def self.preferred_orders
    order_ids = Trade.all.pluck(:orders).to_a.flatten
    Order.where.not(id: order_ids).without_state([:canceled, :pending]).map { |order| [order.product.title + ' - ' + order.order_no + ' - ' + order.shipment_info.try(:name) || order.shipment_info.try(:mobile), order.id] }
  end
  
  # before_create :calcu_payment
  # def calcu_payment
  #   if self.money.blank?
  #     ops = OrderProduct.where(order_id: orders)
  #     sum = 0
  #     ops.each do |op|
  #       unless op.blank?
  #         sum += ( op.sale_benefits.to_f - ( op.total_benefits.to_f * 0.3 ) - op.pack_cost.to_f ) # 我们获得利润的30%
  #       end
  #     end
  #     
  #     self.money = sum.to_s
  #   end
  #   
  # end
  
  before_save :remove_blank_value_for_orders
  def remove_blank_value_for_orders
    self.orders = self.orders.compact.reject(&:blank?)
  end
  
end
