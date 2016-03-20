class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :name, null: false
      t.string :mobile, null: false
      t.string :region
      t.string :address, null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
