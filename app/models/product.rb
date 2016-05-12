class Product < ActiveRecord::Base
  belongs_to :category, counter_cache: true
  
  validates :title, :price, :m_price, presence: true
  
  mount_uploaders :images, PictureUploader
  mount_uploaders :detail_images, DetailImageUploader
  
  scope :no_delete, -> { where(visible: true) }
  scope :saled,     -> { where(on_sale: true) }
  scope :sorted,    -> { order('sort desc') }
  scope :hot,       -> { order('visit desc, orders_count desc') }
  scope :recent,    -> { order('id desc') }
  
  # 价格检查
  validate :price_lower_than_or_equal_to_m_price
  def price_lower_than_or_equal_to_m_price
    if price > m_price
      errors.add(:base, '我们的价格不能大于市场价')
      return false
    end
  end
  
  # images不能为空检查
  validate :images_not_empty
  def images_not_empty
    if images.empty?
      errors.add(:base, '产品缩略图不能为空，至少需要一张图片')
      return false  
    end
  end
  
  after_update :update_orders_304_cache
  def update_orders_304_cache
    CacheVersion.save_product_latest_updated_time(Time.now)
  end
  
  # 是否有货
  def has_stock?
    self.stock.to_i > 0
  end
  
  def sale!
    self.on_sale = true
    self.save!
  end
  
  def unsale!
    self.on_sale = false
    self.save!
  end
  
  def add_visit
    self.class.increment_counter(:visit, self.id)
  end
end
