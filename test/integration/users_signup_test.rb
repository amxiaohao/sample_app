require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:                  "",
                                          email:                 "invalid@invalid",
                                          password:              "foo",
                                          password_confirmation: "bar" } }
    end
    # assert_template "user/new"
  end

  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name:                  "foobar", 
                                          email:                 "foo@bar.com", 
                                          password:              "foobar", 
                                          password_confirmation: "foobar" } }
    end
    # follow_redirect!
    # assert_template 'users/show'
  end
end
