class AddExceptProductsToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :except_products, :integer, array: true, default: []
  end
end
