class SessionsController < ApplicationController
  def new
  end

  def create
    #Find the user by email
    user = User.find_by(email: params[:session][:email].downcase)
    # Check if password is correct
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      # Display error message for failed login attempt
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
