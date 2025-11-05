class Administrators::ReservationsController < Administrators::ApplicationController
  before_action :set_reservation, only: %i[show edit update]

  def index
    @reservations = Reservation.includes(:user, room_type: :accommodation).default_order
  end

  def show
  end

  def edit
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to administrators_reservations_path, notice: t('controllers.updated'), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params.expect(:id))
  end

  def reservation_params
    params.expect(reservation: %i[status])
  end
end
