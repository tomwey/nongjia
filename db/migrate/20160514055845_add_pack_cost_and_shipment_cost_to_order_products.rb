class AddPackCostAndShipmentCostToOrderProducts < ActiveRecord::Migration
  def change
    add_column :order_products, :pack_cost, :decimal, precision: 8, scale: 2
    add_column :order_products, :shipment_cost, :decimal, precision: 8, scale: 2
  end
end
