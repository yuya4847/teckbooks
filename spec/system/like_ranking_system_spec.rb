require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "いいねランキング機能の検証", type: :system do
  describe 'いいねランキングの要素検証' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:forth_user) { create(:forth_user) }
    let!(:fifth_user) { create(:fifth_user) }
    let!(:sixth_user) { create(:sixth_user) }
    let!(:seventh_user) { create(:seventh_user) }
    let!(:eighth_user) { create(:eighth_user) }
    let!(:ninth_user) { create(:ninth_user) }
    let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
    let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
    let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }
    let!(:forth_rank_review) { create(:good_review, title: "楽しいlaravel入門") }
    let!(:fifth_rank_review) { create(:good_review, title: "楽しいpython入門") }
    let!(:sixth_rank_review) { create(:good_review, title: "楽しいdjango入門") }
    let!(:seventh_rank_review) { create(:good_review, title: "楽しいaws入門") }
    let!(:eighth_rank_review) { create(:good_review, title: "楽しいdocker入門") }
    let!(:ninth_rank_review) { create(:good_review, title: "楽しいhtml入門") }
    let!(:user_like_first_review) { create(:like, user_id: user.id, review_id: first_rank_review.id) }
    let!(:user_like_second_review) { create(:like, user_id: user.id, review_id: second_rank_review.id) }
    let!(:user_like_third_review) { create(:like, user_id: user.id, review_id: third_rank_review.id) }
    let!(:user_like_forth_review) { create(:like, user_id: user.id, review_id: forth_rank_review.id) }
    let!(:user_like_fifth_review) { create(:like, user_id: user.id, review_id: fifth_rank_review.id) }
    let!(:user_like_sixth_review) { create(:like, user_id: user.id, review_id: sixth_rank_review.id) }
    let!(:user_like_seventh_review) { create(:like, user_id: user.id, review_id: seventh_rank_review.id) }
    let!(:user_like_eighth_review) { create(:like, user_id: user.id, review_id: eighth_rank_review.id) }
    let!(:user_like_ninth_review) { create(:like, user_id: user.id, review_id: ninth_rank_review.id) }
    let!(:second_user_like_first_review) { create(:like, user_id: second_user.id, review_id: first_rank_review.id) }
    let!(:second_user_like_second_review) { create(:like, user_id: second_user.id, review_id: second_rank_review.id) }
    let!(:second_user_like_third_review) { create(:like, user_id: second_user.id, review_id: third_rank_review.id) }
    let!(:second_user_like_forth_review) { create(:like, user_id: second_user.id, review_id: forth_rank_review.id) }
    let!(:second_user_like_fifth_review) { create(:like, user_id: second_user.id, review_id: fifth_rank_review.id) }
    let!(:second_user_like_sixth_review) { create(:like, user_id: second_user.id, review_id: sixth_rank_review.id) }
    let!(:second_user_like_seventh_review) { create(:like, user_id: second_user.id, review_id: seventh_rank_review.id) }
    let!(:second_user_like_eighth_review) { create(:like, user_id: second_user.id, review_id: eighth_rank_review.id) }
    let!(:third_user_like_first_review) { create(:like, user_id: third_user.id, review_id: first_rank_review.id) }
    let!(:third_user_like_second_review) { create(:like, user_id: third_user.id, review_id: second_rank_review.id) }
    let!(:third_user_like_third_review) { create(:like, user_id: third_user.id, review_id: third_rank_review.id) }
    let!(:third_user_like_forth_review) { create(:like, user_id: third_user.id, review_id: forth_rank_review.id) }
    let!(:third_user_like_fifth_review) { create(:like, user_id: third_user.id, review_id: fifth_rank_review.id) }
    let!(:third_user_like_sixth_review) { create(:like, user_id: third_user.id, review_id: sixth_rank_review.id) }
    let!(:third_user_like_seventh_review) { create(:like, user_id: third_user.id, review_id: seventh_rank_review.id) }
    let!(:forth_user_like_first_review) { create(:like, user_id: forth_user.id, review_id: first_rank_review.id) }
    let!(:forth_user_like_second_review) { create(:like, user_id: forth_user.id, review_id: second_rank_review.id) }
    let!(:forth_user_like_third_review) { create(:like, user_id: forth_user.id, review_id: third_rank_review.id) }
    let!(:forth_user_like_forth_review) { create(:like, user_id: forth_user.id, review_id: forth_rank_review.id) }
    let!(:forth_user_like_fifth_review) { create(:like, user_id: forth_user.id, review_id: fifth_rank_review.id) }
    let!(:forth_user_like_sixth_review) { create(:like, user_id: forth_user.id, review_id: sixth_rank_review.id) }
    let!(:fifth_user_like_first_review) { create(:like, user_id: fifth_user.id, review_id: first_rank_review.id) }
    let!(:fifth_user_like_second_review) { create(:like, user_id: fifth_user.id, review_id: second_rank_review.id) }
    let!(:fifth_user_like_third_review) { create(:like, user_id: fifth_user.id, review_id: third_rank_review.id) }
    let!(:fifth_user_like_forth_review) { create(:like, user_id: fifth_user.id, review_id: forth_rank_review.id) }
    let!(:fifth_user_like_fifth_review) { create(:like, user_id: fifth_user.id, review_id: fifth_rank_review.id) }
    let!(:sixth_user_like_first_review) { create(:like, user_id: sixth_user.id, review_id: first_rank_review.id) }
    let!(:sixth_user_like_second_review) { create(:like, user_id: sixth_user.id, review_id: second_rank_review.id) }
    let!(:sixth_user_like_third_review) { create(:like, user_id: sixth_user.id, review_id: third_rank_review.id) }
    let!(:sixth_user_like_forth_review) { create(:like, user_id: sixth_user.id, review_id: forth_rank_review.id) }
    let!(:seventh_user_like_first_review) { create(:like, user_id: seventh_user.id, review_id: first_rank_review.id) }
    let!(:seventh_user_like_second_review) { create(:like, user_id: seventh_user.id, review_id: second_rank_review.id) }
    let!(:seventh_user_like_third_review) { create(:like, user_id: seventh_user.id, review_id: third_rank_review.id) }
    let!(:eighth_user_like_first_review) { create(:like, user_id: eighth_user.id, review_id: first_rank_review.id) }
    let!(:eighth_user_like_second_review) { create(:like, user_id: eighth_user.id, review_id: second_rank_review.id) }
    let!(:ninth_user_like_first_review) { create(:like, user_id: ninth_user.id, review_id: first_rank_review.id) }

    it '要素検証をすること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#ranking_ajax") do
        within(".like-ranking-title") do
          expect(page).to have_selector 'div', text: "いいねランキング"
        end
        within("#like_ranking_1") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "1"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{first_rank_review.title}"
            expect(page).to have_selector 'span', text: "9like / #{first_rank_review.user.username} / #{I18n.l(first_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_2") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "2"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{second_rank_review.title}"
            expect(page).to have_selector 'span', text: "8like / #{second_rank_review.user.username} / #{I18n.l(second_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_3") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "3"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{third_rank_review.title}"
            expect(page).to have_selector 'span', text: "7like / #{third_rank_review.user.username} / #{I18n.l(third_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_4") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "4"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{forth_rank_review.title}"
            expect(page).to have_selector 'span', text: "6like / #{forth_rank_review.user.username} / #{I18n.l(forth_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_5") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "5"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{fifth_rank_review.title}"
            expect(page).to have_selector 'span', text: "5like / #{fifth_rank_review.user.username} / #{I18n.l(fifth_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_6") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "6"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{sixth_rank_review.title}"
            expect(page).to have_selector 'span', text: "4like / #{sixth_rank_review.user.username} / #{I18n.l(sixth_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_7") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "7"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{seventh_rank_review.title}"
            expect(page).to have_selector 'span', text: "3like / #{seventh_rank_review.user.username} / #{I18n.l(seventh_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_8") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "8"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{eighth_rank_review.title}"
            expect(page).to have_selector 'span', text: "2like / #{eighth_rank_review.user.username} / #{I18n.l(eighth_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_9") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "9"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{ninth_rank_review.title}"
            expect(page).to have_selector 'span', text: "1like / #{ninth_rank_review.user.username} / #{I18n.l(ninth_rank_review.created_at, format: :long)}"
          end
        end
      end
    end
  end

  describe 'いいねランキングの表示の検証' do
    context 'いいねランキングが表示されない場合' do
      context 'レビューが存在しない場合' do
        let!(:user) { create(:user) }

        it 'ランキングが表示されないこと', js: true do
          log_in_as(user.email, user.password)
          visit "/all_reviews"
          within("#ranking_ajax") do
            expect(page).to have_no_selector 'div', class: "like-ranking-title"
            expect(page).to have_no_selector 'div', class: "ranking-review-individual"
          end
        end
      end

      context 'レビューの数が3投稿未満の場合' do
        let!(:user) { create(:user) }
        let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
        let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }

        it 'ランキングが表示されないこと', js: true do
          log_in_as(user.email, user.password)
          visit "/all_reviews"
          within("#ranking_ajax") do
            expect(page).to have_no_selector 'div', class: "like-ranking-title"
            expect(page).to have_no_selector 'div', class: "ranking-review-individual"
          end
        end
      end
    end

    context 'いいねランキングが表示される場合' do
      context 'レビューの数が3投稿以上の場合' do
        let!(:user) { create(:user) }
        let!(:second_user) { create(:second_user) }
        let!(:third_user) { create(:third_user) }
        let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
        let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
        let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }
        let!(:user_like_first) { create(:like, user_id: user.id, review_id: first_rank_review.id) }
        let!(:second_user_like_first) { create(:like, user_id: second_user.id, review_id: first_rank_review.id) }
        let!(:third_user_like_first) { create(:like, user_id: third_user.id, review_id: first_rank_review.id) }
        let!(:user_like_second) { create(:like, user_id: user.id, review_id: second_rank_review.id) }
        let!(:second_user_like_second) { create(:like, user_id: second_user.id, review_id: second_rank_review.id) }
        let!(:user_like_third) { create(:like, user_id: user.id, review_id: third_rank_review.id) }

        it 'ランキングが表示されること', js: true do
          log_in_as(user.email, user.password)
          visit "/all_reviews"
          within("#ranking_ajax") do
            within("#like_ranking_1") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "1"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{first_rank_review.title}"
                expect(page).to have_selector 'span', text: "3like / #{first_rank_review.user.username} / #{I18n.l(first_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_2") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "2"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{second_rank_review.title}"
                expect(page).to have_selector 'span', text: "2like / #{second_rank_review.user.username} / #{I18n.l(second_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_3") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "3"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{third_rank_review.title}"
                expect(page).to have_selector 'span', text: "1like / #{third_rank_review.user.username} / #{I18n.l(third_rank_review.created_at, format: :long)}"
              end
            end
          end
        end
      end

      context 'レビューの数が10投稿以上の場合' do
        let!(:user) { create(:user) }
        let!(:second_user) { create(:second_user) }
        let!(:third_user) { create(:third_user) }
        let!(:forth_user) { create(:forth_user) }
        let!(:fifth_user) { create(:fifth_user) }
        let!(:sixth_user) { create(:sixth_user) }
        let!(:seventh_user) { create(:seventh_user) }
        let!(:eighth_user) { create(:eighth_user) }
        let!(:ninth_user) { create(:ninth_user) }
        let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
        let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
        let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }
        let!(:forth_rank_review) { create(:good_review, title: "楽しいlaravel入門") }
        let!(:fifth_rank_review) { create(:good_review, title: "楽しいpython入門") }
        let!(:sixth_rank_review) { create(:good_review, title: "楽しいdjango入門") }
        let!(:seventh_rank_review) { create(:good_review, title: "楽しいaws入門") }
        let!(:eighth_rank_review) { create(:good_review, title: "楽しいdocker入門") }
        let!(:ninth_rank_review) { create(:good_review, title: "楽しいhtml入門") }
        let!(:ten_rank_review) { create(:good_review, title: "楽しいflutter入門") }
        let!(:user_like_first_review) { create(:like, user_id: user.id, review_id: first_rank_review.id) }
        let!(:user_like_second_review) { create(:like, user_id: user.id, review_id: second_rank_review.id) }
        let!(:user_like_third_review) { create(:like, user_id: user.id, review_id: third_rank_review.id) }
        let!(:user_like_forth_review) { create(:like, user_id: user.id, review_id: forth_rank_review.id) }
        let!(:user_like_fifth_review) { create(:like, user_id: user.id, review_id: fifth_rank_review.id) }
        let!(:user_like_sixth_review) { create(:like, user_id: user.id, review_id: sixth_rank_review.id) }
        let!(:user_like_seventh_review) { create(:like, user_id: user.id, review_id: seventh_rank_review.id) }
        let!(:user_like_eighth_review) { create(:like, user_id: user.id, review_id: eighth_rank_review.id) }
        let!(:user_like_ninth_review) { create(:like, user_id: user.id, review_id: ninth_rank_review.id) }
        let!(:second_user_like_first_review) { create(:like, user_id: second_user.id, review_id: first_rank_review.id) }
        let!(:second_user_like_second_review) { create(:like, user_id: second_user.id, review_id: second_rank_review.id) }
        let!(:second_user_like_third_review) { create(:like, user_id: second_user.id, review_id: third_rank_review.id) }
        let!(:second_user_like_forth_review) { create(:like, user_id: second_user.id, review_id: forth_rank_review.id) }
        let!(:second_user_like_fifth_review) { create(:like, user_id: second_user.id, review_id: fifth_rank_review.id) }
        let!(:second_user_like_sixth_review) { create(:like, user_id: second_user.id, review_id: sixth_rank_review.id) }
        let!(:second_user_like_seventh_review) { create(:like, user_id: second_user.id, review_id: seventh_rank_review.id) }
        let!(:second_user_like_eighth_review) { create(:like, user_id: second_user.id, review_id: eighth_rank_review.id) }
        let!(:third_user_like_first_review) { create(:like, user_id: third_user.id, review_id: first_rank_review.id) }
        let!(:third_user_like_second_review) { create(:like, user_id: third_user.id, review_id: second_rank_review.id) }
        let!(:third_user_like_third_review) { create(:like, user_id: third_user.id, review_id: third_rank_review.id) }
        let!(:third_user_like_forth_review) { create(:like, user_id: third_user.id, review_id: forth_rank_review.id) }
        let!(:third_user_like_fifth_review) { create(:like, user_id: third_user.id, review_id: fifth_rank_review.id) }
        let!(:third_user_like_sixth_review) { create(:like, user_id: third_user.id, review_id: sixth_rank_review.id) }
        let!(:third_user_like_seventh_review) { create(:like, user_id: third_user.id, review_id: seventh_rank_review.id) }
        let!(:forth_user_like_first_review) { create(:like, user_id: forth_user.id, review_id: first_rank_review.id) }
        let!(:forth_user_like_second_review) { create(:like, user_id: forth_user.id, review_id: second_rank_review.id) }
        let!(:forth_user_like_third_review) { create(:like, user_id: forth_user.id, review_id: third_rank_review.id) }
        let!(:forth_user_like_forth_review) { create(:like, user_id: forth_user.id, review_id: forth_rank_review.id) }
        let!(:forth_user_like_fifth_review) { create(:like, user_id: forth_user.id, review_id: fifth_rank_review.id) }
        let!(:forth_user_like_sixth_review) { create(:like, user_id: forth_user.id, review_id: sixth_rank_review.id) }
        let!(:fifth_user_like_first_review) { create(:like, user_id: fifth_user.id, review_id: first_rank_review.id) }
        let!(:fifth_user_like_second_review) { create(:like, user_id: fifth_user.id, review_id: second_rank_review.id) }
        let!(:fifth_user_like_third_review) { create(:like, user_id: fifth_user.id, review_id: third_rank_review.id) }
        let!(:fifth_user_like_forth_review) { create(:like, user_id: fifth_user.id, review_id: forth_rank_review.id) }
        let!(:fifth_user_like_fifth_review) { create(:like, user_id: fifth_user.id, review_id: fifth_rank_review.id) }
        let!(:sixth_user_like_first_review) { create(:like, user_id: sixth_user.id, review_id: first_rank_review.id) }
        let!(:sixth_user_like_second_review) { create(:like, user_id: sixth_user.id, review_id: second_rank_review.id) }
        let!(:sixth_user_like_third_review) { create(:like, user_id: sixth_user.id, review_id: third_rank_review.id) }
        let!(:sixth_user_like_forth_review) { create(:like, user_id: sixth_user.id, review_id: forth_rank_review.id) }
        let!(:seventh_user_like_first_review) { create(:like, user_id: seventh_user.id, review_id: first_rank_review.id) }
        let!(:seventh_user_like_second_review) { create(:like, user_id: seventh_user.id, review_id: second_rank_review.id) }
        let!(:seventh_user_like_third_review) { create(:like, user_id: seventh_user.id, review_id: third_rank_review.id) }
        let!(:eighth_user_like_first_review) { create(:like, user_id: eighth_user.id, review_id: first_rank_review.id) }
        let!(:eighth_user_like_second_review) { create(:like, user_id: eighth_user.id, review_id: second_rank_review.id) }
        let!(:ninth_user_like_first_review) { create(:like, user_id: ninth_user.id, review_id: first_rank_review.id) }

        it 'ランキングが表示されること', js: true do
          log_in_as(user.email, user.password)
          visit "/all_reviews"
          within("#ranking_ajax") do
            within(".like-ranking-title") do
              expect(page).to have_selector 'div', text: "いいねランキング"
            end
            within("#like_ranking_1") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "1"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{first_rank_review.title}"
                expect(page).to have_selector 'span', text: "9like / #{first_rank_review.user.username} / #{I18n.l(first_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_2") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "2"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{second_rank_review.title}"
                expect(page).to have_selector 'span', text: "8like / #{second_rank_review.user.username} / #{I18n.l(second_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_3") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "3"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{third_rank_review.title}"
                expect(page).to have_selector 'span', text: "7like / #{third_rank_review.user.username} / #{I18n.l(third_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_4") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "4"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{forth_rank_review.title}"
                expect(page).to have_selector 'span', text: "6like / #{forth_rank_review.user.username} / #{I18n.l(forth_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_5") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "5"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{fifth_rank_review.title}"
                expect(page).to have_selector 'span', text: "5like / #{fifth_rank_review.user.username} / #{I18n.l(fifth_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_6") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "6"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{sixth_rank_review.title}"
                expect(page).to have_selector 'span', text: "4like / #{sixth_rank_review.user.username} / #{I18n.l(sixth_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_7") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "7"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{seventh_rank_review.title}"
                expect(page).to have_selector 'span', text: "3like / #{seventh_rank_review.user.username} / #{I18n.l(seventh_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_8") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "8"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{eighth_rank_review.title}"
                expect(page).to have_selector 'span', text: "2like / #{eighth_rank_review.user.username} / #{I18n.l(eighth_rank_review.created_at, format: :long)}"
              end
            end
            within("#like_ranking_9") do
              within(".ranking-icon-div-left") do
                expect(page).to have_selector('svg', count: 1)
                expect(page).to have_selector 'div', text: "9"
              end
              within(".ranking-icon-div-right") do
                expect(page).to have_selector('a', count: 1)
                expect(page).to have_selector 'span', text: "#{ninth_rank_review.title}"
                expect(page).to have_selector 'span', text: "1like / #{ninth_rank_review.user.username} / #{I18n.l(ninth_rank_review.created_at, format: :long)}"
              end
            end
            expect(page).to have_no_selector 'div', text: "#like_ranking_10"
            expect(page).to have_no_selector 'div', text: "10"
            expect(page).to have_no_selector 'span', text: "#{ten_rank_review.title}"
            expect(page).to have_no_selector 'span', text: "0like / #{ten_rank_review.user.username} / #{I18n.l(ten_rank_review.created_at, format: :long)}"
          end
        end
      end
    end
  end

  describe 'ランキングの変動の検証' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:forth_user) { create(:forth_user) }
    let!(:fifth_user) { create(:fifth_user) }

    let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
    let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
    let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }
    let!(:user_like_first) { create(:like, user_id: user.id, review_id: first_rank_review.id) }
    let!(:second_user_like_first) { create(:like, user_id: second_user.id, review_id: first_rank_review.id) }
    let!(:third_user_like_first) { create(:like, user_id: third_user.id, review_id: first_rank_review.id) }
    let!(:user_like_second) { create(:like, user_id: user.id, review_id: second_rank_review.id) }
    let!(:second_user_like_second) { create(:like, user_id: second_user.id, review_id: second_rank_review.id) }
    let!(:user_like_third) { create(:like, user_id: user.id, review_id: third_rank_review.id) }

    let!(:forth_user_like_second) { build(:like, user_id: forth_user.id, review_id: second_rank_review.id) }
    let!(:fifth_user_like_second) { build(:like, user_id: fifth_user.id, review_id: second_rank_review.id) }

    it 'ランキングが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#ranking_ajax") do
        within("#like_ranking_1") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "1"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{first_rank_review.title}"
            expect(page).to have_selector 'span', text: "3like / #{first_rank_review.user.username} / #{I18n.l(first_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_2") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "2"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{second_rank_review.title}"
            expect(page).to have_selector 'span', text: "2like / #{second_rank_review.user.username} / #{I18n.l(second_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_3") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "3"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{third_rank_review.title}"
            expect(page).to have_selector 'span', text: "1like / #{third_rank_review.user.username} / #{I18n.l(third_rank_review.created_at, format: :long)}"
          end
        end
      end
      forth_user_like_second.save
      fifth_user_like_second.save
      visit "/all_reviews"
      within("#ranking_ajax") do
        within("#like_ranking_1") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "1"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{second_rank_review.title}"
            expect(page).to have_selector 'span', text: "4like / #{second_rank_review.user.username} / #{I18n.l(second_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_2") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "2"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{first_rank_review.title}"
            expect(page).to have_selector 'span', text: "3like / #{first_rank_review.user.username} / #{I18n.l(first_rank_review.created_at, format: :long)}"
          end
        end
        within("#like_ranking_3") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "3"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{third_rank_review.title}"
            expect(page).to have_selector 'span', text: "1like / #{third_rank_review.user.username} / #{I18n.l(third_rank_review.created_at, format: :long)}"
          end
        end
      end
    end
  end
end
