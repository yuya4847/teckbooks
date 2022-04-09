require 'rails_helper'
RSpec.describe "Likes", type: :system do
  describe 'Likeができる' do
    describe '投稿詳細ページからlikeとnot_like機能の動作を検証' do
      let!(:user) { create(:user) }
      let!(:good_review) { create(:good_review) }
      let!(:like) { build(:like) }

      it 'likeができること', js: true do
        log_in_as(user.email, user.password)
        visit "/reviews/1"
        within("#like-div1") do
          expect(page).to have_selector 'i', class: "like_btn_ajax"
          find("#like_btn1").click
          expect(page).to have_no_selector 'i', class: "like_btn_ajax"
          expect(page).to have_selector 'i', class: "not_like_btn_ajax"
        end
      end

      it 'not_likeができること', js: true do
        like.save
        log_in_as(user.email, user.password)
        visit '/reviews/1'
        within("#like-div1") do
          expect(page).to have_selector 'i', class: "not_like_btn_ajax"
          find("#not_like_btn1").click
          expect(page).to have_no_selector 'i', class: "not_like_btn_ajax"
          expect(page).to have_selector 'i', class: "like_btn_ajax"
        end
      end
    end

    describe '全投稿一覧ページからlikeとnot_like機能の動作を検証' do
      let!(:user) { create(:user) }
      let!(:good_review) { create(:good_review) }
      let!(:like) { build(:like) }

      it 'likeができること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        within("#review_1") do
          within("#like-div1") do
            expect(page).to have_selector 'i', class: "like_btn_ajax"
            find("#like_btn1").click
            expect(page).to have_no_selector 'i', class: "like_btn_ajax"
            expect(page).to have_selector 'i', class: "not_like_btn_ajax"
          end
        end
      end

      it 'not_likeができること', js: true do
        like.save
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        within("#review_1") do
          within("#like-div1") do
            expect(page).to have_selector 'i', class: "not_like_btn_ajax"
            find("#not_like_btn1").click
            expect(page).to have_no_selector 'i', class: "not_like_btn_ajax"
            expect(page).to have_selector 'i', class: "like_btn_ajax"
          end
        end
      end
    end
  end
end
