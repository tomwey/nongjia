class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :recommending_id # 推荐人ID
      t.integer :recommended_id  # 被推荐人ID
      t.integer :order_id
      t.decimal :money, precision: 8, scale: 2, default: 0

      t.timestamps null: false
    end
    add_index :rewards, :recommending_id
    add_index :rewards, [:recommending_id, :order_id], unique: true # 同一个订单，只会奖励推荐人一次
  end
end
