ActiveAdmin.register OrderProduct do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :order_id, :unit, :price, :quantity, :shipment_quantity, { product_images: [] }, :pack_cost, :shipment_cost
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
actions :all, except: [:show, :destroy]

index do
  # selectable_column
  column :sku, sortable: false
  column '所属订单', sortable: false do |op|
    raw("订单号：#{op.order.order_no}<br><br>产品标题：#{op.order.product.title}<br><br>收货人：#{op.order.shipment_info.try(:name) || op.order.shipment_info.try(:mobile)}")
  end
  
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
  column '计量统计', sortable: false do |op|
    if op.unit.blank?
      '未知'
    else
      raw("采购：#{op.quantity}#{op.unit.split('/').last}<br>打包：#{op.shipment_quantity}#{op.unit.split('/').last}")
    end
  end
  column '成本统计', sortable: false, width: "10%" do |op|
    raw("包装：-#{op.pack_cost}<br>物流：-#{op.shipment_cost}<br>采购：-#{op.purchase_cost}")
  end
  column '赔偿买家', sortable: false do |op|
    "-#{op.pay_buyer_loss}"
  end
  column '收益统计' do |op|
    raw("净营收：#{op.sale_benefits}<br>总成本：-#{op.total_cost}<br>净利润：#{op.total_benefits}")
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
    f.input :pack_cost, hint: '输入数值，可以输入整数或者小数'
    f.input :shipment_cost, hint: '输入数值，可以输入整数或者小数'
    f.input :pay_buyer_loss, hint: '输入数值，可以输入整数或者小数'
  end
  
  actions
end


end
