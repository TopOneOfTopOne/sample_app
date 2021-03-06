# some database adapters use case-sensitive indicies but in this scenario we don't want this so we use a callback

class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy

  has_many :active_relationships, foreign_key: 'follower_id',
           class_name: 'Relationship', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, foreign_key: 'followed_id',
           class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower # source is not needed but just to highlight the symmetry

  attr_accessor :remember_token

  before_save {self.email = email.downcase} # <= callback # store all emails in lowercase # could be written as self.email = self.email.downcase or simply email.downcase!

  VALID_EMAIL_REGEX = /\A[\w\+\-\.]+@[a-z\d\-\.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50} # userObj.errors.full_messages show detail of error

  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password # this method gives ability to save securely hashed password_digest attribute to database, authenticate method that returns user when the password is correct and false otherwise
  validates :password, presence:true, length: {minimum: 6}, allow_nil: true # allow_nil allows empty passwords however during signup this will not be allowed because of has_secure_password

  # Create a hash or digest using minumum cost for efficiency
  #
  # A large cost will make it very difficult to reverse the hash
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Create a base64 random string
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token)) # updates the database column :remember_digest
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Compare given token with hashed token analogous to authenticate method supplied by #has_secure_password
  def authenticated?(remember_token)
    return nil if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def feed
    # using the ? allows id to be properly escaped before querying databse this prevents sql injection attaacks
    #
    # Micropost.where('user_id IN (?) OR user_id = (?)', following_ids, id) can be used but if is inefficient since calling following_ids will pull
    # all ids in memory, using SQL can optimize this
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",user_id: id)
  end

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end
end
