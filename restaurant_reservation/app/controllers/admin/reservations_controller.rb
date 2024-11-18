class Admin::ReservationsController < ApplicationController
  before_action :require_admin

  def contact
    @reservation = Reservation.find(params[:id])
  end

  def send_message
    @reservation = Reservation.find(params[:id])
    message = params[:message]

    if message.blank?
      flash[:danger] = "Message cannot be blank."
      redirect_to contact_admin_reservation_path(@reservation)
    else
      ReservationMailer.admin_contact_email(@reservation, message).deliver_now
      flash[:success] = "Email sent to #{@reservation.user.email} successfully."
      redirect_to admin_dashboard_path
    end
  end

  private

  def require_admin
    unless current_user&.admin?
      flash[:danger] = "You are not authorized to view this page."
      redirect_to root_path
    end
  end
end
