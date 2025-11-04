class AccommodationsController < ApplicationController
  def index
    @q = Accommodation.published.includes(:main_image_attachment).ransack(params[:q])
    @accommodations = @q.result.default_order
  end

  def show
    @accommodation = Accommodation.published.find(params.expect(:id))
  end
end
