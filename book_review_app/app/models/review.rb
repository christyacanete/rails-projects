class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # Validations
  validates :content, presence: { message: "Content can't be blank" }
  validates :rating, presence: { message: "Rating can't be blank" },
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, message: "Rating must be between 1 and 5" }
end
