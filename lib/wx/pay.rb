require 'rest-client'
module WX
  class Pay
    def self.unified_order(order, ip)
      return false if order.blank?
      
      params = {
        appid: Setting.wx_app_id,
        mch_id: Setting.wx_mch_id,
        device_info: 'WEB',
        nonce_str: SecureRandom.hex(16),
        body: order.product.title,
        out_trade_no: '16041649626406780',
        total_fee: '1', #(order.total_fee - order.discount_fee) * 100,
        spbill_create_ip: ip,
        notify_url: Setting.wx_pay_notify_url,
        trade_type: 'JSAPI',
        openid: order.user.wechat_auth.open_id,
        attach: '支付订单'
      }
      
      sign = sign_params(params)
      params[:sign] = sign
      
      xml = params.to_xml(root: 'xml', skip_instruct: true, dasherize: false)
      # puts xml
      result = RestClient.post 'https://api.mch.weixin.qq.com/pay/unifiedorder', xml, { :content_type => :xml }
      puts result
      pay_result = Hash.from_xml(result)[:xml]
      return pay_result
    end
    
    def self.sign_params(params)
      arr = params.sort
      hash = Hash[*arr.flatten]
      string = hash.delete_if { |k,v| v.blank? }.map { |k,v| "#{k}=#{v}" }.join('&')
      string = string + '&key=' + Setting.wx_pay_api_key
      Digest::MD5.hexdigest(string).upcase
    end
    
    def self.generate_jsapi_params(prepay_id)
      params = {
        appId: Setting.wx_app_id,
        timeStamp: Time.now.to_i,
        nonceStr: SecureRandom.hex(16),
        package: "prepay_id=#{prepay_id}",
        signType: "MD5",
      }
      
      sign = sign_params(params)
      params[:paySign] = sign
      
      # puts params
      
      params
    end
    
  end
end