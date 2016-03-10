class CreateWechatUsers < ActiveRecord::Migration
  def change
    create_table :wechat_users do |t|
      t.string :uid,   null: false
      t.string :nickname
      t.string :avatar_url
      t.boolean :verified, default: true
      t.string :private_token

      t.timestamps null: false
    end
    add_index :wechat_users, :uid, unique: true
    add_index :wechat_users, :private_token, unique: true
  end
end
