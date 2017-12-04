require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foo)
  end

  # #测试主页有分页选项
  # test "index including pagination" do
  #   post login_path, params: { session: { email:    @user.email, 
  #                                         password: "password" } }
  #   get users_path
  #   assert_template 'users/index'
  #   assert_select 'div.pagination'
    
  #   User.paginate(page: 1).each do |user|
  #     assert_select 'a[href=?]', user_path(user), text: user.name
  #   end
  # end
  
end
