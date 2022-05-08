require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "Recommends", type: :system do
  describe '全ての投稿一覧ページからのレコメンド機能の検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:second_user) { create(:second_user, id: 2) }
    let!(:third_user) { create(:third_user, id: 3) }
    let!(:forth_user) { create(:forth_user, id: 4) }
    let!(:fifth_user) { create(:fifth_user, id: 5) }
    let!(:first_relationship) { create(:relationship, follower_id: user.id, followed_id: second_user.id) }
    let!(:second_relationship) { create(:relationship, follower_id: user.id, followed_id: third_user.id) }
    let!(:good_review) { create(:good_review) }

    it 'モーダルの要素検証をすること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#review_#{good_review.id}") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".recommend-modal-titles") do
          expect(page).to have_selector 'div', text: "Who You Recommend ?"
          expect(page).to have_selector 'div', text: "(複数選択可)"
        end
        within(".modal-recommned-scroll") do
          within(".recommend_user_#{second_user.id}") do
            within(".will_recommend_user_profiles") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{second_user.username}"
              expect(page).to have_selector 'div', text: "Since #{second_user.created_at.strftime("%Y/%m/%d")}"
            end
            within(".recommend-folloing-div") do
              expect(page).to have_selector 'span', text: "(フォロー中)"
            end
          end
          within(".recommend_user_#{third_user.id}") do
            within(".will_recommend_user_profiles") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{third_user.username}"
              expect(page).to have_selector 'div', text: "Since #{third_user.created_at.strftime("%Y/%m/%d")}"
            end
            within(".recommend-folloing-div") do
              expect(page).to have_selector 'span', text: "(フォロー中)"
            end
          end
          within(".recommend_user_#{forth_user.id}") do
            within(".will_recommend_user_profiles") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{forth_user.username}"
              expect(page).to have_selector 'div', text: "Since #{forth_user.created_at.strftime("%Y/%m/%d")}"
            end
            within(".recommend-folloing-div") do
              expect(page).to have_no_selector 'span', text: "(フォロー中)"
            end
          end
          within(".recommend_user_#{fifth_user.id}") do
            within(".will_recommend_user_profiles") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{fifth_user.username}"
              expect(page).to have_selector 'div', text: "Since #{fifth_user.created_at.strftime("%Y/%m/%d")}"
            end
            within(".recommend-folloing-div") do
              expect(page).to have_no_selector 'span', text: "(フォロー中)"
            end
          end
        end
        within(".recommend-modal-btns") do
          within(".recommend-btn-reset") do
            expect(page).to have_selector 'span', text: "リセット"
          end
          within(".recommend-btn-update") do
            expect(page).to have_selector 'span', text: "更新"
          end
          find('.recommend-btn-update').click
        end
      end
      within('.swal2-container') do
        expect(page).to have_selector 'h2', text: "You Recommended!"
        expect(page).to have_selector 'div', text: "レコメンドが完了しました"
        expect(page).to have_selector 'button', text: "OK"
      end
    end

    it 'ユーザーを選択できること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#review_#{good_review.id}") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").hover
          expect(page).to have_selector 'div', class: "recommend_user_#{second_user.id}", style: "background-color: rgb(232, 242, 245);"
          find(".recommend_user_#{third_user.id}").hover
          expect(page).to have_selector 'div', class: "recommend_user_#{third_user.id}", style: "background-color: rgb(232, 242, 245);"
          find(".recommend_user_#{forth_user.id}").hover
          expect(page).to have_selector 'div', class: "recommend_user_#{forth_user.id}", style: "background-color: rgb(232, 242, 245);"
          find(".recommend_user_#{fifth_user.id}").hover
          expect(page).to have_selector 'div', class: "recommend_user_#{fifth_user.id}", style: "background-color: rgb(232, 242, 245);"
          find(".recommend_user_#{second_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          find(".recommend_user_#{third_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          find(".recommend_user_#{forth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end

    it '選択したユーザーを取り消すことができること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#review_#{good_review.id}") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          find(".recommend_user_#{second_user.id}").click
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          find(".recommend_user_#{third_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          find(".recommend_user_#{third_user.id}").click
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          find(".recommend_user_#{forth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          find(".recommend_user_#{forth_user.id}").click
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end

    it '選択したユーザーをリセットボタンで全て取り消すことができること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#review_#{good_review.id}") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          find(".recommend_user_#{third_user.id}").click
          find(".recommend_user_#{forth_user.id}").click
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
        within(".recommend-modal-btns") do
          find('.recommend-btn-reset').click
        end
        within(".modal-recommned-scroll") do
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end

    it '選択したユーザーをレコメンドできること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#review_#{good_review.id}") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          find(".recommend_user_#{third_user.id}").click
          find(".recommend_user_#{forth_user.id}").click
          find(".recommend_user_#{fifth_user.id}").click
        end
        within(".recommend-modal-btns") do
          find('.recommend-btn-update').click
        end
      end
      expect(page).to have_selector 'h2', text: "You Recommended!"
    end

    it '選択後に再びモーダルを開くと、ユーザーの選択が消えていること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#review_#{good_review.id}") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          find(".recommend_user_#{third_user.id}").click
          find(".recommend_user_#{forth_user.id}").click
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
      find(".recommend-s-modal-#{good_review.id}").click
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end

    it 'レコメンド後に再びモーダルを開くと、ユーザーが選択されていること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within("#review_#{good_review.id}") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          find(".recommend_user_#{third_user.id}").click
          find(".recommend_user_#{forth_user.id}").click
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
        within(".recommend-modal-btns") do
          find('.recommend-btn-update').click
        end
      end
      expect(page).to have_selector 'h2', text: "You Recommended!"
      find('.swal2-confirm').click
      within("#review_#{good_review.id}") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end
  end

  describe '投稿詳細ページからのレコメンド機能の検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:second_user) { create(:second_user, id: 2) }
    let!(:third_user) { create(:third_user, id: 3) }
    let!(:forth_user) { create(:forth_user, id: 4) }
    let!(:fifth_user) { create(:fifth_user, id: 5) }
    let!(:first_relationship) { create(:relationship, follower_id: user.id, followed_id: second_user.id) }
    let!(:second_relationship) { create(:relationship, follower_id: user.id, followed_id: third_user.id) }
    let!(:good_review) { create(:good_review) }

    it 'モーダルの要素検証をすること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}"
      within(".mypage-review-bottom-icons") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".recommend-modal-titles") do
          expect(page).to have_selector 'div', text: "Who You Recommend ?"
          expect(page).to have_selector 'div', text: "(複数選択可)"
        end
        within(".modal-recommned-scroll") do
          within(".recommend_user_#{second_user.id}") do
            within(".will_recommend_user_profiles") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{second_user.username}"
              expect(page).to have_selector 'div', text: "Since #{second_user.created_at.strftime("%Y/%m/%d")}"
            end
            within(".recommend-folloing-div") do
              expect(page).to have_selector 'span', text: "(フォロー中)"
            end
          end
          within(".recommend_user_#{third_user.id}") do
            within(".will_recommend_user_profiles") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{third_user.username}"
              expect(page).to have_selector 'div', text: "Since #{third_user.created_at.strftime("%Y/%m/%d")}"
            end
            within(".recommend-folloing-div") do
              expect(page).to have_selector 'span', text: "(フォロー中)"
            end
          end
          within(".recommend_user_#{forth_user.id}") do
            within(".will_recommend_user_profiles") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{forth_user.username}"
              expect(page).to have_selector 'div', text: "Since #{forth_user.created_at.strftime("%Y/%m/%d")}"
            end
            within(".recommend-folloing-div") do
              expect(page).to have_no_selector 'span', text: "(フォロー中)"
            end
          end
          within(".recommend_user_#{fifth_user.id}") do
            within(".will_recommend_user_profiles") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{fifth_user.username}"
              expect(page).to have_selector 'div', text: "Since #{fifth_user.created_at.strftime("%Y/%m/%d")}"
            end
            within(".recommend-folloing-div") do
              expect(page).to have_no_selector 'span', text: "(フォロー中)"
            end
          end
        end
        within(".recommend-modal-btns") do
          within(".recommend-btn-reset") do
            expect(page).to have_selector 'span', text: "リセット"
          end
          within(".recommend-btn-update") do
            expect(page).to have_selector 'span', text: "更新"
          end
          find('.recommend-btn-update').click
        end
      end
      within('.swal2-container') do
        expect(page).to have_selector 'h2', text: "You Recommended!"
        expect(page).to have_selector 'div', text: "レコメンドが完了しました"
        expect(page).to have_selector 'button', text: "OK"
      end
    end

    it 'ユーザーを選択できること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}"
      within(".mypage-review-bottom-icons") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").hover
          expect(page).to have_selector 'div', class: "recommend_user_#{second_user.id}", style: "background-color: rgb(232, 242, 245);"
          find(".recommend_user_#{third_user.id}").hover
          expect(page).to have_selector 'div', class: "recommend_user_#{third_user.id}", style: "background-color: rgb(232, 242, 245);"
          find(".recommend_user_#{forth_user.id}").hover
          expect(page).to have_selector 'div', class: "recommend_user_#{forth_user.id}", style: "background-color: rgb(232, 242, 245);"
          find(".recommend_user_#{fifth_user.id}").hover
          expect(page).to have_selector 'div', class: "recommend_user_#{fifth_user.id}", style: "background-color: rgb(232, 242, 245);"
          find(".recommend_user_#{second_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          find(".recommend_user_#{third_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          find(".recommend_user_#{forth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end

    it '選択したユーザーを取り消すことができること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}"
      within(".mypage-review-bottom-icons") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          find(".recommend_user_#{second_user.id}").click
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          find(".recommend_user_#{third_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          find(".recommend_user_#{third_user.id}").click
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          find(".recommend_user_#{forth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          find(".recommend_user_#{forth_user.id}").click
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end

    it '選択したユーザーをリセットボタンで全て取り消すことができること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}"
      within(".mypage-review-bottom-icons") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          find(".recommend_user_#{third_user.id}").click
          find(".recommend_user_#{forth_user.id}").click
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
        within(".recommend-modal-btns") do
          find('.recommend-btn-reset').click
        end
        within(".modal-recommned-scroll") do
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end

    it '選択したユーザーをレコメンドできること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}"
      within(".mypage-review-bottom-icons") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          find(".recommend_user_#{third_user.id}").click
          find(".recommend_user_#{forth_user.id}").click
          find(".recommend_user_#{fifth_user.id}").click
        end
        within(".recommend-modal-btns") do
          find('.recommend-btn-update').click
        end
      end
      expect(page).to have_selector 'h2', text: "You Recommended!"
    end

    it '選択後に再びモーダルを開くと、ユーザーの選択が消えていること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}"
      within(".mypage-review-bottom-icons") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          find(".recommend_user_#{third_user.id}").click
          find(".recommend_user_#{forth_user.id}").click
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
      find(".recommend-s-modal-#{good_review.id}").click
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_no_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end

    it 'レコメンド後に再びモーダルを開くと、ユーザーが選択されていること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}"
      within(".mypage-review-bottom-icons") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          find(".recommend_user_#{second_user.id}").click
          find(".recommend_user_#{third_user.id}").click
          find(".recommend_user_#{forth_user.id}").click
          find(".recommend_user_#{fifth_user.id}").click
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
        within(".recommend-modal-btns") do
          find('.recommend-btn-update').click
        end
      end
      expect(page).to have_selector 'h2', text: "You Recommended!"
      find('.swal2-confirm').click
      within(".mypage-review-bottom-icons") do
        find(".recommend_review_id_#{good_review.id}").click
      end
      within(".show_recommend_modal_content") do
        within(".modal-recommned-scroll") do
          expect(page).to have_selector 'div', id: "recommend_id_user_#{second_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{third_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{forth_user.id}", class: "select_user"
          expect(page).to have_selector 'div', id: "recommend_id_user_#{fifth_user.id}", class: "select_user"
        end
      end
    end
  end
end
