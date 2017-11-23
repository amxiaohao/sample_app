module SessionsHelper

  #登录用户
  def log_in(user)
    session[:user_id] = user.id
  end

  #获取当前用户，如果未登录则返回nil
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  #判断用户是否已经登录，是则返回true, 否则返回false
  def logged_in?
    !current_user.nil?
  end

  #退出登录
  def logout
    session.delete(:user_id)
    @current_user = nil
  end
end
