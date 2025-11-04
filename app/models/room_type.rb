class RoomType < ApplicationRecord
  belongs_to :accommodation
  has_many :room_availabilities, dependent: :destroy

  has_one_attached :main_image do |attachable|
    attachable.variant :display, resize_to_limit: ImageSettings::MAIN_IMAGE[:display_size]
  end

  validates :name, presence: true, uniqueness: { scope: :accommodation_id }
  validates :description, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validates :base_price, numericality: { only_integer: true, greater_than: 0 }
  validates :main_image, content_type: ImageSettings::MAIN_IMAGE[:content_type], size: { less_than: ImageSettings::MAIN_IMAGE[:max_size] }
end
