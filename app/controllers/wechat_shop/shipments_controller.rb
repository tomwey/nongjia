class WechatShop::ShipmentsController < WechatShop::ApplicationController
  
  before_filter :require_user
  before_filter :check_user
  
  skip_before_filter  :verify_authenticity_token, only: [:destroy]
  
  def index
    @shipments = current_user.shipments.order('id DESC')
    if params[:from]
      session[:from_for_shipments] = params[:from]
    end
    @from = params[:from] || session[:from_for_shipments]
    fresh_when(etag: [@shipments, @from])
  end
  
  def new
    @shipment = current_user.shipments.build
  end
  
  def create
    @shipment = current_user.shipments.new(shipment_params)
    if @shipment.save
      flash[:notice] = '新增地址成功'
      redirect_to wechat_shop_shipments_path
    else
      render :new
    end
  end
  
  def destroy
    if current_user.current_shipment_id.present? and 
      params[:id].present? and params[:id].to_i == current_user.current_shipment_id.to_i
      flash[:error] = '您不能删除默认收货地址'
    else
      @shipment = current_user.shipments.find(params[:id])
      @shipment.destroy
    end
    redirect_to wechat_shop_shipments_path
  end
  
  private
  def shipment_params
    params.require(:shipment).permit(:name, :mobile, :region, :address)
  end
  
end
