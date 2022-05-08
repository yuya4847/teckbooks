require 'rails_helper'
RSpec.describe "Reports", type: :system do
  describe '通報機能の検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:second_user) { create(:second_user, id: 2) }
    let!(:third_user) { create(:third_user, id: 3) }
    let!(:unfollow_user) { create(:unfollow_user, id: 4) }
    let!(:fifth_user) { create(:user, email: "aaaa@aa.aa", id: 5) }
    let!(:top_page_sample_first_review) { create(:good_review, id: 1) }
    let!(:top_page_sample_second__review) { create(:good_review, id: 2) }
    let!(:top_page_sample_third_review) { create(:good_review, id: 3) }
    let!(:good_review) { create(:good_review, id: 4) }

    describe '全ての投稿一覧から通報を検証する' do
      it '通報ボタン・モーダルの動作確認をすること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        within('#review_1') do
          within('#report-div-btn-1') do
            find(".report-review-btn-1").click
          end
        end
        within('.modal_overlay') do
          expect(page).to have_selector 'div', class: 'report_modal_content'
        end
        within('.report_modal_btns') do
          find(".report-cancel-1").click
        end
        within('.modal_overlay') do
          expect(page).to have_no_selector 'div', class: 'report_modal_content'
        end
        within('#review_1') do
          within('#report-div-btn-1') do
            find(".report-review-btn-1").click
          end
        end
        within('.report_modal_btns') do
          find(".report-review-id-1").click
        end
        within('.modal_overlay') do
          expect(page).to have_no_selector 'div', class: 'report_modal_content'
        end
        within('#review_1') do
          within('#report-div-btn-1') do
            expect(page).to have_no_selector 'label', class: 'report-review-btn-1'
          end
        end
      end

      it '通報できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_no_selector 'label', class: 'report-review-btn-1'
      end

      it '5回通報されると削除されること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_selector 'label', class: 'report-review-btn-1'
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit '/all_reviews'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_selector 'label', class: 'report-review-btn-1'
        click_link "ログアウト"
        log_in_as(third_user.email, third_user.password)
        visit '/all_reviews'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_selector 'label', class: 'report-review-btn-1'
        click_link "ログアウト"
        log_in_as(unfollow_user.email, unfollow_user.password)
        visit '/all_reviews'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_selector 'label', class: 'report-review-btn-1'
        click_link "ログアウト"
        log_in_as(fifth_user.email, fifth_user.password)
        visit '/all_reviews'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_no_selector 'label', class: 'report-review-btn-1'
      end
    end

    describe '投稿詳細ページから通報を検証する' do
      it '通報ボタン・モーダルの動作確認をすること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/1'
        within('.mypage-review-bottom-icons') do
          find(".report-review-btn-1").click
        end
        within('.modal_overlay') do
          expect(page).to have_selector 'div', class: 'report_modal_content'
        end
        within('.report_modal_btns') do
          find(".report-cancel-1").click
        end
        within('.modal_overlay') do
          expect(page).to have_no_selector 'div', class: 'report_modal_content'
        end
        within('.mypage-review-bottom-icons') do
          find(".report-review-btn-1").click
        end
        within('.report_modal_btns') do
          find(".report-review-id-1").click
        end
        within('.modal_overlay') do
          expect(page).to have_no_selector 'div', class: 'report_modal_content'
        end
        within('.mypage-review-bottom-icons') do
          expect(page).to have_no_selector 'label', class: 'report-review-btn-1'
        end
      end

      it '通報できること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/1'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_no_selector 'label', class: 'report-review-btn-1'
      end

      it '5回通報されると削除されること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/1'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_selector 'label', class: 'report-review-btn-1'
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit '/reviews/1'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_selector 'label', class: 'report-review-btn-1'
        click_link "ログアウト"
        log_in_as(third_user.email, third_user.password)
        visit '/reviews/1'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_selector 'label', class: 'report-review-btn-1'
        click_link "ログアウト"
        log_in_as(unfollow_user.email, unfollow_user.password)
        visit '/reviews/1'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_selector 'label', class: 'report-review-btn-1'
        click_link "ログアウト"
        log_in_as(fifth_user.email, fifth_user.password)
        visit '/reviews/1'
        find(".report-review-btn-1").click
        find(".report-review-id-1").click
        expect(page).to have_no_selector 'label', class: 'report-review-btn-1'
      end
    end
  end
end
