class Product < ActiveRecord::Base
  belongs_to :category, counter_cache: true
  
  validates :title, :price, :m_price, presence: true
  
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
  
  
  def add_visit
    self.class.increment_counter(:visit, self.id)
  end
end
