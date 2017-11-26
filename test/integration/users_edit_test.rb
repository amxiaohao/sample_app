require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user =       users(:foo)
    @other_user = users(:bar)
  end

  test "invalid edit information" do
    # log_in_as @user
    post login_path, params: { session: { email:    @user.email, 
                                          password: "password" } }
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { email:                 "invalid@email", 
                                              name:                  "", 
                                              password:              "foo", 
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  test "valid edit information" do
    # log_in_as @user
    post login_path, params: { session: { email:    @user.email, 
                                          password: "password" } }
    get edit_user_path(@user)
    assert_template 'users/edit'
    email = "example@email.com"
    name  = "foo bar"
    patch user_path(@user), params: { user: { email:                 email, 
                                              name:                  name, 
                                              password:              "", 
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal @user.email, email
    assert_equal @user.name, name
  end

  #测试当没有登录的时候，请求edit页面将被跳转到登录页面
  test "should redirect to edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  #测试当没有登录的时候，向update做patch操作会被跳转到登录页面
  test "should redirect to update when not logged in" do
    patch user_path(@user), params: { user: { email: @user.email, 
                                              name:  @user.name } }
    assert_not flash.empty?
    assert_redirected_to login_url    
  end

  #测试登录用户尝试请求其他用户的资料编辑页面时候，会被跳转到首页
  test "should redirect to edit when logged in as wrong user" do
    post login_path, params: { session: { email:    @other_user.email, 
                                          password: "password" } }
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  #测试登录用户尝试编辑其他用户的资料的时候，会被跳转到首页
  test "should redirect to update when logged in as wrong user" do
    post login_path, params: { session: { email:    @other_user.email, 
                                          password: "password" } }
    patch user_path(@user), params: { user: { email: @other_user.email, 
                                              name:  @other_user.name } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
