class User < ApplicationRecord

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
  
end
