class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])

    #注意!user.activated?这个判断条件，
    #可以避免其它用户拿到激活链接后用于登录该用户，很重要
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in(user)
      flash[:success] = "Account activated!"
      redirect_to user_url(user)
    else
      flash[:danger] = "Invalid activation link!"
      redirect_to root_url
    end
  end
end
