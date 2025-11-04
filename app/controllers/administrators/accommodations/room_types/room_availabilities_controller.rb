class Administrators::Accommodations::RoomTypes::RoomAvailabilitiesController < Administrators::Accommodations::RoomTypes::ApplicationController
  before_action :set_room_availability, only: %i[edit update]

  def new
    @room_availability = @room_type.room_availabilities.build
  end

  def edit
  end

  def create
    @room_availability = @room_type.room_availabilities.build(room_availability_params)

    if @room_availability.save
      redirect_to administrators_accommodation_room_type_path(@accommodation, @room_type), notice: t('controllers.created')
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @room_availability.update(room_availability_params)
      redirect_to administrators_accommodation_room_type_path(@accommodation, @room_type), notice: t('controllers.updated'), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_room_availability
    @room_availability = @room_type.room_availabilities.find(params.expect(:id))
  end

  def room_availability_params
    params.expect(room_availability: %i[date remaining_rooms])
  end
end
