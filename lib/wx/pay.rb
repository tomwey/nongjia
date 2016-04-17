require 'rest-client'
module WX
  class Pay
    # 统一下单
    def self.unified_order(order, ip)
      return false if order.blank?
      
      total_fee = SiteConfig.wx_pay_debug == 'true' ? '1' : "#{(order.total_fee - order.discount_fee) * 100}"
      params = {
        appid: Setting.wx_app_id,
        mch_id: Setting.wx_mch_id,
        device_info: 'WEB',
        nonce_str: SecureRandom.hex(16),
        body: order.product.title,
        out_trade_no: order.order_no,
        total_fee: total_fee,
        spbill_create_ip: ip,
        notify_url: Setting.wx_pay_notify_url,
        trade_type: 'JSAPI',
        openid: order.user.wechat_auth.try(:open_id) || '',
        attach: '支付订单'
      }
      
      sign = sign_params(params)
      params[:sign] = sign
      
      xml = params.to_xml(root: 'xml', skip_instruct: true, dasherize: false)
      result = RestClient.post 'https://api.mch.weixin.qq.com/pay/unifiedorder', xml, { :content_type => :xml }
      # puts result
      pay_result = Hash.from_xml(result)['xml']
      # puts pay_result
      return pay_result
    end
    
    # 关闭订单
    def self.close_order(order)
      return false if order.blank?
      
      params = {
        appid: Setting.wx_app_id,
        mch_id: Setting.wx_mch_id,
        out_trade_no: order.order_no,
        nonce_str: SecureRandom.hex(16),
      }
      
      sign = sign_params(params)
      params[:sign] = sign
      
      xml = params.to_xml(root: 'xml', skip_instruct: true, dasherize: false)
      RestClient.post 'https://api.mch.weixin.qq.com/pay/closeorder', xml, { :content_type => :xml }
      
    end
    
    # 参数签名
    def self.sign_params(params)
      arr = params.sort
      hash = Hash[*arr.flatten]
      string = hash.delete_if { |k,v| v.blank? }.map { |k,v| "#{k}=#{v}" }.join('&')
      string = string + '&key=' + Setting.wx_pay_api_key
      Digest::MD5.hexdigest(string).upcase
    end
    
    # 通知校验
    def self.notify_verify?(params)
      
      return false if params['appid'] != Setting.wx_app_id
      return false if params['mch_id'] != Setting.wx_mch_id
      
      sign = params['sign']
      params.delete('sign')
      return sign_params(params) == sign      
      
    end
    
    # 生成H5微信支付参数
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
      params
    end
    
  end
end