ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  menu priority: 168, label: "管理员"

  actions :all, except: [:destroy, :edit, :update]

  filter :email
  filter :current_sign_in_at
  filter :last_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_ip
  filter :created_at
  
  index do
    selectable_column
    column('#', :id, sortable: false) { |user| link_to user.id, admin_admin_user_path(user) }
    column(:email, sortable: false) { |user| link_to user.email, admin_admin_user_path(user) }
    column :current_sign_in_at
    column :current_sign_in_ip, sortable: false
    column :last_sign_in_at
    column :last_sign_in_ip, sortable: false
    column :sign_in_count
    column :created_at
    # actions defaults: false do |user|
    #   # item '修改密码', edit_admin_
    # end
  end
  
  show do 
    attributes_table do
      row :id
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_at
      row :last_sign_in_ip
      row :created_at
    end
  end

  form do |f|
    f.inputs "修改密码" do
      f.input :current_password
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
