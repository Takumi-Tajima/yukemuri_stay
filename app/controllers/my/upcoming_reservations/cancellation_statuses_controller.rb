class My::UpcomingReservations::CancellationStatusesController < My::UpcomingReservations::ApplicationController
  def update
    @reservation.cancel!
    redirect_to my_upcoming_reservations_path, notice: t('controllers.updated'), status: :see_other
  rescue StandardError
    redirect_to my_upcoming_reservation_path(@reservation), alert: t('controllers.can_not_be_updated'), status: :see_other
  end
end
