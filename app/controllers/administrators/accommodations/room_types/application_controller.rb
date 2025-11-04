class Administrators::Accommodations::RoomTypes::ApplicationController < Administrators::Accommodations::ApplicationController
  before_action :set_room_type

  private

  def set_room_type
    @room_type = @accommodation.room_types.find(params.expect(:room_type_id))
  end
end
