class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      log_in user
      #flash[:success] = "Welcome back, #{user.name}!"
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    #flash[:success] = 'You have logged out successfully.'
    redirect_to logout_path
  end
end
