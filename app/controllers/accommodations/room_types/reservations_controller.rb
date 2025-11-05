class Accommodations::RoomTypes::ReservationsController < Accommodations::RoomTypes::ApplicationController
  def new
    @reservation = current_user.reservations.build
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room_type = @room_type
    @reservation.calculate_total_amount

    if @reservation.save
      redirect_to my_upcoming_reservations_path, notice: t('controllers.created')
    else
      render :new, status: :unprocessable_content
    end
  end

  def confirm
    if request.get?
      return redirect_to new_accommodation_room_type_reservation_path(@accommodation, @room_type)
    end

    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room_type = @room_type
    @reservation.calculate_total_amount

    if @reservation.valid?
      render :confirm
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def reservation_params
    params.expect(reservation: %i[check_in_date nights adults children])
  end
end
