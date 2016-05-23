class WechatShop::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include SessionsHelper
  
  protect_from_forgery with: :exception
  
  before_filter :check_from_wechat
  
  before_action :set_wx_share
  def set_wx_share
    if controller_name == 'users' and action_name == 'invite'
      @wx_share = nil
    # elsif controller_name == 'products' and action_name == 'show'
      # @wx_share = nil
    else
      @wx_share = WXShare.new("#{Setting.upload_url}" + ActionController::Base.helpers.asset_path('wechat_shop/nj-logo.jpg'), SiteConfig.wx_share_link, SiteConfig.wx_share_title, SiteConfig.wx_share_body)
    end
  end
  
  layout "wechat"
  
  helper_method :render_page_title
  def render_page_title
    site_name = "农家风味"
    @page_title || site_name
    # content_tag(:title, title, nil, false)
  end
  
  def check_from_wechat
    # puts request.user_agent
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
  
  def fresh_when(opts = {})
    opts[:etag] ||= []
    # 保证 etag 参数是 Array 类型
    opts[:etag] = [opts[:etag]] unless opts[:etag].is_a?(Array)
    opts[:etag] << current_user
    # 加入flash，确保当页面刷新后flash不会再出现
    opts[:etag] << flash
    # 所有etag保持一天
    opts[:etag] << Date.current
    
    super(opts)
    
  end
  
end
