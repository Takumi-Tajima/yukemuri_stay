require 'rails_helper'

RSpec.describe 'ユーザー管理', type: :system do
  let(:administrator) { create(:administrator) }

  before { sign_in administrator }

  describe '表示機能' do
    before { create(:user, name: '山田太郎', email: 'yamada@example.com') }

    it 'データが表示されること' do
      visit administrators_users_path

      expect(page).to have_content 'ユーザー一覧'
      expect(page).to have_content 'yamada@example.com'

      click_on '山田太郎'

      expect(page).to have_content 'ユーザー詳細'
      expect(page).to have_content '山田太郎'
      expect(page).to have_content 'yamada@example.com'
    end
  end

  describe '削除機能', :js do
    before { create(:user, name: '山田太郎', email: 'yamada@example.com') }

    it '削除できること' do
      visit administrators_users_path

      expect(page).to have_content 'ユーザー一覧'
      expect(page).to have_content 'yamada@example.com'

      click_on '山田太郎'

      expect(page).to have_content 'ユーザー詳細'
      expect(page).to have_content '山田太郎'
      expect(page).to have_content 'yamada@example.com'

      expect {
        accept_confirm do
          click_on '削除'
        end
        expect(page).to have_content '削除しました'
      }.to change(User, :count).by(-1)

      expect(page).to have_content 'ユーザー一覧'
      expect(page).not_to have_content 'yamada@example.com'
    end
  end
end
