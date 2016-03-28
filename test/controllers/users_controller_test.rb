require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:jack)
    @other_user = users(:david)
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
end
