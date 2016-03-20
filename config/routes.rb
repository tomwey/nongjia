Rails.application.routes.draw do
  
  ######################### 微信公众平台开发 ###########################
  post '/wechat' => 'weixin/home#welcome', defaults: { format: 'xml' }
  get "/wechat" => 'weixin/home#show'
  get "/fetch_access_token" => 'weixin/home#fetch_access_token'
  
  
  namespace :wechat_shop do
    root 'home#index'
    resources :products, only: [:show]
    resources :orders
  end
  
  ############################### end ################################
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  mount GrapeSwaggerRails::Engine => '/apidoc'
  mount API::Dispatch => '/api'
end
