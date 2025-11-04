class Administrator < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable, :trackable

  validates :name, presence: true
end
