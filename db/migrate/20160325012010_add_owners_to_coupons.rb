class AddOwnersToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :owners, :integer, array: true, default: []
  end
end
