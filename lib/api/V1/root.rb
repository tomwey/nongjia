module API
  module V1
    class Root < Grape::API
      version 'v1'
      
      helpers API::CommHelpers
      helpers API::SharedParams
      
      mount API::V1::Welcome
      mount API::V1::UsersAPI
      
    end
  end
end