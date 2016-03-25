ActiveAdmin.register Product do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:category_id, :title, :price, :m_price, :intro, :stock, {images:[]}, {detail_images:[]}], :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
menu priority: 4, label: "产品"

actions :index, :show, :new, :create, :edit, :update

filter :title
filter :category
filter :price
filter :m_price
filter :intro
filter :created_at

scope :all, default: true
scope '上架', :on_sale do |products|
  products.where(on_sale: true)
end

index do
  selectable_column
  column('#',:id) { |product| link_to product.id, admin_product_path(product) }
  column(:title, sortable: false) { |product| link_to product.title, admin_product_path(product) }
  column :category, sortable: false
  column :price
  column :m_price
  column :intro, sortable: false
  column :stock
  column '产品状态', :on_sale, sortable: false do |product|
    product.on_sale ? "上架" : "下架"
  end
  column :images, sortable: false do |product|
    # ul do
      product.images.each do |img|
        span do
          image_tag(img.url(:small), size: '60x60')
        end
      end
    # end
  end
  actions defaults: false do |product|
    item "编辑", edit_admin_product_path(product)
    if product.on_sale
      item "下架", unsale_admin_product_path(product), method: :put
    else
      item "上架", sale_admin_product_path(product), method: :put
    end
  end
  
end

# 批量上架
batch_action :sale do |ids|
  batch_action_collection.find(ids).each do |product|
    product.sale!
  end
  redirect_to collection_path, alert: "上架成功"
end

# 批量下架
batch_action :unsale do |ids|
  batch_action_collection.find(ids).each do |product|
    product.unsale!
  end
  redirect_to collection_path, alert: "下架成功"
end

member_action :sale, method: :put do
  resource.sale!
  redirect_to collection_path, notice: "已上架"
end

member_action :unsale, method: :put do
  resource.unsale!
  redirect_to collection_path, notice: "已下架"
end

show do
  attributes_table do
    row :title
    row :category
    row :price
    row :m_price
    row :intro
    row :stock
    row :images do |product|
      # ul do
        product.images.each do |img|
          span do
            image_tag(img.url(:small))
          end
        end
      # end
    end
    
    row :detail_images do |product|
      # ul do
        product.detail_images.each do |img|
          div do
            image_tag(img.url)
          end
        end
      # end
    end
    
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :category
    f.input :title
    f.input :price
    f.input :m_price
    f.input :stock
    f.input :images, as: :file, input_html: { multiple: true }
    f.input :detail_images, as: :file, input_html: { multiple: true }
    f.input :intro
  end
  
  actions
end


end
