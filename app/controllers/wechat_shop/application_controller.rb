class WechatShop::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include SessionsHelper
  
  protect_from_forgery with: :exception
  
  layout "wechat"
  
  helper_method :render_page_title
  def render_page_title
    site_name = "农家风味"
    @page_title || site_name
    # content_tag(:title, title, nil, false)
  end
  
  def require_user
    if current_user.blank?
      # 登录
      store_location
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
