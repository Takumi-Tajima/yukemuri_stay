class CreateAccommodations < ActiveRecord::Migration[8.0]
  def change
    create_table :accommodations do |t|
      t.string :name, null: false
      t.integer :prefecture, null: false
      t.string :address, null: false
      t.string :phone_number, null: false
      t.string :accommodation_type, null: false
      t.text :description, null: false
      t.boolean :published, null: false, default: false

      t.timestamps
      t.index %i[name address], unique: true
      t.index %i[published accommodation_type]
      t.index %i[published prefecture accommodation_type]
    end
  end
end
