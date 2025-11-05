class My::PastReservationsController < My::ApplicationController
  def index
    @reservations = current_user.reservations.history.includes(room_type: :accommodation).default_order
  end

  def show
    @reservation = current_user.reservations.history.find(params.expect(:id))
  end
end
