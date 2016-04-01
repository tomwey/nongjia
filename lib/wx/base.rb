require 'rest-client'
module WX
  class Base
    def self.fetch_access_token
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
    
    def self.fetch_jsapi_ticket
      @jsapi_ticket = Rails.cache.read("wechat.jsapi_ticket")
      if @jsapi_ticket.blank?
        resp = RestClient.get 'https://api.weixin.qq.com/cgi-bin/ticket/getticket', 
                       { :params => { :access_token => WX::Base.fetch_access_token,
                                      :type         => 'jsapi'
                                    } 
                       }
                     
        result = JSON.parse(resp)
        @jsapi_ticket = result['ticket']
        Rails.cache.write("wechat.jsapi_ticket", @jsapi_ticket, expires_in: 110.minutes)
      end
      @jsapi_ticket
    end
    
    # 检测请求是否来自微信服务器
    def self.check_weixin_legality(timestamp, nonce, signature)
      if timestamp.blank? or nonce.blank? or signature.blank?
        return false
      end
      
      array = [Setting.weixin_token, timestamp, nonce].sort
      signature == Digest::SHA1.hexdigest(array.join) 
    end
    
  end
end