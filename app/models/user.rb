class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable, :confirmable

  has_many :reservations, dependent: :destroy
  has_many :reviews, dependent: :destroy

  scope :default_order, -> { order(:id) }

  validates :name, presence: true
end
