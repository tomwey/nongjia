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
       
      RestClient.post post_url, post_body, :content_type => :json, :accept => :json
       
    end
    
    def self.parse_data(first, values = [], remark = '')
      data = {}
      data[:first] = {
        value: first,
        color: '#173177'
      }
      
      values.each_with_index do |value, idx|
        key = 'keynote' + (idx + 1).to_s
        data[key.to_sym] = {
          value: value,
          color: '#173177'
        }
      end
      
      data[:remark] = {
        value: remark,
        color: '#173177'
      }
      
      data
    end
    
    def self.send2(msg, to)
      
      return if msg.blank? or to.blank?
      
      # 发送模板消息
      post_url  = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=#{WX::Base.fetch_access_token}"
      
      post_body = {
           touser: to,
           template_id: '',
           url: '',         
           data: {
               first: {
                   value: "您好，消费券已领取",
                   color: "#173177"
               },
               keynote1: {
                   value: "8元",
                   color: "#173177"
               },
               keynote2: {
                   value: "2016-6-8",
                   color: "#173177"
               },
               remark: {
                   value: "感谢使用，预祝消费愉快",
                   color: "#173177"
               }
           }
       }.to_json
       
       RestClient.post post_url, post_body, :content_type => :json, :accept => :json
    end
  end
end