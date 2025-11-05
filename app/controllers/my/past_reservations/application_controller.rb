class My::PastReservations::ApplicationController < My::ApplicationController
  before_action :set_reservation

  private

  def set_reservation
    @reservation = current_user.reservations.history.find(params.expect(:past_reservation_id))
  end
end
