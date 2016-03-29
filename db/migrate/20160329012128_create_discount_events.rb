class CreateDiscountEvents < ActiveRecord::Migration
  def change
    create_table :discount_events do |t|
      t.string  :code,           null: false # 活动码
      t.string  :title,          null: false # 活动简介
      t.text    :body,           null: false # 活动详情
      t.date    :expired_on                  # 如果该值为空，表示活动永久有效
      t.integer :score, default: 0           # 活动权重
      t.integer :coupon_ids, array: true, default: [] # 与活动相关的优惠券，不能为空值
      t.integer :owners,     array: true, default: [] # 活动所有者，如果是系统搞营销，那么该字段为空值

      t.timestamps null: false
    end
    add_index :discount_events, :code, unique: true
  end
end
