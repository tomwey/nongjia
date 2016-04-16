require 'rest-client'
class Weixin::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout "weixin"
  protect_from_forgery with: :null_session
  # 验证请求是否来自于微信服务器
  before_filter :check_weixin_legality
  
  # 验证当前微信用户是否可用
  before_filter :check_weixin_user
  
  # 获取微信的access token
  helper_method :fetch_wechat_access_token
  def fetch_wechat_access_token
    WX::Base.fetch_access_token
  end
  
  # 创建微信菜单
  helper_method :create_wechat_menu
  def create_wechat_menu
    post_body = {
      button: [
        { type: 'view',
          name: '商城',
          url: 'https://nj.afterwind.cn/wx-shop'
        },
        {
          name: '福利',
          sub_button: [
            { type: 'view',
              name: '拔鸡毛',
              url: 'https://nj.afterwind.cn/wx-shop'
            }
          ]
        },
        {
          name: '我',
          sub_button: [
            {
              type: 'view',
              name: '我的订单',
              url: 'https://nj.afterwind.cn/wx-shop/orders'
            },
            {
              type: 'view',
              name: '个人中心',
              url: 'https://nj.afterwind.cn/wx-shop/user/settings'
            },
            {
              type: 'view',
              name: '优惠券',
              url: 'https://nj.afterwind.cn/wx-shop/coupons'
            },
            {
              type: 'view',
              name: '帮助',
              url: 'https://nj.afterwind.cn/wx-shop/p/help'
            }
          ]
        }
      ]
    }.to_json
    resp = RestClient.post "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{fetch_wechat_access_token}", post_body, :content_type => :json, :accept => :json
    puts resp
  end
  
  private 
    def check_weixin_legality
      render(text: "Forbidden", status: 403) unless WX::Base.check_weixin_legality(params[:timestamp], params[:nonce], params[:signature])
    end
    
    def check_weixin_user
      # @weixin_user = WechatUser.from_wechat(weixin_xml)
      wechat_auth = WechatAuth.find_by(open_id: weixin_xml.from_user)
      
      render("weixin/403", formats: :xml) if wechat_auth.blank? or wechat_auth.user.blank? or !wechat_auth.user.verified
    end
    
end
