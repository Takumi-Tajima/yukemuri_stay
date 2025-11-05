class Administrators::AccommodationsController < Administrators::ApplicationController
  before_action :set_accommodation, only: %i[show edit update destroy]

  def index
    @accommodations = Accommodation.default_order
  end

  def show
  end

  def new
    @accommodation = Accommodation.new
  end

  def edit
  end

  def create
    @accommodation = Accommodation.new(accommodation_params)

    if @accommodation.save
      redirect_to administrators_accommodation_path(@accommodation), notice: t('controllers.created')
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @accommodation.update(accommodation_params)
      redirect_to administrators_accommodation_path(@accommodation), notice: t('controllers.updated'), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @accommodation.destroy!
    redirect_to administrators_accommodations_path, notice: t('controllers.destroyed'), status: :see_other
  rescue ActiveRecord::DeleteRestrictionError
    redirect_to administrators_accommodation_path(@accommodation), alert: t('reservation.room.restrict_with_exception'), status: :see_other
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find(params.expect(:id))
  end

  def accommodation_params
    params.expect(accommodation: %i[name prefecture address phone_number accommodation_type description main_image published])
  end
end
