require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  def setup
    @user = users(:jack)
  end

  test "redirect when creating if not logged in" do
    assert_no_difference 'Relationship.count' do
      post :create
      assert_redirected_to login_url
    end
  end

  test "redirect when destroying if not logged in" do
    assert_no_difference 'Relationship.count' do
      delete :destroy
      assert_redirected_to login_url
    end
  end
end
