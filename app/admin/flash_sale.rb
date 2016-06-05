ActiveAdmin.register FlashSale do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :begin_time, :end_time, :title, :body, { product_ids: [] }
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
    f.input :begin_time, as: :string, placeholder: '2016-01-03 10:00:00'
    f.input :end_time, as: :string, placeholder: '2016-01-05 10:00:00'
    f.input :product_ids, as: :check_boxes, collection: FlashSale.preferred_products(f.object)
  end
  
  actions
end


end
