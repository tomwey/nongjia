ActiveAdmin.register Category do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:name, :image, :sort], :on, :model
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
  column :name
  column :image do |category|
    image_tag category.image.url(:small)
  end
  column :sort
  actions
end

show do
  attributes_table do
    row :id
    row :name
    row :image do |category|
      image_tag category.image.url(:thumb)
    end
    row :products_count
    row :sort
  end
end


end
