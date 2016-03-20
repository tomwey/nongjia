class Shipment < ActiveRecord::Base
  belongs_to :user, inverse_of: :shipments
end
