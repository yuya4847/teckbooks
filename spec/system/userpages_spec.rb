require 'rails_helper'
RSpec.describe "Userpages", type: :system do
  describe '#show' do
    let!(:user) { create(:user) }
    let!(:good_review) { build(:good_review) }
    let!(:great_review) { build(:great_review) }

    it '全ての投稿したレビューが表示されること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/reviews/new'
      attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
      fill_in 'review_title', with: good_review.title
      fill_in 'review_link', with: good_review.link
      fill_in 'review_rate', with: good_review.rate
      fill_in 'review_content', with: good_review.content
      click_button 'レビューを投稿する'
      expect(current_path).to eq userpage_path(user)
      within('.notice') do
        expect(page).to have_content 'レビューを投稿しました'
      end
      visit '/reviews/new'
      attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
      fill_in 'review_title', with: great_review.title
      fill_in 'review_link', with: great_review.link
      fill_in 'review_rate', with: great_review.rate
      fill_in 'review_content', with: great_review.content
      click_button 'レビューを投稿する'
      expect(current_path).to eq userpage_path(user)
      within('.notice') do
        expect(page).to have_content 'レビューを投稿しました'
      end
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
      expect(page).to have_link good_review.title
      expect(page).to have_content good_review.content
      expect(page).to have_content good_review.rate
      expect(page).to have_content "1分前"
      expect(page).to have_link good_review.link
      expect(page).to have_xpath "//a[@href='/reviews/1/exist']"
      visit '/all_reviews'
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
      expect(page).to have_content great_review.title
      expect(page).to have_content great_review.content
      expect(page).to have_content great_review.rate
      expect(page).to have_content "1分前"
      expect(page).to have_link great_review.link
      expect(page).to have_xpath "//a[@href='/reviews/2/exist']"
    end
  end

  describe 'アバター画像の変更及び削除' do
    let(:user) { create(:user) }

    it 'パスワード変更画面の要素検証すること' do
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'ログイン'
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      expect(current_path).to eq userpage_path(user)
      have_link "アバターを変更する"
      have_link "プロフィール変更"
      expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
      click_link "アバターを変更する"
      attach_file('user[avatar]', "#{Rails.root}/spec/factories/images/test_avatar.jpg")
      click_button '編集完了'
      expect(page).to have_content 'アカウント情報を変更しました。'
      expect(current_path).to eq userpage_path(user)
      have_no_link "アバターを変更する"
      have_link "delete"
      expect(page).not_to have_selector("img[src$='/uploads/user/avatar/default.png']")
      expect(page).to have_selector("img[src$='/uploads_test/user/avatar/1/test_avatar.jpg']")
      click_link "delete"
      expect(page).to have_content 'アバターを取り消しました'
      have_link "アバターを変更する"
      expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
      expect(page).not_to have_selector("img[src$='/uploads_test/user/avatar/1/test_avatar.jpg']")
    end
  end
end
