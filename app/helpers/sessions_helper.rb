module SessionsHelper

  #登录用户
  #将user_id存入session中
  def log_in(user)
    session[:user_id] = user.id
  end

  #把生成的cookies摘要赋值给user.remember_digest
  #为用户的浏览器创建cookies[:user_id]
  #为用户的浏览器创建cookies[:remember_token]
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  #生成cookies操作的反处理：
  #删除User模型中self.remember_digest字段的值
  #删除用户浏览器cookies[:user_id]的值
  #删除用户浏览器cookies[:remember_token]的值
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  #获取当前用户，如果未登录则返回nil
  def current_user
    #在session中查找用户
    if (user_id = session[:user_id])
      @current_user ||= User.find_by_id(user_id)
    #在cookies中查找用户
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by_id(user_id)
      if user && user.authenticated?(cookies[:remember_token])
        @current_user = user
      end
    end
  end

  #判断用户是否已经登录，是则返回true, 否则返回false
  def logged_in?
    !current_user.nil?
  end

  #退出登录
  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
