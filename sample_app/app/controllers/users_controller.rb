class UsersController < ApplicationController
  # Ensures only logged-in users can access the edit, update, and index actions.
  before_action :logged_in_user, only: [:edit, :update, :index]
  # Ensures only the correct user can edit or update their profile.
  before_action :correct_user, only: [:edit, :update]
  # Restricts the destroy action to admins only.
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    # Finds and deletes the user, then displays a success message and redirects to the users index page.
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end  

  private

    # Strong parameters: Permits only the listed attributes to be passed in forms.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms a logged-in user to restrict access to certain actions.
    def logged_in_user
      unless logged_in?
        store_location  # Saves the requested URL to redirect back to it after login.
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user for edit and update actions to prevent unauthorized access.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user to restrict certain actions, like destroying users, to admins only.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
