class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.string :money, null: false
      t.integer :partner_id

      t.timestamps null: false
    end
    add_index :trades, :partner_id
  end
end
