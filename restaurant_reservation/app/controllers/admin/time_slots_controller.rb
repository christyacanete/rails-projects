class Admin::TimeSlotsController < ApplicationController
  before_action :require_admin

  def index
    @time_slots = TimeSlot.order(:date, :start_time)
  end

  def new
    @time_slot = TimeSlot.new
  end

  def create
    @time_slot = TimeSlot.new(time_slot_params)
    if @time_slot.save
      flash[:success] = "Time slot created successfully."
      redirect_to admin_time_slots_path
    else
      flash.now[:danger] = "Failed to create time slot."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @time_slot = TimeSlot.find(params[:id])
  end

  def update
    @time_slot = TimeSlot.find(params[:id])
    if @time_slot.update(time_slot_params)
      flash[:success] = "Time slot updated successfully."
      redirect_to admin_time_slots_path
    else
      flash.now[:danger] = "Failed to update time slot."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @time_slot = TimeSlot.find(params[:id])
    if @time_slot.destroy
      flash[:success] = "Time slot deleted successfully."
      redirect_to admin_time_slots_path
    else
      flash[:danger] = "Failed to delete time slot."
      redirect_to admin_time_slots_path
    end
  end

  private

  def time_slot_params
    params.require(:time_slot).permit(:date, :start_time, :end_time, :max_tables)
  end
end
