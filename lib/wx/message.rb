require 'rest-client'
module WX
  class Message
    def self.send(msg, to)
      
      return if msg.blank? or to.blank?
      
      # 发送模板消息
      post_url  = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=#{WX::Base.fetch_access_token}"
      post_body = {
           touser: to,
           template_id: "ngqIpbwh8bUfcSsECmogfXcV14J0tQlEpBO27izEYtY",
           url: "http://weixin.qq.com/download",         
           data: {
               first: {
                   value: "恭喜你购买成功！",
                   color: "#173177"
               },
               keynote1: {
                   value: "巧克力",
                   color: "#173177"
               },
               keynote2: {
                   value: "39.8元",
                   color: "#173177"
               },
               keynote3: {
                   value: "2014年9月22日",
                   color: "#173177"
               },
               remark: {
                   value: "欢迎再次购买！",
                   color: "#173177"
               }
           }
       }.to_json
       
       RestClient.post post_url, post_body, :content_type => :json, :accept => :json
      # post_body = {
      #   touser: to,
      #   msgtype: "text",
      #   text: {
      #     content: msg
      #   }
      # }.to_json
      # RestClient.post "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=#{WX::Base.fetch_access_token}", post_body, :content_type => :json
    end
  end
end