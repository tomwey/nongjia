require 'rest-client'
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
  
  def events
    @page_title = "推荐顾客得优惠"
    
    @event = DiscountEvent.where('owners @> ? and expired_on > ?', "{#{current_user.id}}", Time.now - 1.days).order('score desc').first
  end
  
  def settings
    
    session[:from_for_shipments] = nil
    session[:from_for_coupons] = nil
    
    @user = current_user
    if @user.nickname.blank? or @user.avatar.blank?
      # 获取用户个人信息，注意由于access_token有效期为2小时，
      # 所以下面的操作有可能会失效
      auth = @user.wechat_auth
      if auth.present?
        resp = RestClient.get "https://api.weixin.qq.com/sns/userinfo", 
                       { :params => { 
                                      :access_token => auth.access_token,
                                      :openid       => auth.open_id,
                                      :lang         => 'zh_CN'
                                    } 
                       }
                   
        result = JSON.parse(resp)
        if result['openid'].present?
          # 正确取到用户数据
          @user.nickname = result['nickname']
          @user.remote_avatar_url = result['headimgurl'] 
          @user.save!
        end
      end
      
    end
    
    @current = 'user_settings'
  end
  
  private
    def fetch_user_info(user)
      
    end
  
end
