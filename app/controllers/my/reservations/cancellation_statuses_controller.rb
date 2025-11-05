class My::Reservations::CancellationStatusesController < My::Reservations::ApplicationController
  def update
    @reservation.cancel!
    redirect_to my_reservations_path, notice: t('controllers.updated'), status: :see_other
  rescue StandardError
    redirect_to my_reservation_path(@reservation), alert: t('controllers.can_not_be_updated'), status: :see_other
  end
end
