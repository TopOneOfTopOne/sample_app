require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jack)
    @other_user = users(:david)
  end

  test "micropost interface" do
    log_in_as(@user)
    get home_path
    assert_select 'input[type=submit]'
    assert_select 'textarea', id: 'micropost_content'
    assert_template "static_pages/home"
    picture = fixture_file_upload('test/fixtures/rails.png','image/png')
    # valid submission
    assert_difference('Micropost.count', 1) do
      post microposts_path micropost: {content: 'hello', picture: picture}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'img', alt: 'rails'
    # invalid submission
    # assert_no_difference('Micropost.count') do
    #   post microposts_path micropost: {content: ''}
    # end

    # delete your own post
    assert_select 'a', text: 'Delete'
    first_post = @user.microposts.paginate(page: 1).first
    assert_difference('Micropost.count', -1) do
      delete micropost_path(first_post)
    end

    # visit someone else's profile
    get user_path @other_user
    assert_select 'a', text: 'Delete', count: 0
  end
end
