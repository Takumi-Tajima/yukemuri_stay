class Administrator < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable, :trackable

  validates :name, presence: true
end
