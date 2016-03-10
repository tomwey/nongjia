Rails.application.routes.draw do
  
  ######################### 微信公众平台开发 ###########################
  scope path: '/wechat', via: :post, defaults: { format: 'xml' } do
    root 'weixin/home#welcome', constraints: Weixin::Router.new(type: 'text', content: 'Hello2BizUser')
  end
  
  get "/wechat" => 'weixin/home#show'
  get "/fetch_access_token" => 'weixin/home#fetch_access_token'
  
  ############################### end ################################
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  mount GrapeSwaggerRails::Engine => '/apidoc'
  mount API::Dispatch => '/api'
end
