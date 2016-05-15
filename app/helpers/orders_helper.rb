module OrdersHelper
  def render_order_state(order)
    return "" if order.blank?
    return "" if order.state.blank?
    
    case order.state.to_sym
    when :pending  then  "待付款"
    when :paid     then  "待配送"
    when :shipping then  "配送中"
    when :canceled then  "已取消"
    when :completed then "已完成"
    else ''
    end
  end
  def render_shipment_info
    if current_user.current_shipment_id.present? and (shipment = Shipment.find_by(id: current_user.current_shipment_id, user_id: current_user.id))
      # content_tag :div, '请选择地址'
      content_tag :table, class: 'order-shipment-table' do
        content_tag :tr do
          "<td width='80%'>
            <h2>#{shipment.name} #{shipment.hack_mobile}</h2>
            <p>#{shipment.region || '成都'} #{shipment.address}</p>
          </td>
          <td align='right'>
            <i class='fa fa-angle-right' style='font-size: 24px'></i>
          </td>
          ".html_safe
        end
      end
    else
      content_tag :table, class: 'order-shipment-table' do
        content_tag :tr do
          "<td width='80%'>
            请选择地址
          </td>
          <td align='right'>
            <i class='fa fa-angle-right' style='font-size: 24px'></i>
          </td>
          ".html_safe
        end
      end
    end
  end
end