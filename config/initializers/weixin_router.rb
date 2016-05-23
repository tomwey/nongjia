module Weixin
  # 微信内部路由规则类，用于简化配置
  class Router
    # 支持一下形式
    # Weixin::Router.new(type: "text")
    # Weixin::Router.new(type: "text", content: "Hello2BusUser")
    # Weixin::Router.new(type: "text", content: /^@/)
    # Weixin::Router.new { |xml| xml[:MsgType] == 'image' }
    # Weixin::Router.new (type: "text") { |xml| xml[:Content].starts_with? "@" }
    def initialize(options, &block)
      @type = options[:type] if options[:type]
      @content = options[:content] if options[:content]
      @constraint = block if block_given?
    end
    
    def matches?(request)
      xml = request.params[:xml]
      if xml.blank?
        return false
      end
      result = true
      result = result && (xml[:MsgType] == @type) if @type
      result = result && (xml[:Content] =~ @content) if @content.is_a? Regexp
      result = result && (xml[:Content] == @content) if @content.is_a? String
      result = result && @constraint.call(xml) if @constraint
      
      result
    end
    
  end
  
  module ActionController
    # 辅助方法，用于简化操作, 将xml数据封装成对象
    def weixin_xml
      # puts '----------------------------'
      # puts params[:xml]
      hash = params[:xml]
      
      if hash[:Event] == 'subscribe' or hash[:Event] == 'SCAN'
        # 表示是关注或者扫描二维码
        code = hash[:EventKey].split('_').last
        unless code.blank?
          # puts code
          user = User.find_by(nb_code: code)
          if user && user.wechat_auth.open_id != hash[:FromUserName]
            wx_auth = WechatAuth.find_by(open_id: hash[:FromUserName])
            if wx_auth.blank?
              # 注册当前新用户
              new_user = User.new
              auth = WechatAuth.new(open_id: hash[:FromUserName],
                                    access_token: SecureRandom.uuid) # 此处系统生成一个不正确的access token，以防插入空值
              new_user.wechat_auth = auth
              new_user.recommender = user.id # 自动绑定推荐关系
              if new_user.save
                invite = Invite.current_invite_for(user)
                
                Invite.transaction do
                  # 送被邀请人一张现金券
                  Discounting.create!(user_id: new_user.id, coupon_id: invite.invitee_benefits)
                
                  # 送邀请人一张现金券
                  Discounting.create!(user_id: user.id, coupon_id: invite.inviter_benefits)
                end
              
              end # end save new user
            
            end # end create auth if
          end # end share if
        end # end code blank check
      end # end if event 
      
      @weixin_xml ||= WeixinXml.new(params[:xml])
      @weixin_xml
    end
    
    class WeixinXml
      attr_accessor :content, :type, :from_user, :to_user, :pic_url, :event
      def initialize(hash)
        @content   = hash[:Content]
        @type      = hash[:MsgType]
        @from_user = hash[:FromUserName]
        @to_user   = hash[:ToUserName]
        @pic_url   = hash[:PicUrl]
        @event     = hash[:Event]
      end
    end
  end
end

ActionController::Base.class_eval do
  include ::Weixin::ActionController
end
ActionView::Base.class_eval do
  include ::Weixin::ActionController
end