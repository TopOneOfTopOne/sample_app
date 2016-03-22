require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", about_path # what this means, look in html tag <a href=/about>
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", home_path
    assert_select "a[href=?]", help_path
    get signup_path
    assert_select "h1", "Sign Up"
  end


end
