require 'rails_helper'

RSpec.describe '部屋タイプの機能', type: :system do
  let(:administrator) { create(:administrator) }

  before { sign_in administrator }

  describe '表示機能' do
    let(:accommodation) { create(:accommodation, name: 'ゆけむり温泉') }

    before do
      create(:room_type, accommodation:, name: 'さくらの間', capacity: 10,
                         base_price: 4500, description: 'さくらの間です。洗面台が2つあります。浴室はユニットバスです。')
    end

    it 'データが表示されること' do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'

      click_on 'ゆけむり温泉'

      expect(page).to have_content '宿泊施設詳細'
      expect(page).to have_content '客室タイプ一覧'
      expect(page).to have_content 'さくらの間'
      expect(page).to have_content '10名'
      expect(page).to have_content '4,500円'

      click_on 'さくらの間'

      expect(page).to have_content '客室タイプ詳細'
      expect(page).to have_content 'さくらの間'
      expect(page).to have_content '10名'
      expect(page).to have_content '4,500円'
      expect(page).to have_content 'さくらの間です。洗面台が2つあります。浴室はユニットバスです。'
    end
  end

  describe '登録機能' do
    let!(:accommodation) { create(:accommodation, name: 'さくらビジネスホテル', published: true) }

    it '新規登録ができること' do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'

      click_on 'さくらビジネスホテル'

      expect(page).to have_content '宿泊施設詳細'
      expect(page).to have_content '客室タイプ一覧'
      expect(page).to have_content 'さくらビジネスホテル'

      click_on '客室タイプを追加'

      expect(page).to have_content '客室タイプ新規登録'

      fill_in '部屋タイプ名', with: 'スタンダードツイン'
      fill_in '部屋説明', with: 'ツインベッドを備えたスタンダードルームです。'
      fill_in '定員', with: '2'
      fill_in '基本料金（税抜）', with: '8000'

      expect {
        click_on '登録'
        expect(page).to have_content '作成しました'
      }.to change(accommodation.room_types, :count).by(1)

      expect(page).to have_content '客室タイプ詳細'
      expect(page).to have_content 'スタンダードツイン'
      expect(page).to have_content 'ツインベッドを備えたスタンダードルームです。'
      expect(page).to have_content '2名'
      expect(page).to have_content '8,000円'
    end
  end

  describe '削除機能' do
    let(:accommodation) { create(:accommodation, name: 'もみじ旅館') }
    let!(:room_type) { create(:room_type, accommodation:, name: 'もみじの間', capacity: 10) }

    it '削除ができること', :js do
      visit administrators_accommodations_path

      expect(page).to have_content '宿泊施設一覧'

      click_on 'もみじ旅館'

      expect(page).to have_content '宿泊施設詳細'
      expect(page).to have_content '客室タイプ一覧'

      click_on 'もみじの間'

      expect(page).to have_content '客室タイプ詳細'
      expect(page).to have_content 'もみじの間'

      expect {
        accept_confirm do
          click_on '削除'
        end
        expect(page).to have_content '削除しました'
      }.to change(accommodation.room_types, :count).by(-1)

      expect(page).to have_content '宿泊施設詳細'
      expect(page).to have_content '客室タイプ一覧'
      expect(page).not_to have_content 'もみじの間'
    end

    context '予約が存在する場合' do
      let(:user) { create(:user) }

      before do
        create(:room_availability, room_type:, date: '2025-12-25', remaining_rooms: 5)
        create(:reservation, room_type:, user:, check_in_date: '2025-12-25', nights: 1, adults: 1, children: 1)
      end

      it '削除できないこと', :js do
        visit administrators_accommodations_path

        expect(page).to have_content '宿泊施設一覧'

        click_on 'もみじ旅館'

        expect(page).to have_content '宿泊施設詳細'
        expect(page).to have_content '客室タイプ一覧'

        click_on 'もみじの間'

        expect(page).to have_content '客室タイプ詳細'
        expect(page).to have_content 'もみじの間'

        expect {
          accept_confirm do
            click_on '削除'
          end
          expect(page).to have_content '予約されている部屋タイプがあるため削除できません'
        }.not_to change(accommodation.room_types, :count)

        expect(page).to have_content '宿泊施設詳細'
        expect(page).to have_content 'もみじの間'
      end
    end
  end
end
