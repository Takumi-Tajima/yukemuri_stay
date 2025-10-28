# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_28_011657) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accommodations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "prefecture", null: false
    t.string "address", null: false
    t.string "phone_number", null: false
    t.string "accommodation_type", null: false
    t.text "description", null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "address"], name: "index_accommodations_on_name_and_address", unique: true
    t.index ["published", "accommodation_type"], name: "index_accommodations_on_published_and_accommodation_type"
    t.index ["published", "prefecture", "accommodation_type"], name: "idx_on_published_prefecture_accommodation_type_13cd666756"
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "encrypted_password", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_administrators_on_email", unique: true
  end
end
