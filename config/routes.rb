Rails.application.routes.draw do
  
  mount RedactorRails::Engine => '/redactor_rails'

  ######################### 微信公众平台开发 ###########################
  post '/wechat' => 'weixin/home#welcome', defaults: { format: 'xml' }
  get "/wechat" => 'weixin/home#show'
  get "/fetch_access_token" => 'weixin/home#fetch_access_token'
  
  # 微信商城
  namespace :wechat_shop, path: 'wx-shop' do
    root 'home#index'
    resources :pages, path: :p, only: [:show]
    resources :products, only: [:show]
    resources :orders, only: [:index, :show, :new, :create] do
      collection do
        get :no_pay
        get :shipping
      end
    end
    resources :shipments
    # resources :coupons
    resources :discountings, path: :coupons, as: :coupons, only: [:index, :new, :create]
    # resource :discount_event, path: :event, as: :event, only: [:index] do
    #   post :active, on: :member
    # end
    
    resource  :user do
      patch 'update_current_shipment' => 'users#update_current_shipment'
      collection do
        get :orders
      end
      get :settings, on: :member
      get :events,   on: :member
      get :invite,   on: :member
    end
    
    get    'login'    => 'sessions#new',       as: :login
    get    'redirect' => 'sessions#save_user', as: :redirect_uri
    delete 'logout'   => 'sessions#destroy',   as: :logout
    # post   '/orders/notify'   => 'orders#notify',      as: :notify
    get   '/orders/notify'   => 'orders#notify',      as: :notify
  end
  
  ############################### end ################################
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  require 'sidekiq/web'
  authenticate :admin_user do
    mount Sidekiq::Web => 'sidekiq'
  end
  
  mount GrapeSwaggerRails::Engine => '/apidoc'
  mount API::Dispatch => '/api'
end
