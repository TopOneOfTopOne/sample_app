require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @user = users(:david)
    @micropost = microposts(:orange)
  end
  test "redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: {content: 'hello'}
    end
    assert_redirected_to login_url
  end

  test "redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "redirect destroy when wrong user" do
    log_in_as(@user)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to root_url
  end
end
