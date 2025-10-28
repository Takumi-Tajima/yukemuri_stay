class AccommodationsController < ApplicationController
  def index
    @accommodations = Accommodation.published.includes(:image_attachment).default_order
  end

  def show
    @accommodation = Accommodation.published.find(params.expect(:id))
  end
end
