class WechatUser < ActiveRecord::Base
  def self.from_wechat(xml)
    u = WechatUser.where(uid: xml.from_user).first
    if u.blank?
      u = WechatUser.create!(uid: xml.from_user)
    end
    u
  end
  
  def is_valid?
    self.verified == true
  end
end
