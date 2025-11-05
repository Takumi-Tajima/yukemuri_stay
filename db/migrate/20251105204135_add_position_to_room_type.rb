class AddPositionToRoomType < ActiveRecord::Migration[8.0]
  def change
    add_column :room_types, :position, :integer
  end
end
