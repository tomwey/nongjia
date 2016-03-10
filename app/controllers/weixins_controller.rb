class WeixinsController < ApplicationController
  # skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session
  
  before_action :check_weixin_legality
  
  def show
    render text: params[:echostr]
  end

  def create
    if params[:xml][:MsgType] == 'text'
      render "echo", formats: :xml
    end
  end
  
  private
  def check_weixin_legality
    array = [Setting.weixin_token, params[:timestamp], params[:nonce]].sort
    render(text: "Forbidden", status: 403) if params[:signature] != Digest::SHA1.hexdigest(array.join) 
  end
  
end

# <xml>
#  <ToUserName><![CDATA[toUser]]></ToUserName>
#  <FromUserName><![CDATA[fromUser]]></FromUserName>
#  <CreateTime>1348831860</CreateTime>
#  <MsgType><![CDATA[text]]></MsgType>
#  <Content><![CDATA[this is a test]]></Content>
#  <MsgId>1234567890123456</MsgId>
# </xml>
