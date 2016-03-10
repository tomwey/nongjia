require 'rest-client'
class Weixin::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout "weixin"
  protect_from_forgery with: :null_session
  # 验证请求是否来自于微信服务器
  # before_filter :check_weixin_legality
  
  # 验证当前微信用户是否可用
  before_filter :check_weixin_user
  
  # 获取微信的access token
  helper_method :fetch_wechat_access_token
  def fetch_wechat_access_token
    @access_token = Rails.cache.read("wechat.access_token")
    if @access_token.blank?
      resp = RestClient.get 'https://api.weixin.qq.com/cgi-bin/token', 
                     { :params => { :grant_type => "client_credential",
                                    :appid      => Setting.wx_app_id,
                                    :secret     => Setting.wx_app_secret 
                                  } 
                     }
                     
      result = JSON.parse(resp)
      @access_token = result['access_token']
      Rails.cache.write("wechat.access_token", @access_token, expires_in: 110.minutes)
    end
    @access_token
  end
  
  # 创建微信菜单
  helper_method :create_wechat_menu
  def create_wechat_menu
    post_body = {
      button: [
        { type: 'view',
          name: 'APP下载',
          url: 'http://www.baidu.com'
        },
        {
          name: '搜索',
          sub_button: [
            { type: 'view',
              name: '查询城市',
              url: 'http://shuiguoshe.com'
            },
            {
              type: 'click',
              name: '附近',
              key: 'hotel'
            }
          ]
        },
        {
          type: 'click',
          name: '更多',
          key: 'more'
        }
      ]
    }.to_json
    resp = RestClient.post "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{fetch_wechat_access_token}", post_body, :content_type => :json, :accept => :json
    puts resp
  end
  
  private 
    def check_weixin_legality
      if params[:timestamp].nil? or params[:nonce].nil? or params[:signature].nil?
        render text: "Forbidden", status: 403
        return
      end
      
      array = [Setting.weixin_token, params[:timestamp], params[:nonce]].sort
      render(text: "Forbidden", status: 403) if params[:signature] != Digest::SHA1.hexdigest(array.join) 
    end
    
    def check_weixin_user
      @weixin_user = WechatUser.from_wechat(weixin_xml)
      render("weixin/403", formats: :xml) unless @weixin_user.is_valid?
    end
    
end
