class Reward < ActiveRecord::Base
  validates :money, :recommending_id, :recommended_id, :order_id, presence: true
  
end
