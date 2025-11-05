class My::UpcomingReservations::ApplicationController < My::ApplicationController
  before_action :set_reservation

  private

  def set_reservation
    @reservation = current_user.reservations.find(params.expect(:upcoming_reservation_id))
  end
end