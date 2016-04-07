class WXMessageJob < ActiveJob::Base
  queue_as :messages
  
  def perform(msg, user_id)
    @user = User.find_by(id: user_id)
    if @user && @user.verified
      WX::Message.send(msg, @user.wechat_auth.open_id) if @user.wechat_auth.present?
    end
  end
end