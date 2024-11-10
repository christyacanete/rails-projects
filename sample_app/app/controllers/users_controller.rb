class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # Allows you to pause code execution and open a debugging console
    # byebug
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save (e.g., redirect to the user's profile)
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
