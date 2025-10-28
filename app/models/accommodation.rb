class Accommodation < ApplicationRecord
  ACCOMMODATION_TYPE = %w[hotel inn guest_house].freeze

  extend Enumerize

  enumerize :accommodation_type, in: ACCOMMODATION_TYPE, scope: true
  enumerize :prefecture, in: Prefecture::LIST

  validates :name, presence: true, uniqueness: { scope: :address }
  validates :prefecture, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d[\d-]{8,}\d\z/ }
  validates :accommodation_type, presence: true
  validates :description, presence: true

  scope :default_order, -> { order(:id) }
end
