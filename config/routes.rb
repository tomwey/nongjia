Rails.application.routes.draw do
  
  ######################### 微信公众平台开发 ###########################
  post '/wechat' => 'weixin/home#welcome', defaults: { format: 'xml' }
  get "/wechat" => 'weixin/home#show'
  get "/fetch_access_token" => 'weixin/home#fetch_access_token'
  
  
  namespace :wechat_shop do
    root 'home#index'
    resources :products, only: [:show]
    resources :orders do
      collection do
        get :no_pay
        get :shipping
      end
    end
    resources :shipments
    resource  :user do
      patch 'update_current_shipment' => 'users#update_current_shipment'
      collection do
        get :orders
      end
      get :settings, on: :member
    end
    
    get    'login'    => 'sessions#new',       as: :login
    get    'redirect' => 'sessions#save_user', as: :redirect_uri
    delete 'logout'   => 'sessions#destroy',   as: :logout
  end
  
  ############################### end ################################
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  mount GrapeSwaggerRails::Engine => '/apidoc'
  mount API::Dispatch => '/api'
end
