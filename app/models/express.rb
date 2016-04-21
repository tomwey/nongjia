class Express < ActiveRecord::Base
  validates :name, :exp_no, :order_id, presence: true
  validates_uniqueness_of :exp_no
  
end
