ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      
      column do
        panel "最新订单" do
          table_for Order.order('id desc').limit(10) do
            column('产品Icon') { |order| image_tag order.product.images.first.url(:small), size: '60x60' }
            column('产品标题') { |order| order.product.title }
            column('购买数量') { |order| order.quantity }
            column('收货人') { |order| order.user.shipment_info.try(:mobile) }
            column('配送地址') { |order| order.user.shipment_info.try(:address) }
            column('订单号') { |order| order.order_no }
            column('下单时间') { |order| order.created_at }
            column('订单状态') { |order| order.state_info }
          end
        end
      end # end order
      
    end
    
    columns do
      
      column do
        panel "最新用户" do
          table_for User.order('id desc').limit(10) do
            column('头像') { |user| image_tag(user.avatar_url(:large), size: '60x60') }
            column('账户') { |user| user.nickname || user.wechat_auth.try(:open_id) }
          end
        end
      end # end user
      
      column do
        panel "热门产品" do
          table_for Product.order('orders_count desc, id desc').limit(10) do
            column('产品Icon') { |product| image_tag product.images.first.url(:small), size: '60x60' }
            column('产品标题') { |product| product.title }
            column('订单数') { |product| product.orders_count }
          end
        end # end product
      end
      
    end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
