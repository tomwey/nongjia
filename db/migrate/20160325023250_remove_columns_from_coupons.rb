class RemoveColumnsFromCoupons < ActiveRecord::Migration
  def change
    remove_index :coupons, :user_id if index_exists?(:coupons, :user_id)
    remove_column :coupons, :user_id
    remove_column :coupons, :actived_at
    remove_column :coupons, :owners
  end
end
