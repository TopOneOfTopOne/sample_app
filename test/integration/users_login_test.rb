require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jack) # referring to users.yml
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: 0)
    assert_nil cookies['remember_token']
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: 1)
    assert_not_nil cookies['remember_token']
  end


  test "login with valid information then logout" do
    get login_path
    post login_path, session: {email: @user.email, password: 'password'}
    assert_redirected_to user_url(@user)
    follow_redirect!
    assert is_logged_in?
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', logout_path
    delete logout_path
    assert_not is_logged_in?
  end

  test "login with invalid information" do
    get login_path # not required but good for error checking
    assert_template 'sessions/new'
    post login_path, session: {
        email: "somedudenotindatabase@gmail.com",
        password: "somepasswordnotrelatedtoemail"
    }
    assert_template 'sessions/new'
    # this tests if flash is showing up correctly
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
