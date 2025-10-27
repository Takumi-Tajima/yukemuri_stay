# frozen_string_literal: true

class DeviseCreateAdministrators < ActiveRecord::Migration[8.0]
  def change
    create_table :administrators do |t|
      ## Database authenticatable
      t.string :email, null: false
      t.string :name, null: false
      t.string :encrypted_password, null: false

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :administrators, :email, unique: true
  end
end
