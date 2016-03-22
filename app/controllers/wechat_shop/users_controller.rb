class WechatShop::UsersController < WechatShop::ApplicationController
  before_filter :require_user
  before_filter :check_user
  
  skip_before_action :verify_authenticity_token, only: [:update_current_shipment]
  
  def update_current_shipment
    shipment_id = params[:shipment_id]
    if shipment_id.present?
      current_user.current_shipment_id = shipment_id
      if current_user.save
        render text: 0
      else
        render text: -1
      end
    else
      render text: -2
    end
  end
  
  def settings
    @user = current_user
    @current = 'user_settings'
  end
  
end
