require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jack)
  end
  test "unsuccessful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to @user
    patch user_path(@user), user: { name:             '',
                                    email:                 '',
                                    password:              '',
                                    password_confirmation: '' }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    name = 'john'
    email = 'john@gmail.com'
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: '',
                                    password_confirmation: '' }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
