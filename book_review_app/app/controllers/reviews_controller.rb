class ReviewsController < ApplicationController
  # Only logged in users can add reviews
  before_action :require_login, only: [:create, :edit, :update, :destroy]
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def new
    @book = Book.find(params[:book_id]) # Retrieve the book for which the review is being created
    @review = @book.reviews.build
  end

  # Create a review
  def create
    @book = Book.find(params[:book_id]) # Find the associated book
    @review = @book.reviews.build(review_params) # Build review associated with the book
    @review.user = current_user # Associate the review with the logged-in user

    if @review.save
      flash[:success] = "Review added successfully!"
      redirect_to book_path(@book)
    else
      flash.now[:danger] = "Failed to add review. Please check the form for errors."
      render 'books/show' # Re-render the show page with error messages
    end
  end

  # Edit a review
  def edit
    @book = @review.book # Retrieve the associated book
  end

  # Update the review
  def update
    @book = @review.book
    if @review.update(review_params)
      flash[:success] = "Review updated successfully!"
      redirect_to book_path(@book)
    else
      flash.now[:danger] = "Failed to update review. Please check the form for errors."
      render :edit
    end
  end

  def destroy
    @review.destroy
    flash[:success] = "Review deleted successfully."
    redirect_to book_path(@review.book)
  end

  private

  # Strong parameters for review
  def review_params
    params.require(:review).permit(:content, :rating)
  end

  # Redirect to login if user is not logged in
  def require_login
    unless logged_in?
      flash[:alert] = "Please log in to submit a review."
      redirect_to login_path
    end
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_user
    unless @review.user == current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to book_path(@review.book)
    end
  end

end
