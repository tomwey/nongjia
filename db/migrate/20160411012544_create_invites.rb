class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :title, null: false             # 分享标题
      t.string :body,  null: false             # 分享详情
      t.string :link,  null: false             # 分享的活动连接地址
      t.string :icon                           # 分享的icon
      t.integer :inviter_benefits, default: 0  # 邀请人所得的现金优惠券id
      t.integer :invitee_benefits, default: 0  # 被邀请人所得的现金优惠券id
      t.integer :score,            default: 0  # 保留字段，与每个用户的score字段对应

      t.timestamps null: false
    end
    add_index :invites, :score
  end
end
