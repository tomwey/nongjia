ActiveAdmin.register Trade do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :partner_id, :money
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
  column :money, sortable: false
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
    f.input :money, placeholder: '支付金额'
    f.input :partner_id, as: :select, collection: Partner.all.map { |p| [p.name + '<' + p.pay_account + ' ' + p.pay_card_no + '>', p.id] }, prompt: '-- 选择收款人 --'
  end
  
  actions
end


end
