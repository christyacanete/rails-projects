class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  
  def new
    @user = User.new
  end

  # Display user dashboard
  def dashboard
    @reservations = current_user.reservations.includes(:time_slot)
    @reservation = Reservation.new
  end

  # Handle form submission
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Restaurant Reservation System!"
      redirect_to reservations_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_login
    unless logged_in?
      flash[:danger] = "Please log in to access your dashboard."
      redirect_to login_path
    end
  end
end
