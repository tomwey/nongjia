class AddAvatarUrlToWechatAuths < ActiveRecord::Migration
  def change
    add_column :wechat_auths, :avatar_url, :string
  end
end
