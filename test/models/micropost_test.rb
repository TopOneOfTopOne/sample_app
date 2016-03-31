require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:jack)
    @micropost = @user.microposts.build(content: 'hello world') # create cannot be used since it doesn't return an object
  end

  test "Micropost should be valid" do
    assert @micropost.valid?
  end

  test "user_id foreign key cannot be missing" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content cannot be missing" do
    @micropost.content = "    "
    assert_not @micropost.valid?
  end

  test "content cannot be greater than 140 char length" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end

  test "Display most recent posts first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
