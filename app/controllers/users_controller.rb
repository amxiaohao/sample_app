class UsersController < ApplicationController
  before_action :login_required, only: [:index, :edit, :update, :destroy]
  before_action :admin_required, only: :destroy  
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page], per_page: 25)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      #通过直接确认并登录的方式注册用户
      # log_in @user
      # flash[:success] = "Welcome to Sample App"
      # redirect_to user_path(@user)
      
      #通过邮件确认的方式注册用户
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
  end

  #PATCH： users/1，所以在parmas[:id]中能拿到用户的id
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to user_url(@user)
    elsif
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).delete
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
  
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

    #前置过滤器，请求index, edit, update, destroy动作前需要登录
    def login_required
      unless logged_in?
        store_location
        flash[:danger] = "please log in"
        redirect_to login_url
      end
    end

    #前置过滤器，确保正确的用户
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless correct_user?(@user)
    end

    def admin_required
      redirect_to root_url unless current_user.admin?
    end
end
