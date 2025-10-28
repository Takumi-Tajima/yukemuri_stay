require 'rails_helper'

RSpec.describe '宿泊施設の機能', type: :system do
  let(:administrator) { create(:administrator) }

  before { sign_in administrator }

  describe '表示機能', :rack_test do
    before do
      create(:accommodation, name: 'ゆけむり温泉', prefecture: Prefecture::LIST[:tokyo], address: '東京都新宿区1-1-1', phone_number: '03-1234-5678',
                             accommodation_type: 'hotel', description: '素敵な温泉旅館です。', published: true)
    end

    it '宿泊施設のデータが表示されること' do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'
      expect(page).to have_link 'ゆけむり温泉'
      expect(page).to have_content '東京都'
      expect(page).to have_content 'ホテル'
      expect(page).to have_content '公開'

      click_on 'ゆけむり温泉'

      expect(page).to have_content '宿泊施設詳細'
      expect(page).to have_content 'ゆけむり温泉'
      expect(page).to have_content '東京都新宿区1-1-1'
      expect(page).to have_content '03-1234-5678'
      expect(page).to have_content '素敵な温泉旅館です。'
    end
  end

  describe '登録機能', :rack_test do
    it '新規登録ができること' do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'

      click_on '新規登録'

      expect(page).to have_content '宿泊施設新規登録'

      fill_in '施設名', with: 'ゆけむり温泉旅館'
      select '長野県', from: '都道府県'
      fill_in '住所', with: '長野県長野市1-2-3'
      fill_in '電話番号', with: '026-123-4567'
      select '旅館', from: '施設タイプ'
      fill_in '施設説明', with: '自然豊かな温泉旅館です。'
      check '公開する'

      expect {
        click_on '登録'
        expect(page).to have_content '作成しました'
      }.to change(Accommodation, :count).by(1)

      expect(page).to have_content '宿泊施設詳細'
      expect(page).to have_content 'ゆけむり温泉旅館'
      expect(page).to have_content '長野県長野市1-2-3'
      expect(page).to have_content '026-123-4567'
      expect(page).to have_content '自然豊かな温泉旅館です。'
    end
  end

  describe '削除機能' do
    before do
      create(:accommodation, name: 'さくら温泉', prefecture: Prefecture::LIST[:nagano], address: '長野県長野市1-2', phone_number: '026-987-6543',
                             accommodation_type: 'guest_house', description: '古い良いゲストハウスです。', published: true)
    end

    it '宿泊施設の削除ができること' do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'
      expect(page).to have_link 'さくら温泉'
      expect(page).to have_content '長野県'
      expect(page).to have_content 'ゲストハウス'
      expect(page).to have_content '公開'

      click_on 'さくら温泉'

      expect(page).to have_content '宿泊施設詳細'
      expect(page).to have_content 'さくら温泉'
      expect(page).to have_content '長野県長野市1-2'
      expect(page).to have_content '026-987-6543'
      expect(page).to have_content '古い良いゲストハウスです。'

      expect {
        accept_confirm do
          click_on '削除'
        end
        expect(page).to have_content '削除しました'
      }.to change(Accommodation, :count).by(-1)

      expect(page).to have_content '宿泊施設一覧'
      expect(page).not_to have_link 'さくら温泉'
    end
  end
end
