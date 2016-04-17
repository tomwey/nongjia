module WX
  class Sign
    def self.sign(url, noncestr, timestamp)
      jsapi_ticket = WX::Base.fetch_jsapi_ticket
      # puts jsapi_ticket
      string = "jsapi_ticket=#{jsapi_ticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"
      Digest::SHA1.hexdigest(string)
    end
    
    def self.sign_package(url, debug = true)
      timestamp = Time.now.to_i
      random_str = SecureRandom.hex(4)
      signature  = WX::Sign.sign(url, random_str, timestamp)
      {
          debug: SiteConfig.wx_config_debug == 'true',
          appId: Setting.wx_app_id,
          timestamp: timestamp,
          nonceStr: random_str,
          signature: signature,
          jsApiList: ['chooseWXPay','onMenuShareTimeline', 'onMenuShareAppMessage', 'onMenuShareQQ', 'onMenuShareQZone','openLocation','getLocation']
      }
    end
    
  end
end