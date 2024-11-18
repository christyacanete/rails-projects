class ReservationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :destroy]

  # Display the user's reservation list (dashboard)
  def index
    @reservations = current_user.reservations.includes(:time_slot)
  end

  # Display the form to create a new reservation
  def new
    @reservation = Reservation.new
  end

  # Create a new reservation
  def create
    @reservation = current_user.reservations.build(reservation_params)
    if @reservation.save
      #ReservationMailer.confirmation_email(@reservation).deliver_now
      flash[:success] = "Reservation confirmed! A confirmation email has been sent."
      redirect_to reservations_path # This will take the user to the dashboard (reservation list)
    else
      flash.now[:danger] = "Failed to create reservation. Please check your input."
      render :new, status: :unprocessable_entity
    end
  end  

  # Cancel a reservation
  def destroy
    if current_user.admin?
      # Admin can cancel any reservation
      reservation = Reservation.find(params[:id])
      reservation.destroy
      flash[:success] = "Reservation canceled successfully. A cancellation email has been sent."
      redirect_to admin_dashboard_path and return # Redirect admins to the Admin Dashboard
    else
      # Regular users can only cancel their own reservations
      reservation = current_user.reservations.find(params[:id])

      # Enforce cancellation rule
      if Time.current >= (reservation.time_slot.date.to_time + reservation.time_slot.start_time.seconds_since_midnight - 2.hours)
        flash[:danger] = "Cancellations are not allowed within 2 hours of the reservation time."
        redirect_to reservations_path and return
      end           
    end

    # Send cancellation email
    #ReservationMailer.cancellation_email(reservation).deliver_now

    # Destroy the reservation
    reservation.destroy
    flash[:success] = "Reservation canceled successfully. A cancellation email has been sent."
    redirect_to reservations_path # Ensure the action ends here
  end

  private

  def reservation_params
    params.require(:reservation).permit(:time_slot_id, :number_of_people)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in to make a reservation."
      redirect_to login_path
    end
  end
end
