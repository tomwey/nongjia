ActiveAdmin.register Partner do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :mobile, :address, :service_scope, :pay_type, :pay_account, :pay_card_no
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
index do
  selectable_column
  column :id
  column :name, sortable: false
  column :address, sortable: false
  column :service_scope, sortable: false
  column '收款信息' do |p|
    "#{p.pay_type} #{p.pay_account} #{p.pay_card_no}"
  end
  actions
end

form do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :name
    f.input :mobile
    f.input :address
    f.input :service_scope
    f.input :pay_type, as: :select, collection: Partner.pay_types, prompt: '-- 请选择收款方式 --'
    f.input :pay_account
    f.input :pay_card_no
  end
  
  actions
end


end
