class Reservation < ApplicationRecord
  MIN_CHECK_IN_DAYS_FROM_NOW = 1
  MAX_CHECK_IN_DAYS_FROM_NOW = 90
  MIN_NIGHTS = 1
  MAX_NIGHTS = 5
  RESERVATION_STATUSES = %w[confirmed checked_out cancelled].freeze

  extend Enumerize

  enumerize :status, in: RESERVATION_STATUSES

  attribute :status, :string, default: 'confirmed'

  belongs_to :user
  belongs_to :room_type

  validates :check_in_date, presence: true
  validates :nights, numericality: { only_integer: true, in: MIN_NIGHTS..MAX_NIGHTS }
  validates :adults, numericality: { only_integer: true, greater_than: 0 }
  validates :children, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_amount, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true
  validate :validate_check_in_date_range
  validate :validate_guest_count_within_capacity
  validate :validate_room_availability

  # TODO: もしかしてテーブル名を変えた方が良い説
  after_create :decrease_remaining_rooms!

  scope :default_order, -> { order(:check_in_date) }

  # TODO: リファクタ
  # エラーハンドリング方法について
  # エラーメッセージについて
  def calculate_total_amount
    calculate_total_amount!
    true
  rescue ArgumentError
    errors.add(:base, :calculation_failed)
    false
  end

  def calculate_total_amount!
    validate_calculation_dependencies!

    base_price = BigDecimal(room_type.base_price.to_s)
    night_count = BigDecimal(nights.to_s)
    adult_count = BigDecimal(adults.to_s)
    child_count = BigDecimal(children.to_s)

    adult_amount = base_price * night_count * adult_count
    child_amount = GuestRate.calculate_child_price(base_price) * night_count * child_count
    subtotal = adult_amount + child_amount

    self.total_amount = Tax.calculate_with_tax(subtotal).to_i
  end

  private

  # TODO: リファクタする
  def validate_calculation_dependencies!
    raise ArgumentError, 'room_type is required' if room_type.blank?
    raise ArgumentError, 'nights is required' if nights.blank?
    raise ArgumentError, 'adults is required' if adults.blank?
    raise ArgumentError, 'children is required' if children.blank?
  end

  def validate_check_in_date_range
    return if check_in_date.blank?

    min_date = Date.current + MIN_CHECK_IN_DAYS_FROM_NOW.days
    max_date = Date.current + MAX_CHECK_IN_DAYS_FROM_NOW.days

    unless check_in_date.between?(min_date, max_date)
      errors.add(:check_in_date, :validate_check_in_date_range)
    end
  end

  def validate_guest_count_within_capacity
    return if adults.blank? || children.blank? || room_type.blank?

    total_guests = adults + children

    if total_guests > room_type.capacity
      errors.add(:base, :validate_guest_count_within_capacity)
    end
  end

  # TODO: リファクタ
  def validate_room_availability
    return if check_in_date.blank? || nights.blank? || room_type.blank?

    stay_dates = (check_in_date...(check_in_date + nights.days)).to_a

    availabilities = room_type.room_availabilities
                              .where(date: stay_dates)
                              .index_by(&:date)

    stay_dates.each do |date|
      availability = availabilities[date]

      if availability.blank? || availability.remaining_rooms <= 0
        errors.add(:base, :validate_room_availability)
        break
      end
    end
  end

  # TODO: 確認
  def decrease_remaining_rooms!
    stay_dates = (check_in_date...(check_in_date + nights.days)).to_a

    stay_dates.each do |date|
      availability = room_type.room_availabilities.lock.find_by!(date: date)
      availability.decrement_remaining_rooms!
    end
  end
end
