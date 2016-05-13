class OrderProduct < ActiveRecord::Base
  validates :order_id, presence: true
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
    Order.without_state([:canceled, :completed]).recent.map { |order| ["#{order.product.title} - #{order.order_no}", order.id] }
  end
  
  def self.product_units
    (SiteConfig.product_units || '元/斤,元/个').split(',')
  end
  
end
