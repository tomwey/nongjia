class Category < ActiveRecord::Base
  
  has_many :products, dependent: :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  mount_uploader :image, ImageUploader
end
