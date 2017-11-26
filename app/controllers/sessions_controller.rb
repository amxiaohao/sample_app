class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])

    if user && user.authenticate(params[:session][:password])
      #将user_id存入session
      log_in user
      #将user_id存入cookies
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # remember user
      redirect_to user_url(user)
    else
      flash.now[:danger] = "Invalid email/password"
      render "new"
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end
end
