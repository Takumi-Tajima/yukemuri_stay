class Accommodation < ApplicationRecord
  ACCOMMODATION_TYPE = %w[hotel inn guest_house].freeze

  extend Enumerize

  enumerize :accommodation_type, in: ACCOMMODATION_TYPE
  enumerize :prefecture, in: Prefecture::ALL

  has_many :room_types, dependent: :destroy

  has_one_attached :main_image do |attachable|
    attachable.variant :thumbnail, resize_to_limit: ImageSettings::MAIN_IMAGE[:thumbnail_size]
    attachable.variant :display, resize_to_limit: ImageSettings::MAIN_IMAGE[:display_size]
  end

  validates :name, presence: true, uniqueness: { scope: :address }
  validates :prefecture, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d[\d-]{8,}\d\z/ }
  validates :accommodation_type, presence: true
  validates :description, presence: true
  validates :main_image, content_type: ImageSettings::MAIN_IMAGE[:content_type], size: { less_than: ImageSettings::MAIN_IMAGE[:max_size] }

  scope :default_order, -> { order(:id) }
  scope :published, -> { where(published: true) }

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[prefecture accommodation_type]
    end
  end
end
