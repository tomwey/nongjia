class Weixin::HomeController < Weixin::ApplicationController
  skip_before_filter :check_weixin_user, only: [:show, :fetch_access_token]
  skip_before_filter :verify_authenticity_token, :only => [:welcome]
  def welcome
    
  end
  
  def show
    render text: params[:echostr]
  end
  
  def fetch_access_token
    # create_wechat_menu
    render text: fetch_wechat_access_token
  end
  
end
