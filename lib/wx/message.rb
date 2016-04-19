require 'rest-client'
module WX
  class Message
        
    def self.send(to, tpl, url = '', data = {})
      return if to.blank? or tpl.blank? or data.blank?
      
      # 发送模板消息
      post_url  = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=#{WX::Base.fetch_access_token}"
      post_body = {
         touser: to,
         template_id: tpl,
         url: url,         
         data: WX::Message.parse_data(data[:first], data[:values], data[:remark])
      }.to_json
      
      # puts post_body
      RestClient.post post_url, post_body, :content_type => :json, :accept => :json
      # puts res
    end
    
    def self.parse_data(first, values = [], remark = '')
      data = {}
      data[:first] = {
        value: first,
        color: '#173177'
      }
      
      values.each do |item|
        item.each do |key, value|
          data[key.to_sym] = {
            value: value,
            color: '#173177'
          }
        end
      end
      
      data[:remark] = {
        value: remark,
        color: '#173177'
      }
      
      data
    end
    
  end
end