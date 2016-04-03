require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:jack)
    @other_user = users(:david)
    @admin_user = users(:don)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "redirect update when not logged in" do
    patch :update, id: @user
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when logged in with wrong user" do
    log_in_as(@user)
    get :edit, id: @other_user.id
    assert_redirected_to root_url
  end

  test "should redirect update when logged in with wrong user" do
    log_in_as(@user)
    get :update, id: @other_user.id
    assert_redirected_to root_url
  end

  test "should redirect when destroying not logged in" do
    delete :destroy, id: @user.id
    assert_redirected_to login_url
  end

  test "should redirect when destroying non-admin" do
    log_in_as(@user)
    delete :destroy, id: @other_user.id
    assert_redirected_to root_url
  end

  test "should delete user when destroying as admin" do
    log_in_as(@admin_user)
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.id
    end
    assert_redirected_to users_path
  end

  test "should not allow admin attribute to be updated" do
    log_in_as(@user)
    patch :update, id: @user.id, user: {
        name: 'jack',
        email: 'jack@lol.com',
        password: 'asd123',
        password_confirmation: 'asd123',
        admin: true
    }
    assert_not @user.reload.admin?
  end

  test "redirect not logged in following" do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test "redirect not logged in followers" do
    get :followers, id: @user
    assert_redirected_to login_url
  end

  test "#feed" do
    user_feed = @user.feed
    user_microposts = Micropost.find_by(user_id: @user.id)
    other_user_microposts = Micropost.find_by(user_id: @other_user.id)
    assert user_feed.include?(user_microposts)
    assert user_feed.include?(other_user_microposts)
  end
end
