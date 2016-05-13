module ShipmentsHelper
  def shipment_address_tag(shipment)
    return '' if shipment.blank?
    region = shipment.region || "成都"
    "#{region} #{shipment.address}"
  end
end