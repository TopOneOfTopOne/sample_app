require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'testname', email: 'testemail@email.com', password: 'password', password_confirmation: 'password')
  end

  test "should be vaild" do
    assert @user.valid?
  end

  test "name should not be blank" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should not be blank" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "b" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "b" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid email addresses" do
    valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid" # since minitest only returns line number and not specific value that failed we add second parameter to see which email failed the test
    end
  end

  test "email validation should reject invalid email addresses" do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end

  test "duplicate emails should not be allowed" do
    @user.save
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    assert_not dup_user.valid?
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = "     "
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

end
