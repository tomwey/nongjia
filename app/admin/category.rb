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

menu priority: 3, label: "类别"

actions :all, except: [:destroy]

filter :name
filter :sort
filter :created_at

index do
  selectable_column
  column('#', :id, sortable: true) { |c| link_to c.id, admin_category_path(c) }
  column(:name, sortable: false) { |c| link_to c.name, admin_category_path(c) }
  column :image, sortable: false do |category|
    image_tag category.image.url(:small)
  end
  column :products_count
  column :sort
  actions defaults: false do |c|
    item '编辑', edit_admin_category_path(c)
  end
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
