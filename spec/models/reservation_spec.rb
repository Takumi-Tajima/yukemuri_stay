require 'rails_helper'

RSpec.describe Reservation, type: :model do
  # TODO: 計算リファクタ後に修正して有効化する
  # describe '予約時の金額計算' do
  #   let(:user) { create(:user) }
  #   let(:accommodation) { create(:accommodation) }
  #   let(:room_type) { create(:room_type, accommodation:, base_price: 10000) }
  #
  #   context '大人だけの時' do
  #     let(:reservation) { create(:reservation, room_type:, user:, nights: 2, adults: 2, children: 0) }
  #
  #     # 10000 × 2泊 × 2人 = 40000
  #     # 40000 × 1.10(税込) = 44000
  #     it '基本料金 × 泊数 × 大人数 × 税率で計算されること' do
  #       expect(reservation.total_amount).to eq(44000)
  #     end
  #   end
  #
  #   context '大人と子どもの時' do
  #     let(:reservation) { create(:reservation, room_type:, user:, nights: 2, adults: 2, children: 3) }
  #
  #     # 大人: 10000 × 2泊 × 2人 = 40000
  #     # 子供: 7000 × 2泊 × 3人 = 42000
  #     # 小計: 82000
  #     # 税込: (82000 × 1.10).floor = 90200
  #     it '大人料金と子供料金を合算して税込み計算されること' do
  #       expect(reservation.total_amount).to eq(90200)
  #     end
  #   end
  #
  #   context '子供料金が端数になるパターンの時' do
  #     let(:room_type) { create(:room_type, accommodation:, base_price: 10003) }
  #     let(:reservation) { create(:reservation, room_type:, user:, nights: 1, adults: 1, children: 1) }
  #
  #     # 大人: 10003 × 1泊 × 1人 = 10003
  #     # 子供: (10003 × 0.7).floor = 7002.1 → 7002
  #     # 小計: 10003 + 7002 = 17005
  #     # 税込: (17005 × 1.10).floor = 18705.5 → 18705
  #     it '子供料金計算時に端数が切り捨てられること' do
  #       expect(reservation.total_amount).to eq(18705)
  #     end
  #   end
  # end

  # TODO: check_in_date = Date.current + 1.dayって共通化できない？
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:accommodation) { create(:accommodation) }
    let(:room_type) { create(:room_type, accommodation:, capacity: 2) }

    describe '宿泊日は翌日以降~90日後までの間であること' do
      it '翌日のチェックイン日で予約が成功すること' do
        check_in_date = Date.current + 1.day
        create(:room_availability, room_type:, date: check_in_date, remaining_rooms: 1)

        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 1, children: 0)
        expect(reservation).to be_valid
      end

      it '今日のチェックイン日で予約が失敗すること' do
        check_in_date = Date.current
        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 1, children: 0)

        expect(reservation).not_to be_valid
        expect(reservation.errors).to be_of_kind(:check_in_date, :validate_check_in_date_range)
      end

      it '91日後のチェックイン日で予約が失敗すること' do
        check_in_date = Date.current + 91.days
        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 1, children: 0)

        expect(reservation).not_to be_valid
        expect(reservation.errors).to be_of_kind(:check_in_date, :validate_check_in_date_range)
      end
    end

    describe '泊数は1~5泊までであること' do
      it '3泊で予約が成功すること' do
        check_in_date = Date.current + 1.day
        3.times do |i|
          create(:room_availability, room_type:, date: check_in_date + i.days, remaining_rooms: 1)
        end

        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 3, adults: 1, children: 0)
        expect(reservation).to be_valid
      end

      it '0泊で予約が失敗すること' do
        check_in_date = Date.current + 1.day
        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 0, adults: 1, children: 0)

        expect(reservation).not_to be_valid
        expect(reservation.errors).to be_of_kind(:nights, :in)
      end

      it '6泊で予約が失敗すること' do
        check_in_date = Date.current + 1.day
        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 6, adults: 1, children: 0)

        expect(reservation).not_to be_valid
        expect(reservation.errors).to be_of_kind(:nights, :in)
      end
    end

    describe '部屋の定員数を超える人数は予約できないこと' do
      it '大人2人、子供0人で定員2人の部屋を予約が成功すること(定員ぴったり)' do
        check_in_date = Date.current + 1.day
        create(:room_availability, room_type:, date: check_in_date, remaining_rooms: 1)

        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 2, children: 0)
        expect(reservation).to be_valid
      end

      it '大人2人、子供1人で定員2人の部屋を予約が失敗すること(定員オーバー)' do
        check_in_date = Date.current + 1.day
        create(:room_availability, room_type:, date: check_in_date, remaining_rooms: 1)

        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 2, children: 1)

        expect(reservation).not_to be_valid
        expect(reservation.errors).to be_of_kind(:base, :validate_guest_count_within_capacity)
      end
    end

    describe '空いている部屋がない場合は予約できないこと' do
      it '1泊で全日程に空室(remaining_rooms=1以上)がある場合、予約が成功すること' do
        check_in_date = Date.current + 1.day
        create(:room_availability, room_type:, date: check_in_date, remaining_rooms: 1)

        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 1, children: 0)
        expect(reservation).to be_valid
      end

      it '1泊でroom_availabilityレコードが存在しない場合、予約が失敗すること' do
        check_in_date = Date.current + 1.day
        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 1, children: 0)

        expect(reservation).not_to be_valid
        expect(reservation.errors).to be_of_kind(:base, :validate_room_availability)
      end

      it '1泊でremaining_rooms=0の場合、予約が失敗すること' do
        check_in_date = Date.current + 1.day
        create(:room_availability, room_type:, date: check_in_date, remaining_rooms: 0)

        reservation = build(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 1, children: 0)

        expect(reservation).not_to be_valid
        expect(reservation.errors).to be_of_kind(:base, :validate_room_availability)
      end
    end
  end

  describe '空き部屋の管理' do
    let(:user) { create(:user) }
    let(:accommodation) { create(:accommodation) }
    let(:room_type) { create(:room_type, accommodation:, capacity: 2) }

    describe '予約作成時に空き部屋数が減ること' do
      it '1泊の予約で、その日の空き部屋数が1減ること' do
        check_in_date = Date.current + 1.day
        availability = create(:room_availability, room_type:, date: check_in_date, remaining_rooms: 5)

        expect {
          create(:reservation, user:, room_type:, check_in_date:, nights: 1, adults: 1, children: 0)
        }.to change { availability.reload.remaining_rooms }.from(5).to(4)
      end

      it '3泊の予約で、各日の空き部屋数が1減ること' do
        check_in_date = Date.current + 1.day
        availability_day1 = create(:room_availability, room_type:, date: check_in_date, remaining_rooms: 5)
        availability_day2 = create(:room_availability, room_type:, date: check_in_date + 1.day, remaining_rooms: 5)
        availability_day3 = create(:room_availability, room_type:, date: check_in_date + 2.days, remaining_rooms: 5)

        create(:reservation, user:, room_type:, check_in_date:, nights: 3, adults: 1, children: 0)

        expect(availability_day1.reload.remaining_rooms).to eq(4)
        expect(availability_day2.reload.remaining_rooms).to eq(4)
        expect(availability_day3.reload.remaining_rooms).to eq(4)
      end

      it 'チェックアウト日の空き部屋数は減らないこと' do
        check_in_date = Date.current + 1.day
        check_out_date = check_in_date + 2.days

        create(:room_availability, room_type:, date: check_in_date, remaining_rooms: 5)
        create(:room_availability, room_type:, date: check_in_date + 1.day, remaining_rooms: 5)
        availability_checkout_day = create(:room_availability, room_type:, date: check_out_date, remaining_rooms: 5)

        create(:reservation, user:, room_type:, check_in_date:, nights: 2, adults: 1, children: 0)

        expect(availability_checkout_day.reload.remaining_rooms).to eq(5)
      end
    end
  end
end
