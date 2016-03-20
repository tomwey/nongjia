module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.private_token
  end
  
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.private_token == cookies[:remember_token]
        log_in user
        @current_user = user
      end
    end
  end
  
  def log_out
    cookies.delete :user_id
    cookies.delete :remember_token
    session.delete(:user_id)
    @current_user = nil
  end
end