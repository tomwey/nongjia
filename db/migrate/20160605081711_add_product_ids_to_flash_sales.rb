class AddProductIdsToFlashSales < ActiveRecord::Migration
  def change
    add_column :flash_sales, :product_ids, :integer, array: true, default: []
  end
end
