class CreateExpresses < ActiveRecord::Migration
  def change
    create_table :expresses do |t|
      t.string :name,   null: false
      t.string :exp_no, null: false
      t.string :company_code
      t.integer :order_id, null: false
      t.timestamps null: false
    end
    add_index :expresses, :exp_no, unique: true
    add_index :expresses, :order_id
  end
end
