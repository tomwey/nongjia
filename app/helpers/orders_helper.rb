module OrdersHelper
  def render_shipment_info
    if current_user.current_shipment_id.blank?
      content_tag :div, '请选择地址'
    else
      shipment = Shipment.find_by(id: current_user.current_shipment_id)
      if shipment.blank?
        content_tag :div, '请选择地址'
      else
        content_tag :div do 
          content_tag(:p, shipment.name) + content_tag(:p, shipment.address)
        end
      end
      
    end
  end
end