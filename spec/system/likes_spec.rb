require 'rails_helper'
RSpec.describe "Likes", type: :system do
  describe 'Likeできること' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:good_review) { create(:good_review) }
    let!(:normal_review) { create(:normal_review) }

    it '投稿詳細ページからlikeとunlikeがAjaxでできること', js: true do
      log_in_as(user.email, user.password)
      visit '/reviews/1'
      expect(page).to have_selector 'form', class: 'like_class'
      click_button 'Like'
      expect(page).to have_selector 'form', class: 'unlike_class'
      click_button 'Unlike'
      expect(page).to have_selector 'form', class: 'like_class'
    end

    it '投稿一覧ページからlikeとunlikeがAjaxでできること', js: true do
      log_in_as(user.email, user.password)
      visit '/reviews'
      within(".like_class#{normal_review.id}") do
        expect(page).to have_selector 'form', class: "like_class"
      end
      within(".like_class#{normal_review.id}") do
        click_button 'Like'
      end
      within(".like_class#{normal_review.id}") do
        expect(page).to have_selector 'form', class: "unlike_class"
      end
      within(".like_class#{normal_review.id}") do
        click_button 'Unlike'
      end
      within(".like_class#{normal_review.id}") do
        expect(page).to have_selector 'form', class: "like_class"
      end
    end
  end
end
