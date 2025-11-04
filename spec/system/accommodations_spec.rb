require 'rails_helper'

RSpec.describe '宿泊施設の機能', type: :system do
  describe '表示機能' do
    before do
      create(:accommodation, name: 'ゆけむり温泉', prefecture: Prefecture::ALL['東京都'], address: '東京都新宿区1-1-1', phone_number: '03-1234-5678',
                             accommodation_type: 'hotel', description: '素敵な温泉旅館です。', published: true)
    end

    it '宿泊施設のデータが表示されること' do
      visit accommodations_path

      expect(page).to have_link 'ゆけむり温泉'
      expect(page).to have_content '東京都'
      expect(page).to have_content 'ホテル'

      click_on 'ゆけむり温泉'

      expect(page).to have_content 'ゆけむり温泉'
      expect(page).to have_content '東京都新宿区1-1-1'
      expect(page).to have_content '03-1234-5678'
      expect(page).to have_content '素敵な温泉旅館です。'
    end
  end

  describe '検索機能' do
    before do
      create(:accommodation, name: 'ゆけむり温泉', prefecture: Prefecture::ALL['東京都'], address: '東京都新宿区1-1-1', phone_number: '03-1234-5678',
                             accommodation_type: 'hotel', description: '素敵な温泉旅館です。', published: true)
      create(:accommodation, name: 'さくら旅館', prefecture: Prefecture::ALL['大阪府'], address: '大阪府大阪市2-2-2', phone_number: '06-8765-4321',
                             accommodation_type: 'inn', description: 'アットホームな旅館です。', published: true)
    end

    it '絞り込み検索ができること' do
      visit accommodations_path

      # どちらも指定しない場合、全て表示されること
      expect(page).to have_content 'ゆけむり温泉'
      expect(page).to have_content 'さくら旅館'

      # 都道府県だけで検索が有効なこと
      select '東京都', from: '都道府県'
      click_on '検索'

      expect(page).to have_current_path accommodations_path, ignore_query: true
      expect(page).to have_content 'ゆけむり温泉'
      expect(page).not_to have_content 'さくら旅館'

      # 施設タイプだけで検索が有効なこと
      select '選択なし', from: '都道府県'
      select '旅館', from: '施設タイプ'
      click_on '検索'

      expect(page).to have_current_path accommodations_path, ignore_query: true
      expect(page).to have_content 'さくら旅館'
      expect(page).not_to have_content 'ゆけむり温泉'

      # 都道府県、施設タイプ両方合わせての検索が有効なこと
      select '東京都', from: '都道府県'
      select 'ホテル', from: '施設タイプ'
      click_on '検索'

      expect(page).to have_current_path accommodations_path, ignore_query: true
      expect(page).to have_content 'ゆけむり温泉'
      expect(page).not_to have_content 'さくら旅館'
    end
  end
end
