class CreateDiscountings < ActiveRecord::Migration
  def change
    create_table :discountings do |t|
      t.belongs_to :coupon, index: true
      t.belongs_to :user, index: true
      t.datetime :discounted_at

      t.timestamps null: false
    end
  end
end
