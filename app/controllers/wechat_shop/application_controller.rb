class WechatShop::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout "wechat"
  
  protect_from_forgery with: :exception
    
end
