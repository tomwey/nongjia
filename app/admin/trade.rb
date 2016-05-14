ActiveAdmin.register Trade do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :partner_id, :money, { orders: [] }, :note
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

# actions except: [:destroy]

actions :all, except: [:destroy]

before_create do |trade|
  trade.operator = current_admin_user.id
end

index do
  selectable_column
  column :id
  column '结算订单', sortable: false do |trade|
    ul do
      trade.pay_orders.each do |order|
        li do
          raw("订单号：#{order.order_no}<br>产品标题：#{order.product.title}<br>收货人：#{order.shipment_info.try(:name) || order.shipment_info.try(:mobile)}<br><br>")
        end
      end
    end
  end
  column '支付金额', sortable: false do |trade|
    "¥ #{trade.money}"
  end
  column '收款人', sortable: false do |trade|
    "#{trade.partner.name}<#{trade.partner.pay_account} #{trade.partner.pay_card_no}>"
  end
  column '操作人', sortable: false do |trade|
    trade.admin_user.email
  end
  
  column :created_at
  column :updated_at

  actions
end

form do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :money
    f.input :partner_id, as: :select, collection: Partner.all.map { |p| [p.name + '<' + p.pay_account + ' ' + p.pay_card_no + '>', p.id] }, prompt: '-- 选择收款人 --'
    f.input :orders, as: :check_boxes, label: "结算的订单", collection: Trade.preferred_orders
    f.input :note
  end
  
  actions
end


end
