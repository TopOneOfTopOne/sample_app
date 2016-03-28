require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:jack)
    remember(@user)
  end

  test "#current_user should return right user when session is nil" do
    assert_equal @user, current_user # assert_equal <expected>, <actual>
    assert is_logged_in?
  end

  test "#current_user returns nil when remember digest is nil" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token)) # updating the remember_digest column
    assert_nil current_user
  end
end