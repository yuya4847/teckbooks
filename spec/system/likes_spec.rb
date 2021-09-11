require 'rails_helper'
RSpec.describe "Likes", type: :system do
  describe 'Likeができる' do
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
      visit '/all_reviews'
      within(".like_class#{normal_review.id}") do
        expect(page).to have_selector 'form', class: "like_class"
      end
      within(".like_class#{normal_review.id}") do
        click_button 'Like'
      end
      sleep 0.5
      within(".like_class#{normal_review.id}") do
        expect(page).to have_selector 'form', class: "unlike_class"
      end
      within(".like_class#{normal_review.id}") do
        click_button 'Unlike'
      end
      sleep 0.5
      within(".like_class#{normal_review.id}") do
        expect(page).to have_selector 'form', class: "like_class"
      end
    end

    describe 'Likeがランキングに反映される' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:third_user) { create(:third_user) }
      let!(:good_review) { create(:good_review) }
      let!(:normal_review) { create(:normal_review) }
      let!(:bad_review) { create(:bad_review) }

      it '投稿一覧ページからのlikeとunlikeがランキングに反映されること(like機能とランキング機能にajax)', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        within(".like_class#{good_review.id}") do
          click_button 'Like'
        end
        sleep 0.5
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "いいね数:1"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit '/all_reviews'
        within(".like_class#{good_review.id}") do
          click_button 'Like'
        end
        within(".like_class#{normal_review.id}") do
          click_button 'Like'
        end
        sleep 0.5
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "いいね数:2"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
        within("#ranking_2") do
          expect(page).to have_selector 'span', text: "いいね数:1"
          expect(page).to have_selector 'span', text: "it is normal"
          expect(page).to have_selector 'span', text: "yuta"
        end
        click_link "ログアウト"
        log_in_as(third_user.email, third_user.password)
        visit '/all_reviews'
        within(".like_class#{good_review.id}") do
          click_button 'Like'
        end
        within(".like_class#{normal_review.id}") do
          click_button 'Like'
        end
        within(".like_class#{bad_review.id}") do
          click_button 'Like'
        end
        sleep 0.5
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "いいね数:3"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
        within("#ranking_2") do
          expect(page).to have_selector 'span', text: "いいね数:2"
          expect(page).to have_selector 'span', text: "it is normal"
          expect(page).to have_selector 'span', text: "yuta"
        end
        within("#ranking_3") do
          expect(page).to have_selector 'span', text: "いいね数:1"
          expect(page).to have_selector 'span', text: "it is bad"
          expect(page).to have_selector 'span', text: "yuki"
        end
        within(".like_class#{good_review.id}") do
          click_button 'Unlike'
        end
        within(".like_class#{normal_review.id}") do
          click_button 'Unlike'
        end
        within(".like_class#{bad_review.id}") do
          click_button 'Unlike'
        end
        sleep 0.5
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "いいね数:2"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
        within("#ranking_2") do
          expect(page).to have_selector 'span', text: "いいね数:1"
          expect(page).to have_selector 'span', text: "it is normal"
          expect(page).to have_selector 'span', text: "yuta"
        end
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit '/all_reviews'
        within(".like_class#{good_review.id}") do
          click_button 'Unlike'
        end
        within(".like_class#{normal_review.id}") do
          click_button 'Unlike'
        end
        sleep 0.5
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "いいね数:1"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
      end

      it '投稿詳細ページからのlikeとunlikeがランキングに反映されること', js: true do
        log_in_as(user.email, user.password)
        visit "/reviews/#{good_review.id}"
        click_button 'Like'
        visit '/all_reviews'
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "1"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit "/reviews/#{good_review.id}"
        click_button 'Like'
        visit "/reviews/#{normal_review.id}"
        click_button 'Like'
        visit '/all_reviews'
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "2"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
        within("#ranking_2") do
          expect(page).to have_selector 'span', text: "1"
          expect(page).to have_selector 'span', text: "it is normal"
          expect(page).to have_selector 'span', text: "yuta"
        end
        click_link "ログアウト"
        log_in_as(third_user.email, third_user.password)
        visit "/reviews/#{good_review.id}"
        click_button 'Like'
        visit "/reviews/#{normal_review.id}"
        click_button 'Like'
        visit "/reviews/#{bad_review.id}"
        click_button 'Like'
        click_link "全ての投稿"
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "3"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
        within("#ranking_2") do
          expect(page).to have_selector 'span', text: "2"
          expect(page).to have_selector 'span', text: "it is normal"
          expect(page).to have_selector 'span', text: "yuta"
        end
        within("#ranking_3") do
          expect(page).to have_selector 'span', text: "1"
          expect(page).to have_selector 'span', text: "it is bad"
          expect(page).to have_selector 'span', text: "yuki"
        end
        visit "/reviews/#{good_review.id}"
        click_button 'Unlike'
        visit "/reviews/#{normal_review.id}"
        click_button 'Unlike'
        visit "/reviews/#{bad_review.id}"
        click_button 'Unlike'
        visit '/all_reviews'
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "2"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
        within("#ranking_2") do
          expect(page).to have_selector 'span', text: "1"
          expect(page).to have_selector 'span', text: "it is normal"
          expect(page).to have_selector 'span', text: "yuta"
        end
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit "/reviews/#{good_review.id}"
        click_button 'Unlike'
        visit "/reviews/#{normal_review.id}"
        click_button 'Unlike'
        visit '/all_reviews'
        within("#ranking_1") do
          expect(page).to have_selector 'span', text: "1"
          expect(page).to have_selector 'span', text: "it is good"
          expect(page).to have_selector 'span', text: "yuya"
        end
      end
    end
  end
end
