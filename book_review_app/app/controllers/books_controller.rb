class BooksController < ApplicationController

  # Action for searching a book based on query
  def index
    if params[:query].present?
      @books = Book.search(params[:query])
      flash.now[:notice] = "Showing results for: '#{params[:query]}'"
    else
      @books = Book.all
    end
  end

  # Show book details and its reviews
  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.includes(:user)
    @review = @book.reviews.build # Initializes a new review for the form
  end
end
