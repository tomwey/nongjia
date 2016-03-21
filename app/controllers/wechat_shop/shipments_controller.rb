class WechatShop::ShipmentsController < WechatShop::ApplicationController
  
  before_filter :require_user
  before_filter :check_user
  
  def index
    @shipments = current_user.shipments.order('id DESC')
  end
  
  def new
    @shipment = current_user.shipments.build
  end
  
  def create
    
  end
  
  def destroy
    
  end
  
end
