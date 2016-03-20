class AddCurrentShipmentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_shipment_id, :integer
  end
end
