class Message < ActiveRecord::Base
  belongs_to :user
  
  TO_USER_TYPE_NORMAL = 1 # 非微信公众号用户，比如以后手机客户端
  TO_USER_TYPE_WX     = 2 # 微信用户
  
  after_create :deliver_message
  def deliver_message
    WXMessageJob.perform_later(content, user.id)
  end
  
end
