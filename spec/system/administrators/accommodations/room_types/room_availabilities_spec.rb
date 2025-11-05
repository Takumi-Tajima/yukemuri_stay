require 'rails_helper'

RSpec.describe '空き部屋の機能', type: :system do
  let(:administrator) { create(:administrator) }

  before { sign_in administrator }

  describe '表示機能' do
    let(:accommodation) { create(:accommodation, name: 'ゆけむり温泉', published: true) }
    let(:room_type) { create(:room_type, accommodation:, name: 'さくらの間') }

    before do
      create(:room_availability, room_type:, date: '2025-12-01', remaining_rooms: 5)
      create(:room_availability, room_type:, date: '2025-12-02', remaining_rooms: 3)
    end

    it 'データが表示されること' do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'

      click_on 'ゆけむり温泉'

      expect(page).to have_content '宿泊施設詳細'

      click_on 'さくらの間'

      expect(page).to have_content '客室タイプ詳細'
      expect(page).to have_content '空いている部屋の一覧'
      expect(page).to have_content '2025-12-01'
      expect(page).to have_content '5室'
      expect(page).to have_content '2025-12-02'
      expect(page).to have_content '3室'
    end
  end

  describe '登録機能' do
    let(:accommodation) { create(:accommodation, name: 'さくらビジネスホテル', published: true) }
    let!(:room_type) { create(:room_type, accommodation:, name: 'スタンダードツイン') }

    it '新規登録ができること' do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'

      click_on 'さくらビジネスホテル'

      expect(page).to have_content '宿泊施設詳細'

      click_on 'スタンダードツイン'

      expect(page).to have_content '客室タイプ詳細'
      expect(page).to have_content '空いている部屋の一覧'

      click_on '空いている部屋を追加'

      expect(page).to have_content '空室情報新規登録'

      fill_in '日付', with: '2025-12-15'
      fill_in '空き部屋数', with: '10'

      expect {
        click_on '登録'
        expect(page).to have_content '作成しました'
      }.to change(room_type.room_availabilities, :count).by(1)

      expect(page).to have_content '客室タイプ詳細'
      expect(page).to have_content '2025-12-15'
      expect(page).to have_content '10室'
    end
  end

  describe '編集機能' do
    let(:accommodation) { create(:accommodation, name: 'もみじ旅館', published: true) }
    let(:room_type) { create(:room_type, accommodation:, name: 'もみじの間') }

    before do
      create(:room_availability, room_type:, date: '2025-12-20', remaining_rooms: 8)
    end

    it '編集ができること' do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'

      click_on 'もみじ旅館'

      expect(page).to have_content '宿泊施設詳細'
      expect(page).to have_content 'もみじ旅館'

      click_on 'もみじの間'

      expect(page).to have_content '客室タイプ詳細'
      expect(page).to have_content '空いている部屋の一覧'
      expect(page).to have_content '2025-12-20'
      expect(page).to have_content '8室'

      within 'table' do
        click_on '編集'
      end

      expect(page).to have_content '2025/12/20 空室情報編集'

      fill_in '空き部屋数', with: '15'

      expect {
        click_on '更新'
        expect(page).to have_content '更新しました'
      }.not_to change(room_type.room_availabilities, :count)

      expect(page).to have_content '客室タイプ詳細'
      expect(page).to have_content '15室'
      expect(page).not_to have_content '8室'
    end
  end
end
