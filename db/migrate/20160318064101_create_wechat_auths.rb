class CreateWechatAuths < ActiveRecord::Migration
  def change
    create_table :wechat_auths do |t|
      t.string :open_id,      null: false
      t.string :access_token, null: false
      t.references :user, index: true, foreign_key: true
      t.string :union_id

      t.timestamps null: false
    end
    add_index :wechat_auths, :open_id, unique: true
    add_index :wechat_auths, :union_id, unique: true
  end
end
