class OrderProduct < ActiveRecord::Base
  validates :order_id, presence: true
  
  validates_numericality_of :quantity, :shipment_quantity, :price, :pack_cost, :shipment_cost, :pay_buyer_loss, on: :save
  
  belongs_to :order
  
  mount_uploaders :product_images, PictureUploader
  
  before_create :generate_sku
  def generate_sku
    # self.sku = (1..9).to_a.sample.to_s + rand.to_s[2..9]
    # 生成唯一9位数sku
    self.sku = loop do
      random_sku = (1..9).to_a.sample.to_s + rand.to_s[2..9]
      break random_sku unless self.class.exists?(sku: random_sku)
    end
  end
  
  def self.preferred_orders
    order_ids = OrderProduct.all.pluck(:order_id)
    Order.where.not(id: order_ids).without_state([:canceled, :completed]).recent.map { |order| ["#{order.product.title} - #{order.order_no} - #{order.shipment_info.try(:name) || order.shipment_info.try(:mobile)}", order.id] }
  end
  
  def self.product_units
    (SiteConfig.product_units || '元/斤,元/个').split(',')
  end
  
  # 包装以及物流成本
  def extra_cost
    return 0 if self.pack_cost.blank? or self.shipment_cost.blank?
    (self.pack_cost + self.shipment_cost).to_f
  end
  
  # 采购成本
  def purchase_cost
    return 0 if quantity.blank? or price.blank?
    (self.quantity.to_f * self.price).to_f
  end
  
  # 净营收
  def sale_benefits
    return 0 if order.blank?
    (order.total_fee - order.discount_fee).to_f
  end
  
  # 总成本
  def total_cost
    self.extra_cost + self.purchase_cost
  end
  
  # 总收益
  def total_benefits
    self.sale_benefits - self.total_cost
  end
  
end
