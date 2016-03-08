class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :mobile,  null: false
      t.string :region,  null: false
      t.string :address, null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
