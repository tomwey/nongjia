class Trade < ActiveRecord::Base
  validates :money, :partner_id, :operator, presence: true
  validates_numericality_of :money
  
  belongs_to :partner
  belongs_to :admin_user, foreign_key: :operator
  
end
