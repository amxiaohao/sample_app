class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])

    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user_url(user)
    else
      flash.now[:danger] = "Invalid email/password"
      render "new"
    end
  end

  def delete
    logout
    redirect_to root_url
  end
end
