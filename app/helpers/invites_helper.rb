module InvitesHelper
  def invite_icon_tag(invite)
    return '' if invite.blank?
    
    if invite.icon.blank?
      image_tag 'wechat_shop/default_invite_share_icon.png', class: 'img-responsive'
    else
      image_tag invite.icon.url(:big), class: 'img-responsive'
    end
    
  end
end