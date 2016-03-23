ActiveAdmin.register Page do

menu priority: 6, label: "文档"

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
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
  f.inputs do
    f.input :title
    f.input :slug
    f.input :body, as: :html_editor
  end
  
  # f.buttons
end

end
