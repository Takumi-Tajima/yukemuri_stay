class Review < ApplicationRecord
  MIN_RATING = 1
  MAX_RATING = 5
  RATING_RANGE = MIN_RATING..MAX_RATING

  belongs_to :reservation
  belongs_to :user

  validates :reservation_id, uniqueness: { scope: :user_id }
  validates :rating, inclusion: { in: RATING_RANGE }
  validates :comment, presence: true
  validate :validate_reservation_is_checked_out

  private

  def validate_reservation_is_checked_out
    return if reservation.blank?

    unless reservation.checked_out?
      errors.add(:base, :validate_reservation_is_checked_out)
    end
  end
end
