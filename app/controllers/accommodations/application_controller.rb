class Accommodations::ApplicationController < ApplicationController
  before_action :set_accommodation

  private

  def set_accommodation
    @accommodation = Accommodation.published.find(params.expect(:accommodation_id))
  end
end
