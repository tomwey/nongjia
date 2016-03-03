module API
  module V1
    class UsersAPI < Grape::API
      # 用户快捷登录
      resource :account do
        desc "用户登录"
        params do
          requires :mobile, type: String, desc: "用户手机号，必须"
          requires :code,   type: String, desc: "短信验证码，必须"
        end
        post :login do
          # 手机号检测
          unless check_mobile(params[:mobile])
            return render_error(1001, "不正确的手机号")
          end
          
          # TODO: 验证码检测
          
          # 快捷登录
          u = User.find_by(mobile: params[:mobile])
          if u.blank?
            u = User.create!(mobile: params[:mobile])
          end
          render_json(u, API::V1::Entities::User)
          
        end # end post login
      end # end account resource
      
      resource :user do
        desc "修改头像"
        params do
          requires :token,  type: String, desc: "用户认证Token, 必须"
          requires :avatar, type: Rack::Multipart::UploadedFile, desc: "用户头像"
        end
        post :update_avatar do
          user = authenticate!
          
          if params[:avatar]
            user.avatar = params[:avatar]
          end
          
          if user.save
            render_json(user, API::V1::Entities::User)
          else
            render_error(3001, user.errors.full_messages.join(","))
          end
        end # end update_avatar
        
        desc "修改昵称"
        params do
          requires :token,    type: String, desc: "用户认证Token, 必须"
          requires :nickname, type: String, desc: "用户昵称"
        end
        post :update_nickname do
          user = authenticate!
          
          if params[:nickname]
            user.nickname = params[:nickname]
          end
          
          if user.save
            render_json(user, API::V1::Entities::User)
          else
            render_error(3002, user.errors.full_messages.join(","))
          end
        end # end update nickname
        
      end # end user resource
      
    end 
  end
end