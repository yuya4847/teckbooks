require 'rails_helper'
RSpec.describe "Reports", type: :system do
  describe 'フォローできること' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:unfollow_user) { create(:unfollow_user) }
    let!(:fifth_user) { create(:user, email: "aaaa@aa.aa") }

    let!(:good_review) { create(:good_review) }

    it '通報できること', js: true do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      expect(page).to have_no_content '通報済'
      find("#open_report_modal_#{good_review.id}").click
      expect(page).to have_selector("input[value$='通報']")
      click_on '通報'
      expect(page).to have_content '通報済'
    end

    it '5回通報されると削除されること', js: true do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      find("#open_report_modal_#{good_review.id}").click
      click_on '通報'
      click_on 'ログアウト'
      log_in_as(second_user.email, second_user.password)
      visit '/all_reviews'
      find("#open_report_modal_#{good_review.id}").click
      click_on '通報'
      click_on 'ログアウト'
      log_in_as(third_user.email, third_user.password)
      visit '/all_reviews'
      find("#open_report_modal_#{good_review.id}").click
      click_on '通報'
      click_on 'ログアウト'
      log_in_as(unfollow_user.email, unfollow_user.password)
      visit '/all_reviews'
      find("#open_report_modal_#{good_review.id}").click
      click_on '通報'
      expect(page).to have_content '通報済'
      click_on 'ログアウト'
      log_in_as(fifth_user.email, fifth_user.password)
      visit '/all_reviews'
      find("#open_report_modal_#{good_review.id}").click
      expect(page).to have_no_content '通報済'
      expect(page).to have_content "#{good_review.title}"
    end
  end
end
