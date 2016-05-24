ActiveAdmin.register Discounting do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :user_id, :coupon_id, :expired_on
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

# actions :new, :create, :destroy

filter :coupon, as: :check_boxes, label: '优惠券'
filter :user, label: '优惠券所属用户', collection: proc { User.all.map { |u| [u.nickname, u.id] } }
filter :expired_on
filter :discounted_at
filter :created_at

index do
  selectable_column
  column('#', :id)
  column '所属用户',   sortable: false do |discounting|
    discounting.user.try(:nickname) || "用户ID : #{discounting.user.try(:id)}"#discounting.user.try(:mobile)
  end
  column '所属优惠券', sortable: false do |discounting|
    discounting.coupon.title
  end
  column '有效期' do |discounting|
    if discounting.expired_on.blank?
      ''
    elsif discounting.expired?
      '已过期'
    else
      discounting.expired_on.strftime('%Y年%-m月%-d日 到期')
    end
  end
  column '激活时间' do |discounting|
    discounting.discounted_at#.strftime('%%%%%%')
  end
  column '获得优惠券的时间' do |discounting|
    discounting.created_at
  end
  actions defaults: false do |discounting|
    item "删除", admin_discounting_path(discounting), method: :delete, data: { confirm: '你确定吗？' }
  end
end

form do |f|
  f.semantic_errors
  f.inputs do
    f.input :coupon_id, as: :select, collection: Coupon.recent.map { |c| [c.title, c.id] }
    f.input :user_id, label: '所属用户', as: :select, collection: User.where(verified: true).map { |u| [u.nickname || u.private_token, u.id] }
  end
  f.actions
end

end
