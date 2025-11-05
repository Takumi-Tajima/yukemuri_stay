class Reservation < ApplicationRecord
  MIN_CHECK_IN_DAYS_FROM_NOW = 1
  MAX_CHECK_IN_DAYS_FROM_NOW = 90
  RESERVATION_STATUSES = %w[confirmed checked_out cancelled].freeze

  extend Enumerize

  enumerize :status, in: RESERVATION_STATUSES

  attribute :status, :string, default: 'confirmed'

  belongs_to :user
  belongs_to :room_type

  validates :check_in_date, presence: true
  validates :nights, numericality: { only_integer: true, greater_than: 0 }
  validates :adults, numericality: { only_integer: true, greater_than: 0 }
  validates :children, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # TODO: after_validationのためバリデーションをコメントアウトしている。21行目の問題が解決次第修正をすること。
  # validates :total_amount, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true
  validate :validate_check_in_date_range

  # TODO: バリデーションエラー時にも計算処理が走ってしまうので改善をするか、理由を考えること
  # コントローラから直呼びにする方法→呼び忘れ時にvalidates :total_amountで気づけるので問題ないが、正直冗長だよね
  # 別のコールバックを利用する方法→before_saveにするとif文でroom_typeやnightsが存在するかを検証しないといけなくなる。
  after_validation :set_and_calculate_total_amount

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

  def validate_calculation_dependencies!
    raise ArgumentError, 'room_type is required' if room_type.blank?
    raise ArgumentError, 'nights is required' if nights.blank?
    raise ArgumentError, 'adults is required' if adults.blank?
    raise ArgumentError, 'children is required' if children.blank?
  end
end
