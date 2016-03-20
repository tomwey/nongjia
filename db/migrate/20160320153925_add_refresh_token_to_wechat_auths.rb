class AddRefreshTokenToWechatAuths < ActiveRecord::Migration
  def change
    add_column :wechat_auths, :refresh_token, :string
  end
end
