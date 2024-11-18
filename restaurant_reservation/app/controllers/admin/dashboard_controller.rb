class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @total_reservations = Reservation.count
    @fully_booked_slots = TimeSlot.joins(:reservations).group(:id).having('COUNT(reservations.id) >= max_tables').count.keys
    @available_tables = TimeSlot.all.sum { |slot| slot.max_tables - slot.reservations.count }
    @reservations = Reservation.includes(:user, :time_slot).order('time_slots.date, time_slots.start_time')

    @date_filter = params[:date]
    @filtered_reservations = if @date_filter.present?
                             Reservation.joins(:time_slot).where(time_slots: { date: @date_filter })
                           else
                             Reservation.all
                           end
    @reservations = @filtered_reservations.includes(:user, :time_slot).order('time_slots.date, time_slots.start_time')
  end

  def calendar
    @time_slots = TimeSlot.includes(:reservations).order(:date, :start_time)
  end

  def daily
    @reservations = Reservation.joins(:time_slot)
                               .where(time_slots: { date: Date.today })
                               .order('time_slots.start_time')
  end

  def weekly
    @reservations = Reservation.joins(:time_slot)
                               .where(time_slots: { date: Date.today.beginning_of_week..Date.today.end_of_week })
                               .order('time_slots.date, time_slots.start_time')
  end

  def monthly
    @reservations = Reservation.joins(:time_slot)
                               .where(time_slots: { date: Date.today.beginning_of_month..Date.today.end_of_month })
                               .order('time_slots.date, time_slots.start_time')
  end

  private

  def require_admin
    unless current_user&.admin?
      flash[:danger] = "You are not authorized to view this page."
      redirect_to root_path
    end
  end
end
