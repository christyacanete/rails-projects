class User < ApplicationRecord
  attr_accessor :remember_token  # Temporary token attribute for session management

  before_save { self.email = email.downcase }

  # Basic presence validation
  validates :name, presence: true
  validates :email, presence: true
  
  # Length validation
  validates :name, length: { maximum: 50 }
  validates :email, length: { maximum: 255 }

  # Format validation using a regular expression for email format
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }

  # Uniqueness validation to ensure no duplicate emails (case-insensitive)
  validates :email, uniqueness: { case_sensitive: false }
  
  # Secure password handling (requires bcrypt gem and password_digest column)
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  has_many :microposts

  # Returns a user's status feed.
  def feed
    Micropost.where("user_id = ?", id)
  end

  # Class method to generate a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Class method to return the hash digest of a given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Instance method to remember a user for persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Instance method to verify if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
