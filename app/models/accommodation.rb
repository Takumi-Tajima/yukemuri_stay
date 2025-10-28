class Accommodation < ApplicationRecord
  ACCOMMODATION_TYPE = %w[hotel inn guest_house].freeze
  IMAGE_SETTINGS = {
    content_type: %i[png jpg jpeg],
    max_size: 5.megabytes,
    thumbnail_size: [300, 300],
    display_size: [600, 600],
  }.freeze

  extend Enumerize

  enumerize :accommodation_type, in: ACCOMMODATION_TYPE, scope: true
  enumerize :prefecture, in: Prefecture::LIST

  has_one_attached :image do |attachable|
    attachable.variant :thumbnail, resize_to_limit: IMAGE_SETTINGS[:thumbnail_size]
    attachable.variant :display, resize_to_limit: IMAGE_SETTINGS[:display_size]
  end

  validates :name, presence: true, uniqueness: { scope: :address }
  validates :prefecture, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d[\d-]{8,}\d\z/ }
  validates :accommodation_type, presence: true
  validates :description, presence: true
  validates :image, content_type: IMAGE_SETTINGS[:content_type], size: { less_than: IMAGE_SETTINGS[:max_size] }

  scope :default_order, -> { order(:id) }
end
