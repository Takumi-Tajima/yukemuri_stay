require 'rails_helper'

RSpec.describe '部屋タイプの機能', type: :system do
  describe '表示機能' do
    let(:accommodation) { create(:accommodation, name: 'ゆけむり温泉', published: true) }

    before do
      create(:room_type, accommodation:, name: 'さくらの間', capacity: 10,
                         base_price: 4500, description: 'さくらの間です。洗面台が2つあります。浴室はユニットバスです。')
    end

    it 'データが表示されること' do
      visit accommodations_path

      click_on 'ゆけむり温泉'

      expect(page).to have_content 'ゆけむり温泉'
      expect(page).to have_content '部屋タイプ一覧'
      expect(page).to have_link 'さくらの間'
      expect(page).to have_content '10名'
      expect(page).to have_content '4,500円'

      click_on 'さくらの間'

      expect(page).to have_content 'さくらの間'
      expect(page).to have_content '10名'
      expect(page).to have_content '4,500円'
      expect(page).to have_content 'さくらの間です。洗面台が2つあります。浴室はユニットバスです。'
    end
  end
end
