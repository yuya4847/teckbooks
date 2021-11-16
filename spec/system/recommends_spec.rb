require 'rails_helper'
RSpec.describe "Recommends", type: :system do
  describe 'Recommendができる' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:good_review) { create(:good_review) }
    let!(:second_recommend) { build(:recommend, recommend_user_id: user.id, recommended_user_id: second_user.id, review_id: good_review.id) }
    let!(:third_recommend) { build(:recommend, recommend_user_id: user.id, recommended_user_id: third_user.id, review_id: good_review.id) }

    it 'リコメンドモーダル画面の要素検証すること', js: true do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      within("#review_#{good_review.id}") do
        find('.open_modal').click()
      end
      within("#review_#{good_review.id}") do
        within('.recommend_modal_body') do
          expect(page).to have_selector 'div', class: "recommend_user_#{second_user.id}"
          expect(page).to have_selector 'div', class: "recommend_user_#{third_user.id}"
          expect(page).to have_selector 'div', text: 'キャンセル'
          expect(page).to have_selector 'div', text: 'リコメンド'
        end
      end
    end

    it 'リコメンドできること', js: true do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      within("#review_#{good_review.id}") do
        find('.open_modal').click()
      end
      within("#review_#{good_review.id}") do
        within('.recommend_modal_body') do
          find(".recommend_user_#{third_user.id}").click()
        end
      end
      find(".recommend_send").click()
      find(".swal2-confirm").click()
      click_link "ログアウト"
      log_in_as(second_user.email, second_user.password)
      visit '/all_reviews'
      within("#review_#{good_review.id}") do
        find('.open_modal').click()
      end
      within("#review_#{good_review.id}") do
        within('.recommend_modal_body') do
          find(".recommend_user_#{third_user.id}").click()
        end
      end
      find(".recommend_send").click()
      find(".swal2-confirm").click()
      click_link "ログアウト"
      log_in_as(third_user.email, third_user.password)
      visit '/all_reviews'
      within("#recommend_messages_#{good_review.id}") do
        expect(page).to have_selector 'div', text: "この投稿は、#{user.username}におすすめされています"
        expect(page).to have_selector 'div', text: "この投稿は、#{second_user.username}におすすめされています"
      end
    end

    it 'リコメンドが反映されること', js: true do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      within("#review_#{good_review.id}") do
        find('.open_modal').click()
      end
      within("#review_#{good_review.id}") do
        within('.recommend_modal_body') do
          find(".recommend_user_#{second_user.id}").click()
          find(".recommend_user_#{third_user.id}").click()
          expect(page).to have_selector "div", class: 'select_user', count: 2
          find('.recommend_cancel').click()
          expect(page).to have_selector "div", class: 'select_user', count: 0
        end
      end
    end

    it 'リコメンドを削除できること', js: true do
      second_recommend.save
      third_recommend.save
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      within("#review_#{good_review.id}") do
        find('.open_modal').click()
      end
      within("#review_#{good_review.id}") do
        within('.recommend_modal_body') do
          expect(page).to have_selector "div", class: 'select_user', count: 2
          find(".recommend_user_#{second_user.id}").click()
          find(".recommend_user_#{third_user.id}").click()
          expect(page).to have_selector "div", class: 'select_user', count: 0
        end
      end
      find(".recommend_send").click()
      find(".swal2-confirm").click()
      click_link "ログアウト"
      log_in_as(second_user.email, second_user.password)
      visit '/all_reviews'
      within("#recommend_messages_#{good_review.id}") do
        expect(page).to have_no_selector 'div', text: "この投稿は、#{user.username}におすすめされています"
      end
      click_link "ログアウト"
      log_in_as(third_user.email, third_user.password)
      visit '/all_reviews'
      within("#recommend_messages_#{good_review.id}") do
        expect(page).to have_no_selector 'div', text: "この投稿は、#{user.username}におすすめされています"
      end
    end

  end
end
