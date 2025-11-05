require 'rails_helper'

RSpec.describe 'マイページ予約の機能', type: :system do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '表示機能' do
    let(:accommodation) { create(:accommodation, name: 'ゆけむり温泉', published: true) }
    let(:room_type) { create(:room_type, accommodation:, name: 'さくらの間', capacity: 10) }

    before do
      create(:room_availability, room_type:, date: '2025-12-15', remaining_rooms: 5)
      create(:reservation, user:, room_type:, check_in_date: '2025-12-15', nights: 1, adults: 2, children: 1, total_amount: 30000, status: 'confirmed')
    end

    it 'データが表示されること' do
      visit my_reservations_path

      expect(page).to have_content '予約一覧'
      expect(page).to have_content '2025/12/15'
      expect(page).to have_content 'ゆけむり温泉'
      expect(page).to have_content '1泊'
      expect(page).to have_content '30,000円'
      expect(page).to have_content '予約済み'

      click_on '2025/12/15'

      expect(page).to have_content '予約詳細'
      expect(page).to have_content 'ゆけむり温泉'
      expect(page).to have_content 'さくらの間'
      expect(page).to have_content '2025/12/15'
      expect(page).to have_content '1泊'
      expect(page).to have_content '2名'
      expect(page).to have_content '1名'
      expect(page).to have_content '30,000円'
      expect(page).to have_content '予約済み'
    end
  end
end
