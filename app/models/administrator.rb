class Administrator < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable, :trackable
end
