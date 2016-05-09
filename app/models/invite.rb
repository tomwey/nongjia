class Invite < ActiveRecord::Base
  validates :title, :body, :share_body, :link, :inviter_benefits, :invitee_benefits, presence: true
  
  mount_uploader :icon, InviteImageUploader
  
  def self.current_invite_for(user)
    where('score >= ?', user.score).order('score desc').first
  end
  
  def inviter_coupon_value
    Coupon.find_by(id: inviter_benefits).try(:value)
  end
  
  def invitee_coupon_value
    Coupon.find_by(id: invitee_benefits).try(:value)
  end
  
  def share_icon_url
    if icon.blank?
      ActionController::Base.helpers.asset_path('wechat_shop/default_invite_share_icon.png')
    else
      icon.url(:small)
    end
  end
end
