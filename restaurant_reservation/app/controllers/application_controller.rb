class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include SessionsHelper

  helper_method :current_user # Make `current_user` available in views
  helper_method :logged_in?   # Make `logged_in?` available in views

  private

  # Define the current_user helper to retrieve the logged-in user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # Check if a user is logged in
  def logged_in?
    !!current_user
  end

  # Only admins should access certain admin actions
  def require_admin
    unless logged_in? && current_user.admin?
      flash[:danger] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
end
