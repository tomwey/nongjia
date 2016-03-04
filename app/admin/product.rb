ActiveAdmin.register Product do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:category_id, :title, :price, :m_price, :intro, :stock, {images:[]}], :on, :model
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
  column :title
  column :category
  column :price
  column :m_price
  column :intro
  column :stock
  column :on_sale
  column :images do |product|
    ul do
      product.images.each do |img|
        li do
          image_tag(img.url(:small))
        end
      end
    end
  end
  actions
  
end

show do
  attributes_table do
    row :title
    row :category
    row :price
    row :m_price
    row :intro
    row :stock
    
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :category
    f.input :title
    f.input :price
    f.input :m_price
    f.input :images, as: :file, input_html: { multiple: true }
    f.input :intro
    f.input :stock
  end
  
  actions
end


end
