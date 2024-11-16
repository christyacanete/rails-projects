class User < ApplicationRecord
  # Secure password handling
  has_secure_password

  # Associations
  has_many :reviews

  # Allow users to attach pictures
  has_one_attached :profile_picture
  # before_save :resize_profile_picture
  # Use after_commit to ensure the image is available before processing
  after_commit :resize_profile_picture, on: :create

  # Validations with custom error messages
  validates :name, presence: { message: "Name can't be blank" },
                   length: { maximum: 50, message: "Name is too long (maximum is 50 characters)" }
                   
  validates :email, presence: { message: "Email can't be blank" },
                    length: { maximum: 255, message: "Email is too long (maximum is 255 characters)" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email is invalid" },
                    uniqueness: { message: "Email has already been taken" }

  # Make password validation conditional (only required on create or when changing)
  validates :password, length: { minimum: 6, message: "Password is too short (minimum is 6 characters)" },
                       confirmation: { message: "Password confirmation doesn't match Password" },
                       allow_nil: true

  # Password confirmation presence validation (only on create or when changing password)
  validates :password_confirmation, presence: { message: "Password confirmation can't be blank" }, if: -> { password.present? }

  # Custom validation for profile picture
  validate :acceptable_profile_picture

  private

  # Custom validation for profile picture
  def acceptable_profile_picture
    return unless profile_picture.attached?

    acceptable_types = ["image/png", "image/jpg", "image/jpeg"]
    unless acceptable_types.include?(profile_picture.content_type)
      errors.add(:profile_picture, "must be a PNG, JPG, or JPEG")
    end
  end

  # Resize profile picture before saving
  def resize_profile_picture
    return unless profile_picture.attached?
  
    # Create a temporary file for the processed image
    processed_image = ImageProcessing::MiniMagick
                        .source(profile_picture.download)
                        .resize_to_limit(300, 300)
                        .call
  
    # Reattach the processed image
    profile_picture.attach(
      io: File.open(processed_image.path),
      filename: profile_picture.filename.to_s,
      content_type: profile_picture.content_type
    )
    
    # Ensure the temporary file is closed and unlinked after use
    processed_image.close!
    processed_image.unlink
  end
end
