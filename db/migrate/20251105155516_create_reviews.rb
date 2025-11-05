class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :reservation, null: false, foreign_key: true, index: false
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment, null: false

      t.timestamps
      t.index %i[reservation_id user_id], unique: true
    end
  end
end
