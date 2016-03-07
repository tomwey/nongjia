Rails.application.routes.draw do
  
  # resources :products do
  #   resources :images, only: [:create, :destroy]
  # end
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount API::Dispatch => '/api'
end
