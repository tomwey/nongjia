class CancelOrderJob < ActiveJob::Base
  queue_as :scheduled_jobs
  
  def perform(order_id)
    @order = Order.find_by(id: order_id)
    if @order and @order.can_cancel?
      @order.cancel
      # Message.create!(content: '系统取消了您的订单', user_id: @order.user.id, to_user_type: Message::TO_USER_TYPE_WX)
      if @order.user.wechat_auth
        to = @order.user.wechat_auth.try(:open_id)
      else
        to = ''
      end
      WX::Message.send(to, SiteConfig.order_state_msg_tpl, '', { first: '系统取消了您的订单', remark: '30分钟内未支付，系统自动取消订单', values: %W(@order.order_no 已取消) })
    end
  end
end