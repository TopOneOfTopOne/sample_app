# some database adapters use case-sensitive indicies but in this scenario we don't want this so we use a callback

class User < ActiveRecord::Base
  before_save {self.email = email.downcase} # <= callback # store all emails in lowercase # could be written as self.email = self.email.downcase
  VALID_EMAIL_REGEX = /\A[\w\+\-\.]+@[a-z\d\-\.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50} # userObj.errors.full_messages show detail of error
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password # this method gives ability to save securely hashed password_digest attribute to database, authenticate method that returns user when the password is correct and false otherwise
  validates :password, presence:true, length: {minimum: 6}
end
