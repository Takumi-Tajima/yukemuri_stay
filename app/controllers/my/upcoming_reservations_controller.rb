class My::UpcomingReservationsController < My::ApplicationController
  def index
    # TODO: 本当にincludesで良いの？preloadかeager_loadの方が良いのでは？
    @reservations = current_user.reservations.includes(room_type: :accommodation).default_order
  end

  def show
    @reservation = current_user.reservations.find(params.expect(:id))
  end
end
