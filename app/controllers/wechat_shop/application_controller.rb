class WechatShop::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout "wechat"
  
  protect_from_forgery with: :exception
  
  def require_user
    if current_user.blank?
      # 登录
      redirect_to wechat_shop_login_path
    end
  end
  
  def check_user
    unless current_user.verified
      flash[:error] = "您的账号已经被禁用"
      redirect_to wechat_shop_root_path
    end
  end
  
end
