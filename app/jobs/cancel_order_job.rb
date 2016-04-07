class CancelOrderJob < ActiveJob::Base
  queue_as :scheduled_jobs
  
  def perform(order_id)
    @order = Order.find_by(id: order_id)
    if @order and @order.can_cancel?
      @order.cancel
      Message.create!(content: '系统取消了您的订单', user_id: @order.user.id, to_user_type: Message::TO_USER_TYPE_WX)
    end
  end
end