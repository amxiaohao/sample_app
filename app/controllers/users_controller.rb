class UsersController < ApplicationController
  before_action :login_required, only: [:index, :edit, :update]
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
      log_in @user
      flash[:success] = "Welcome to Sample App"
      redirect_to user_path(@user)
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

  private
  
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

    #前置过滤器，请求edit和update两个动作前需要登录
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
end
