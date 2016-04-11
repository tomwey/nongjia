ActiveAdmin.register Invite do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :body, :link, :icon, :inviter_benefits, :invitee_benefits, :score

filter :title
filter :body
filter :inviter_benefits
filter :invitee_benefits
filter :score
filter :created_at

index do
  selectable_column
  column('#',:id)
  column :title, sortable: false
  column :body, sortable: false
  column(:link, sortable: false) { |invite| link_to invite.link, invite.link, target: '__blank' }
  column :icon, sortable: false do |invite|
    if invite.icon.blank?
      image_tag 'wechat_shop/default_invite_share_icon.png', class: "img-circle"
    else
      image_tag invite.icon.url(:large), class: 'img-circle'
    end
  end
  
  column :inviter_benefits do |invite|
    "#{invite.inviter_benefits}元现金券"
  end
  column :invitee_benefits do |invite|
    "#{invite.invitee_benefits}元现金券"
  end
  column :score
  column :created_at
  column :updated_at
  actions
end

form do |f|
  f.inputs "邀请信息" do
    f.input :title, placeholder: '活动标题'
    f.input :body, placeholder: '活动详情，会在用户推荐页面展示'
    f.input :link, placeholder: '活动链接地址，该地址是微信分享后，可以点击的地址'
    f.input :icon, placeholder: '活动图标，微信分享的小图标'
    f.input :inviter_benefits, placeholder: '邀请人得到的现金券面额，整数以元为单位'
    f.input :invitee_benefits, placeholder: '被邀请人得到的现金券面额，整数以元为单位'
    f.input :score, placehodler: '该邀请的权重，与用户的score字段对应，以后有可能根据不同的score获得不同的邀请活动'
  end
  f.actions
end


end
