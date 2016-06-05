class FlashSale < ActiveRecord::Base
  validates :begin_time, :end_time, :product_ids, presence: true
  
  validate :begin_time_lower_end_time
  def begin_time_lower_end_time
    unless self.begin_time < self.end_time
      errors.add(:base, '开始时间必须小于结束时间')
    end
  end
  
  def self.preferred_products(me)
    on_flash_sale_ids = FlashSale.where.not(id: me.id).map(&:product_ids).flatten
    products = Product.where(on_sale: false).where.not(id: on_flash_sale_ids).order('id desc')
    products.map { |p| [p.title, p.id] }
  end
  
  before_save :remove_blank_value_for_product_ids
  def remove_blank_value_for_product_ids
    self.product_ids = self.product_ids.compact.reject(&:blank?)
  end
end
