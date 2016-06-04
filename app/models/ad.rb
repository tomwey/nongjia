class Ad < ActiveRecord::Base
  validates :image, presence: true
  mount_uploader :image, AdUploader
end
