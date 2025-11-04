class CreateRoomTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :room_types do |t|
      t.references :accommodation, null: false, foreign_key: true, index: false
      t.string :name, null: false
      t.integer :capacity, null: false
      t.integer :base_price, null: false
      t.text :description, null: false

      t.timestamps
      t.index %i[accommodation_id name], unique: true
    end
  end
end
