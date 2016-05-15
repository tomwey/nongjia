ActiveAdmin.register Order do

menu priority: 5, label: "订单"

permit_params :note, :quantity, :total_fee, :discount_fee

filter :order_no
filter :product, label: '所属产品', collection: proc { Product.all.map { |p| [p.title, p.id] } }
filter :user, label: '下单人', collection: proc { User.all.map { |u| [u.nickname, u.id] } }
filter :total_fee
filter :state
filter :created_at

actions :all, except: [:new, :create, :destroy]

index do
  selectable_column
  column('#', id) { |order| link_to order.id, admin_order_path(order) }
  column :order_no
  column '所购产品' do |order|
    image_tag order.product.images.first.url(:small), size: '60x60'
  end
  column '产品信息', sortable: false do |order|
    raw("#{order.product.title} <br> × #{order.quantity}")
  end
  column '总价' do |order|
    "¥ #{order.total_fee}"
  end
  column '优惠' do |order|
    "-¥ #{order.discount_fee}"
  end
  column '收货人', sortable: false do |order|
    if order.shipment_info.blank?
      ''
    else
      "#{order.shipment_info.try(:name)}\n#{order.shipment_info.try(:mobile)}"
    end
  end
  column '收货地址', sortable: false do |order|
    if order.shipment_info.blank?
      ''
    else
      "#{order.shipment_info.try(:address)}"
    end
  end
  column '下单人', sortable: false do |order|
    if order.user.blank?
      ''
    else
      "#{order.user.nickname}"
    end
  end
  column '下单时间' do |order|
    order.created_at.strftime('%Y年%-m月%-d日 %H:%M:%S')
  end
  column :state, sortable: false do |order|
    case order.state.to_sym
    when :pending then '待付款'
    when :paid then '待配送'
    when :shipping then '配送中'
    when :canceled then '已取消'
    when :completed then '已完成'
    else ''
    end
  end
  actions defaults: false do |order|
    item '编辑 ', edit_admin_order_path(order)
    if order.can_cancel?
      item '取消订单 ', cancel_admin_order_path(order), method: :put
    end
    if order.can_ship?
      item '配送订单 ', ship_admin_order_path(order), method: :put
    end
    if order.can_complete?
      item '完成订单 ', complete_admin_order_path(order), method: :put
    end
  end
end

# 批量取消订单
batch_action :cancel do |ids|
  batch_action_collection.find(ids).each do |order|
    order.cancel
    order.send_order_state_msg('系统人工取消了您的订单', '已取消')
  end
  redirect_to collection_path, alert: "已经取消"
end

# 批量更改配送状态
batch_action :ship do |ids|
  batch_action_collection.find(ids).each do |order|
    user.ship
  end
  redirect_to collection_path, alert: "已经更改为配送中"
end

# 批量完成订单
batch_action :complete do |ids|
  batch_action_collection.find(ids).each do |order|
    user.complete
  end
  redirect_to collection_path, alert: "已经完成订单"
end

member_action :cancel, method: :put do
  resource.cancel
  resource.send_order_state_msg('系统人工取消了您的订单', '已取消')
  redirect_to admin_orders_path, notice: "已取消"
end

member_action :ship, method: :put do
  resource.ship
  redirect_to admin_orders_path, notice: "配送中"
end

member_action :complete, method: :put do
  resource.complete
  redirect_to admin_orders_path, notice: "已完成"
end

form do |f|
  f.semantic_errors
  
  f.inputs '修改订单' do
    f.input :note
    f.input :quantity
    f.input :total_fee
    f.input :discount_fee
  end
  actions
end

end
