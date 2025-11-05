class My::UpcomingReservationsController < My::ApplicationController
  def index
    # TODO: 本当にincludesで良いの？preloadかeager_loadの方が良いのでは？
    @reservations = current_user.reservations.upcoming.includes(room_type: :accommodation).default_order
  end

  def show
    @reservation = current_user.reservations.upcoming.find(params.expect(:id))
  end
end
