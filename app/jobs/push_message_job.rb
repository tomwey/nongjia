class PushMessageJob < ActiveJob::Base
  queue_as :messages
  
  def perform(user_id, tpl, url = '', data = {})
    # puts '发送消息: ' + user_id.to_s
    user = User.find_by(id: user_id)
    return if user.blank? or !user.verified
    
    if user.wechat_auth
      to = user.wechat_auth.try(:open_id)
    else
      to = ''
    end
    WX::Message.send(to, tpl, url, data)
    
  end
end