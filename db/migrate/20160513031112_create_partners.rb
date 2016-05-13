class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.string :mobile
      t.string :address
      t.string :service_scope
      t.string :pay_type
      t.string :pay_card_no
      t.integer :orders_count, default: 0

      t.timestamps null: false
    end
  end
end
