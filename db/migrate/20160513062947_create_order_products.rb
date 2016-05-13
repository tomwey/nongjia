class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products do |t|
      t.string :sku, null: false
      t.string :product_images, array: true, default: []
      t.integer :order_id
      t.decimal :price, precision: 8, scale: 2
      t.string :unit
      t.string :quantity
      t.string :shipment_quantity

      t.timestamps null: false
    end
    add_index :order_products, :sku, unique: true
    add_index :order_products, :order_id
  end
end
