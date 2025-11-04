class Administrators::Accommodations::ApplicationController < Administrators::ApplicationController
  before_action :set_accommodation

  private

  def set_accommodation
    @accommodation = Accommodation.find(params.expect(:accommodation_id))
  end
end
