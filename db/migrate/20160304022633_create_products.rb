class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.integer :price, null: false, default: 0     # 我们的价格
      t.integer :m_price, null: false, default: 0   # 市场价
      t.string :intro
      t.integer :stock, null: false, default: 1000
      t.references :category, index: true, foreign_key: true
      t.boolean :visible, default: true
      t.boolean :on_sale, default: false

      t.timestamps null: false
    end
  end
end
