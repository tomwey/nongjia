ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:nickname, :avatar, :mobile], :on, :model

actions :index, :show

menu priority: 2, label: "用户"

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
# member_action :lock, method: :put do
#   resource.lock!
#   redirect_to admin_users_path, notice: resource.verified ? 'Locked!' : 'Cancel Locked!'
# end
filter :nickname
filter :mobile

scope :all, default: true do |users|
  users.where(visible: true)
end

scope '正常用户', :verified do |users|
  users.where(verified: true)
end

index do
  selectable_column
  column("#", :id) { |user| link_to user.id, admin_user_path(user) }
  column "头像" do |user|
    link_to image_tag(user.avatar_url(:large), size: '60x60'), admin_user_path(user)
  end
  column(:nickname, sortable: false) do |user|
    user.nickname || user.mobile
  end
  column :mobile, sortable: false
  column "Token", :private_token, sortable: false
  column "账号可用" do |user|
    user.verified ? "可用" : "禁用"
  end
  column "三方认证" do |user|
    user.authorizations.map(&:provider).join(',')
  end
  actions defaults: false do |user|
    if user.verified
      item "禁用", block_admin_user_path(user), method: :put
    else
      item "启用", unblock_admin_user_path(user), method: :put
    end
  end
  
end

# 批量禁用账号
batch_action :block do |ids|
  batch_action_collection.find(ids).each do |user|
    user.block!
  end
  redirect_to collection_path, alert: "已经禁用"
end

# 批量启用账号
batch_action :unblock do |ids|
  batch_action_collection.find(ids).each do |user|
    user.unblock!
  end
  redirect_to collection_path, alert: "已经启用"
end

member_action :block, method: :put do
  resource.block!
  redirect_to admin_users_path, notice: "已禁用"
end

member_action :unblock, method: :put do
  resource.unblock!
  redirect_to admin_users_path, notice: "取消禁用"
end

show do
  attributes_table do
    row :id
    row :avatar do |user|
      image_tag user.avatar_url(:large)
    end
    row :nickname
    row :mobile
    row :private_token
    row :verified do |user|
      user.verified ? "可用" : "禁用"
    end
    row '三方认证' do |user|
      ul do
        user.authorizations.each do |auth|
          li do
            auth.provider + ': ' + auth.uid
          end
        end
      end
    end
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :nickname
    f.input :avatar, as: :file
  end
  
  actions
end


end