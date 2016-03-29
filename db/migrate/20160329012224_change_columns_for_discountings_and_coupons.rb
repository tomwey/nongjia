class ChangeColumnsForDiscountingsAndCoupons < ActiveRecord::Migration
  def change
    remove_column :coupons, :expired_on
    add_column :coupons, :expired_days, :integer # 从用户获取该优惠券的时间加上该字段所表示的过期天数，就是该优惠券的有效期
    add_column :discountings, :expired_on, :date
  end
end
