require 'rails_helper'
RSpec.describe "それぞれのユーザーの権限に応じた処理を行う", type: :system do
  describe '編集ページに対するアクセス制御を検証する' do
    let!(:admin_user) { create(:user, id: 1) }
    let!(:sample_user) { create(:second_user, id: 2) }
    let!(:general_user) { create(:third_user, id: 3) }
    let!(:top_page_sample_review) { create(:good_review, id: 1) }
    let!(:will_deleted_review) { create(:great_review, id: 2) }

    it 'adminユーザーでアクセスできること' do
      log_in_as(admin_user.email, admin_user.password)
      visit '/users/edit'
      expect(current_path).to eq edit_user_registration_path
    end

    it 'sampleユーザーではアクセスできないこと' do
      log_in_as(sample_user.email, sample_user.password)
      visit '/users/edit'
      expect(current_path).not_to eq edit_user_registration_path
      expect(current_path).to eq userpage_path(sample_user)
      within('.notice') do
        expect(page).to have_content 'このユーザーを編集することはできません。'
      end
    end

    it 'generalユーザーでアクセスできること' do
      log_in_as(general_user.email, general_user.password)
      visit '/users/edit'
      expect(current_path).to eq edit_user_registration_path
    end
  end

  describe 'レビューの削除に値するリクエストを検証する' do
    let!(:admin_user) { create(:user, id: 1) }
    let!(:sample_user) { create(:second_user, id: 2) }
    let!(:general_user) { create(:third_user, id: 3) }
    let!(:top_page_sample_first_review) { create(:good_review, id: 1) }
    let!(:top_page_sample_second__review) { create(:good_review, id: 2) }
    let!(:top_page_sample_third_review) { create(:good_review, id: 3) }
    let!(:admin_review) { create(:good_review, user_id: admin_user.id, id: 4) }
    let!(:sample_review) { create(:good_review, user_id: sample_user.id, id: 5) }
    let!(:general_review) { create(:good_review, user_id: general_user.id, id: 6) }

    describe 'adminユーザーでログインしている時' do
      it '自身の投稿を削除できること' do
        log_in_as(admin_user.email, admin_user.password)
        visit "/reviews/#{admin_review.id}"
        within('.show-review-related-links') do
          click_link "削除"
        end
        expect(current_path).to eq userpage_path(admin_user)
        within('.notice') do
          expect(page).to have_content '投稿を削除しました'
        end
      end

      it '他者の投稿を削除できること' do
        log_in_as(admin_user.email, admin_user.password)
        visit "/reviews/#{general_review.id}"
        within('.show-review-related-links') do
          click_link "削除"
        end
        expect(current_path).to eq userpage_path(admin_user)
        within('.notice') do
          expect(page).to have_content '投稿を削除しました'
        end
      end
    end

    describe 'sampleユーザーでログインしている時' do
      it '自身の投稿を削除できること' do
        log_in_as(sample_user.email, sample_user.password)
        visit "/reviews/#{sample_review.id}"
        within('.show-review-related-links') do
          click_link "削除"
        end
        expect(current_path).to eq userpage_path(sample_user)
        within('.notice') do
          expect(page).to have_content '投稿を削除しました'
        end
      end

      it '他者の投稿は削除できないこと' do
        log_in_as(sample_user.email, sample_user.password)
        visit "/reviews/#{general_review.id}"
        within('.show-review-related-links') do
          expect(page).not_to have_selector 'a', text: '削除'
        end
      end
    end

    describe 'generalユーザーでログインしている時' do
      it '自身の投稿を削除できること' do
        log_in_as(general_user.email, general_user.password)
        visit "/reviews/#{general_review.id}"
        within('.show-review-related-links') do
          click_link "削除"
        end
        expect(current_path).to eq userpage_path(general_user)
        within('.notice') do
          expect(page).to have_content '投稿を削除しました'
        end
      end

      it '他者の投稿は削除できないこと' do
        log_in_as(general_user.email, general_user.password)
        visit "/reviews/#{sample_review.id}"
        within('.show-review-related-links') do
          expect(page).not_to have_selector 'a', text: '削除'
        end
      end
    end
  end
end
