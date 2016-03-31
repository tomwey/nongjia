class AddUseTypeToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :use_type, :integer, default: Coupon::USE_TYPE_SYS
  end
end
