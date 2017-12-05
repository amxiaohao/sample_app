class SessionsController < ApplicationController
  def new
  end

  # def create
  #   user = User.find_by_email(params[:session][:email])

  #   if user && user.authenticate(params[:session][:password])
  #     #将user_id存入session
  #     log_in user
  #     #将user_id存入cookies
  #     params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  #     # remember user
  #     redirect_back user_url(user)
  #   else
  #     flash.now[:danger] = "Invalid email/password"
  #     render "new"
  #   end
  # end

  def create
    user = User.find_by(email: params[:session][:email])

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back user_url(user)
      else
        flash[:warning] = "account not activated, please check your email to activate."
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end
end
