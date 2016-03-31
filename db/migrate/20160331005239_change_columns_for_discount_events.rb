class ChangeColumnsForDiscountEvents < ActiveRecord::Migration
  def change
    remove_index :discount_events, :coupon_id  if index_exists?(:discount_events, :coupon_id)
    remove_column :discount_events, :coupon_id
    remove_column :discount_events, :owners
    add_column :discount_events, :coupon_ids, :integer, array: true, default: []
  end
end
