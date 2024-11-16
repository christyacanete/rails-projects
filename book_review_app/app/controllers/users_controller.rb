class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "You've successfully created an account!"
      redirect_to @user
    else
      flash.now[:danger] = "There were errors in your submission."
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user  # Ensure only the logged-in user can edit their profile
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "Profile updated successfully"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  # Strong parameters: Permits only the listed attributes to be passed in forms.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_picture)
  end
end
