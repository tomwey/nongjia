class Discounting < ActiveRecord::Base
  belongs_to :coupon
  belongs_to :user
  
  validates_presence_of :user_id, :coupon_id
end
