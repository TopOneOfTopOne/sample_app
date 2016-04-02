require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
    @user = users(:jack)
    @other_user = users(:user_1)
  end

  test "relationship valid" do
    assert @relationship.valid?
  end

  test "follow and unfollow" do
    assert_not @other_user.following?(@user)
    @other_user.follow(@user)
    assert @other_user.following?(@user)
    @other_user.unfollow(@user)
    assert_not @other_user.following?(@user)
  end
end
