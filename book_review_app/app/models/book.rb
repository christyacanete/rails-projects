class Book < ApplicationRecord

  has_many :reviews
  has_one_attached :cover_image

  # Validations to ensure title and author are present
  validates :title, presence: { message: "Title can't be blank" }
  validates :author, presence: { message: "Author can't be blank" }

  # Method to calculate average rating
  def average_rating
    return nil if reviews.empty?
    reviews.average(:rating).to_f.round(1)
  end

  # Search method to filter books by title or author
  def self.search(query)
    where("title ILIKE ? OR author ILIKE ?", "%#{query}%", "%#{query}%")
  end
end
