require 'test_helper'

class UserProfileTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jack)
  end

  test "displays profile correctly" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'h1>img.gravatar'
    assert_select 'h3', "Microposts (#{@user.microposts.count})" # inflexible, prone to be a point of failure
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body # response.body returns all html code not just the body
    end
  end
end
