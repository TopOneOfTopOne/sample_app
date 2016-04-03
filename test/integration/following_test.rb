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

  test "following" do
    @user.unfollow(@other_user) if @user.following?(@other_user)
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @other_user.id
    end
  end

  test "unfollowing" do
    @user.follow(@other_user) unless @user.following?(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), relationship: relationship.id
    end
  end

  test "following button" do
    @user.unfollow(@other_user) if @user.following?(@other_user)
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other_user.id
    end
  end

  test "unfollow button" do

    @user.follow(@other_user) unless @user.following?(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship), relationship: relationship.id
    end
  end
end
