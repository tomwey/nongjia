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
  
  def orders
    @orders = current_user.orders.order('id DESC')
    @current = 'orders_index'
    @page_title = '我的订单'
    
    fresh_when(etag: [@orders, @current, CacheVersion.product_latest_updated_at])
  end
  
  def no_pay_orders
    @orders = current_user.orders.no_pay.order('id DESC')
    @current = 'orders_no_pay'
    render :orders
  end
  
  def shipping_orders
    @orders = current_user.orders.shipping.order('id DESC')
    @current = 'orders_shipping'
    render :orders
  end
  
  def events
    @page_title = "推荐顾客得优惠"
    
    @event = DiscountEvent.where('owners @> ? and expired_on > ?', "{#{current_user.id}}", Time.now - 1.days).order('score desc').first
  end
  
  def rewards
    @page_title = "获得的奖励"
    
    @rewards = Reward.where(recommending_id: self.id).paginate page: params[:page], per_page: 30
    
    @total_money ||= Reward.where(recommending_id: self.id).pluck('money').sum
    @today_money ||= Reward.where(recommending_id: self.id).where(where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).pluck('money')
  
    fresh_when(etag: [@rewards])
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
    fresh_when(etag: [@current])
  end
  
  def invite
    @invite = Invite.current_invite_for(current_user)
    @wx_share = WXShare.new(@invite.share_icon_url, @invite.link, @invite.title, @invite.share_body)
  end
  
  private
    def fetch_user_info(user)
      
    end
  
end
