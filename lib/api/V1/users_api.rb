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
      
      # 三方快捷登录
      resource :auth do
        desc "三方认证快捷登录"
        params do
          requires :uid,        type: String, desc: "第三方登录用户唯一ID"
          requires :provider,   type: String, desc: "第三方登录平台名称，例如：Wechat, QQ, Weibo等"
          optional :nickname,   type: String, desc: "第三方登录用户的昵称"
          optional :avatar_url, type: String, desc: "第三方登录用户的头像URL地址"
        end
        post :login do
          auth = Authorization.find_by(provider: params[:provider], uid: params[:uid])
          if auth.present?
            return render_json(auth.user, API::V1::Entities::User)
          end
          
          user = User.new
          user.nickname = params[:nickname] if params[:nickname].present?
          user.remote_avatar_url = params[:avatar_url] if params[:avatar_url].present?
          user.authorizations << Authorization.new(provider: params[:provider], uid: params[:uid])
          
          if user.save
            # 添加认证
            # Authorization.create!(provider: params[:provider], uid: params[:uid], user_id: user.id)
            render_json(user, API::V1::Entities::User)
          else
            render_error(1006, user.errors.full_messages.join(','))
          end
        end # end end login
        
        desc "绑定手机号"
        params do
          requires :token,  type: String, desc: "用户认证Token"
          requires :uid,        type: String, desc: "第三方登录用户唯一ID"
          requires :provider,   type: String, desc: "第三方登录平台名称，例如：Wechat, QQ, Weibo等"
          requires :mobile, type: String, desc: "用户手机"
          requires :code,   type: String, desc: "验证码"
        end
        post :bind do
          user = authenticate!
          
          # 手机号检测
          unless check_mobile(params[:mobile])
            return render_error(1001, "不正确的手机号")
          end
          
          if user.mobile.present?
            return render_error(1005, "您已经绑定过手机")
          end
          
          current_user = User.find_by(mobile: params[:mobile])
          if current_user.present?
            # 该手机号已经存在或者被绑定过
            current_user.authorizations.find_or_create_by!(provider: params[:provider], uid: params[:uid])
            render_json(current_user, API::V1::Entities::User)
          else
            # 该手机号不存在或者未被绑定过，直接将手机号绑定到登录账号
            user.mobile = params[:mobile]
            if user.save
              render_json(user, API::V1::Entities::User)
            else
              render_error(1006, user.errors.full_messages.join(','))
            end
          end
          
        end # end post bind
        
      end # end resource auth
      
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