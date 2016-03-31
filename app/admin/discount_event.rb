ActiveAdmin.register DiscountEvent do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :body, :expired_on, :score, :code, { coupon_ids: [] }

filter :code
filter :title
filter :body
filter :expired_on
filter :score
filter :created_at

index do
  selectable_column
  column('#', id) { |e| link_to e.id, admin_discount_event_path(e) }
  column :code, sortable: false
  column :title, sortable: false
  column :expired_on
  column :score
  column '所属优惠券', sortable: false do |e|
    raw(Coupon.where(id: e.coupon_ids).map(&:title).join('<br>'))
  end
  column :created_at
  actions
end

form do |f|
  f.semantic_errors
  f.inputs do
    f.input :code, label: '优惠码', placeholder: '活动优惠码，可以是中文，也可以是字母或数字，如果不输入，系统随机生成5位优惠码'
    f.input :title
    f.input :body
    f.input :expired_on
    f.input :score
    f.input :coupon_ids, as: :check_boxes, label: "所属优惠券", collection: Coupon.all.map { |c| [c.title, c.id] }
  end
  f.actions
end


end
