require 'rest-client'
class WechatShop::SessionsController < WechatShop::ApplicationController
  def new
    if session['wechat.code'].blank?
      # 首先去获取code
      url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Setting.wx_app_id}&redirect_uri=#{Rack::Utils.escape(Setting.wx_redirect_uri)}&response_type=code&scope=snsapi_userinfo&state=nj_shop#wechat_redirect"
      # puts url
      redirect_to(url)
    else
      # 有code直接进行登录授权操作
      # redirect("/wechat_shop/redirect?code=#{session['wechat.code']}&state=nj_shop")
      redirect_to wechat_shop_redirect_uri_path(code: session['wechat.code'], state: 'nj_shop')
    end
  end
  
  def save_user
    if params[:code].blank?
      flash[:notice] = '取消登录认证'
      redirect_to(request.referrer || wechat_shop_root_path)
      return 
    end
    
    # 开始登录
    session['wechat.code'] = params[:code]
    
    resp = RestClient.get "https://api.weixin.qq.com/sns/oauth2/access_token", 
                   { :params => { 
                                  :appid      => Setting.wx_app_id,
                                  :secret     => Setting.wx_app_secret,
                                  :grant_type => "authorization_code",
                                  :code       => params[:code]
                                } 
                   }
                   
    result = JSON.parse(resp)
    
    openid = result['openid'];
    if openid.blank?
      flash[:error] = '无效的code，请重试'
      redirect_to(request.referrer || wechat_shop_root_path)
      return 
    end
    
    user = User.from_wechat_auth(result)
    if user
      log_in user
      remember(user)
      session['wechat.code'] = nil
      redirect_back_or(wechat_shop_root_path)
    else
      flash[:error] = '登录认证失败'
      redirect_to(request.referrer || wechat_shop_root_path) 
    end
    
  end
  
  def destroy
    log_out
    redirect_to(wechat_shop_root_path)
  end
  
end
