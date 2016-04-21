ActiveAdmin.register Express do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
menu priority: 18, label: "快递"

permit_params :name, :exp_no, :order_id, :company_code
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

form do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :name
    f.input :exp_no
    f.input :order_id, as: :select, collection: Order.shipping.order('id DESC').map { |o| [o.order_no, o.id] }
    f.input :company_code
  end
  
  actions
end


end
