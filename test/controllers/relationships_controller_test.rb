require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  def setup
    @user = users(:jack)
    @other_user = users(:david)
  end

  test "redirect when creating if not logged in" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  test "redirect when destroying if not logged in" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
end
