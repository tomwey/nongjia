class ChangeColumnForDiscountEvents < ActiveRecord::Migration
  def change
    remove_column :discount_events, :coupon_ids
    add_column :discount_events, :coupon_id, :integer
    add_index  :discount_events, :coupon_id
  end
end
