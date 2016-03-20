class Order < ActiveRecord::Base
  belongs_to :product, counter_cache: true
  belongs_to :user, inverse_of: :orders
end
