class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :title,      null: false # 优惠券标题描述
      t.string :body                    # 优惠券详情描述
      t.string :note                    # 优惠券使用说明
      t.integer :value,     null: false # 优惠券的优惠额度，与coupon_type相关
      t.integer :max_value, null: false # 最大优惠额度，与coupon_type相关
      t.date :expired_on,   null: false # 有效期
      t.datetime :actived_at            # 激活优惠券的时间
      t.integer :coupon_type, default: Coupon::DISCOUNT # 默认是打折类型
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
