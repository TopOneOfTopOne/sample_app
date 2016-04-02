require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jack)
    @other_user = users(:david)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@other_user)
    assert_template 'users/show_follows'
    assert_match @other_user.following.count.to_s, response.body
    @other_user.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@other_user)
    assert_template 'users/show_follows'
    assert_match @other_user.followers.count.to_s, response.body
    @other_user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end
end
