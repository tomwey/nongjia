Rails.application.routes.draw do
  mount API::Dispatch => '/api'
end
