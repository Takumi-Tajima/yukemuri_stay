class Accommodations::RoomTypes::ReservationsController < Accommodations::RoomTypes::ApplicationController
  def new
    @reservation = current_user.reservations.build
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room_type = @room_type

    if @reservation.save
      # TODO: ユーザーのマイページへ遷移をさせる
      redirect_to root_path, notice: t('controllers.created')
    else
      render :new, status: :unprocessable_content
    end
  end

  def confirm
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room_type = @room_type

    # TODO: ここの説明できるようにしておくこと
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
