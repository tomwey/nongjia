class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mobile, null: false
      t.string :nickname
      t.string :private_token
      t.string :avatar

      t.timestamps null: false
    end
    
    add_index :users, :mobile, unique: true
    add_index :users, :private_token, unique: true
    
  end
end
