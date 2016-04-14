module UsersHelper
  def user_avatar_tag(user,size = :normal, opts = {})
    return "" if user.blank?
    
    link = opts[:link] || false
    width = user_avatar_width_for_size(size)
    
    if user.avatar.blank?
      default_url = "avatar/#{size}.png"
      img = image_tag(default_url, alt: "用户头像", class: "img-circle")
    else
      if user.wechat_auth and user.wechat_auth.avatar_url.present?
        img = image_tag(user.wechat_auth.avatar_url, size: "#{width}x#{width}", alt: "用户头像", class: "img-circle")
      else
        img = image_tag(user.avatar.url(size), alt: "用户头像", class: "img-circle")
      end
      
    end
    
    if link
      raw %(<a href="#{user_path(user)}">#{img}</a>)
    else
      raw img
    end
    
  end
  
  def user_avatar_width_for_size(size)
    case size
    when :normal then 48
    when :small then 16
    when :large then 64
    when :big then 120
    else 48
    end
  end
  
end