class AddShipmentIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipment_id, :integer
  end
end
