class Accommodations::RoomTypesController < Accommodations::ApplicationController
  def show
    @room_type = @accommodation.room_types.find(params.expect(:id))
  end
end
