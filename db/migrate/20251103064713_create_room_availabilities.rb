class CreateRoomAvailabilities < ActiveRecord::Migration[8.0]
  def change
    create_table :room_availabilities do |t|
      t.references :room_type, null: false, foreign_key: true, index: false
      t.date :date, null: false
      t.integer :remaining_rooms, null: false

      t.timestamps
      t.index %i[room_type_id date], unique: true
    end
  end
end
