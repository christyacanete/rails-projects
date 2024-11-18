class User < ApplicationRecord
  has_secure_password
  has_many :reservations, dependent: :destroy

  # Define admin role
  def admin?
    role == 'admin'
  end

  # Validations for Name
  validates :name, presence: true,
                   length: { in: 3..50, message: "must be between 3 and 50 characters" }

  # Validations for Email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, message: "must be a valid email format" },
                    uniqueness: { case_sensitive: false }

  # Validations for Password
  validates :password, presence: true,
                       length: { minimum: 5, message: "must be at least 5 characters" },
                       confirmation: true
  validates :password_confirmation, presence: true
end
