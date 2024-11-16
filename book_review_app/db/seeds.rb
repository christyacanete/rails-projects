# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
   
# Add sample books
book1 = Book.find_or_create_by(title: "City of Stairs", author: "Robert Bennett")
book1.cover_image.attach(io: File.open(Rails.root.join("db", "seeds", "images", "CityofStairs.jpg")), filename: "city_of_stairs.jpg", content_type: "image/jpg")

book2 = Book.find_or_create_by(title: "The Buried Giant", author: "Kazuo Ishiguro")
book2.cover_image.attach(io: File.open(Rails.root.join("db", "seeds", "images", "TheBuriedGiant.jpg")), filename: "the_buried_giant.jpg", content_type: "image/jpg")

book3 = Book.find_or_create_by(title: "The Poppy War", author: "R.F. Kuang")
book3.cover_image.attach(io: File.open(Rails.root.join("db", "seeds", "images", "ThePoppyWar.jpeg")), filename: "the_poppy_war.jpeg", content_type: "image/jpeg")

# Find an existing user by email (or any other unique attribute)
user1 = User.find_by(email: "christycanete@email.com")

# Add sample Reviews
Review.create(content: "Amazing book! Highly recommend.", rating: 5, user: user1, book: book1)
Review.create(content: "It was an interesting read.", rating: 4, user: user1, book: book2)
Review.create(content: "Not my type, but well-written.", rating: 3, user: user1, book: book3)