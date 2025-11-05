class Administrators::Accommodations::RoomTypesController < Administrators::Accommodations::ApplicationController
  before_action :set_room_type, only: %i[show edit update destroy]

  def show
  end

  def new
    @room_type = @accommodation.room_types.build
  end

  def edit
  end

  def create
    @room_type = @accommodation.room_types.build(room_type_params)

    if @room_type.save
      redirect_to administrators_accommodation_room_type_path(@accommodation, @room_type), notice: t('controllers.created')
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @room_type.update(room_type_params)
      redirect_to administrators_accommodation_room_type_path(@accommodation, @room_type), notice: t('controllers.updated'), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @room_type.destroy!
    redirect_to administrators_accommodation_path(@accommodation), notice: t('controllers.destroyed'), status: :see_other
  rescue ActiveRecord::DeleteRestrictionError
    redirect_to administrators_accommodation_path(@accommodation), alert: t('reservation.room.restrict_with_exception'), status: :see_other
  end

  private

  def set_room_type
    @room_type = @accommodation.room_types.find(params.expect(:id))
  end

  def room_type_params
    params.expect(room_type: %i[name description capacity base_price main_image])
  end
end
