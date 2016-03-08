class Authorization < ActiveRecord::Base
  belongs_to :user, inverse_of: :authorizations
  
  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }
end
