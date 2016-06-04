ActiveAdmin.register Ad do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :image, :title, :body, :link, :sort

index do
  selectable_column
  column('#', id) { |ad| link_to ad.id, admin_ad_path(ad) }
  column '广告图片', sortable: false do |ad|
    image_tag ad.image.url(:small)
  end
  column('链接地址', sortable: false) { |ad| link_to ad.link, ad.link }
  column :sort
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :image, as: :file
    f.input :link, placeholder: 'http://', hint: '链接地址，可以为空'
    f.input :sort
    f.input :title, hint: '保留字段，可以留空'
    f.input :body, hint: '保留字段，可以留空'
  end
  
  actions
end


end
