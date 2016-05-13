ActiveAdmin.register OrderProduct do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :order_id, :unit, :price, :quantity, :shipment_quantity, { product_images: [] }
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
  column '所属订单', sortable: false do |op|
    "#{op.order.product.title} - #{op.order.order_no}"
  end
  column :sku, sortable: false
  column :product_images, sortable: false do |op|
    # ul do
      op.product_images.each do |img|
        span do
          image_tag(img.url(:small), size: '60x60')
        end
      end
    # end
  end
  column '单价', sortable: false do |op|
    "#{op.price}#{op.unit}"
  end
  column '采购时计量', sortable: false do |op|
    "#{op.quantity}#{op.unit.split('/').last}"
  end
  column '打包后计量', sortable: false do |op|
    "#{op.shipment_quantity}#{op.unit.split('/').last}"
  end

  actions
  
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :order_id, as: :select, collection: OrderProduct.preferred_orders, prompt: '-- 选择所属订单 --'
    f.input :product_images, as: :file, input_html: { multiple: true }, hint: '支持多图上传'
    f.input :unit, as: :select, collection: OrderProduct.product_units, prompt: '-- 选择计量单位 --'
    f.input :price, placeholder: '填入的值根据计量单位决定', hint: '如果计量单位为斤，那么该值表示的意义为“值/斤”，其他同理'
    f.input :quantity, placeholder: '填入的值根据计量单位决定', hint: '如果计量单位是斤，那么此处可能的值为2.5，表示2.5斤，如果单位是个，那么此处可能是20'
    f.input :shipment_quantity, placeholder: '填入的值根据计量单位决定', hint: '填入的值参考上面：采购时计量；一般来说，如果计量单位是个，那么建议该值与采购时计量一样。'
  end
  
  actions
end


end
