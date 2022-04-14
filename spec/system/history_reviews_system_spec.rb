require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "最近見た投稿機能の検証", type: :system do
  describe '全投稿一覧ページにおける最近見た投稿機能の検証' do
    describe '最近見た投稿機能の要素検証' do
      let!(:user) { create(:user) }
      let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }

      it '要素検証をすること', js: true do
        log_in_as(user.email, user.password)
        visit "/reviews/#{first_rank_review.id}"
        visit "/all_reviews"
        within(".wrap-tab") do
          within("#js-tab") do
            expect(page).to have_selector 'li', text: "最近見た投稿"
          end
          within(".wrap-tab-content") do
            within(".recent-reviews") do
              within(".recent-review-#{first_rank_review.id}") do
                expect(page).to have_selector('a', count: 2)
                expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
                expect(page).to have_selector 'a', text: "#{first_rank_review.title}"
              end
            end
          end
        end
      end
    end

    describe '最近見た投稿機能の表示の検証' do
      context '表示されない場合' do
        let!(:user) { create(:user) }
        let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
        let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }

        it '投稿が表示さないこと', js: true do
          log_in_as(user.email, user.password)
          visit "/all_reviews"
          within(".wrap-tab-content") do
            within(".recent-reviews") do
              expect(page).to have_selector 'div', text: "最近見た投稿はありません"
            end
          end
        end
      end

      context '表示される場合' do
        let!(:user) { create(:user) }
        let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
        let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }

        it '投稿が表示されること', js: true do
          log_in_as(user.email, user.password)
          visit "/all_reviews"
          within(".wrap-tab-content") do
            within(".recent-reviews") do
              expect(page).to have_selector 'div', text: "最近見た投稿はありません"
            end
          end
          visit "/reviews/#{first_rank_review.id}"
          visit "/reviews/#{second_rank_review.id}"
          visit "/all_reviews"
          within(".wrap-tab-content") do
            within(".recent-reviews") do
              within(".recent-review-#{first_rank_review.id}") do
                expect(page).to have_selector('a', count: 2)
                expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
                expect(page).to have_selector 'a', text: "#{first_rank_review.title}"
              end
              within(".recent-review-#{second_rank_review.id}") do
                expect(page).to have_selector('a', count: 2)
                expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
                expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
              end
            end
          end
        end
      end
    end

    describe '6投稿が表示の限界であることの検証' do
      let!(:user) { create(:user) }
      let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
      let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
      let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }
      let!(:forth_rank_review) { create(:good_review, title: "楽しいlaravel入門") }
      let!(:fifth_rank_review) { create(:good_review, title: "楽しいrails入門") }
      let!(:sixth_rank_review) { create(:good_review, title: "楽しいpython入門") }
      let!(:seventh_rank_review) { create(:good_review, title: "楽しいdjango入門") }

      it '6投稿が表示の限界であること', js: true do
        log_in_as(user.email, user.password)
        visit "/all_reviews"
        visit "/reviews/#{first_rank_review.id}"
        visit "/reviews/#{second_rank_review.id}"
        visit "/reviews/#{third_rank_review.id}"
        visit "/reviews/#{forth_rank_review.id}"
        visit "/reviews/#{fifth_rank_review.id}"
        visit "/reviews/#{sixth_rank_review.id}"
        visit "/reviews/#{seventh_rank_review.id}"
        visit "/all_reviews"
        within(".wrap-tab-content") do
          within(".recent-reviews") do
            within(".recent-review-#{second_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
            end
            within(".recent-review-#{third_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{third_rank_review.title}"
            end
            within(".recent-review-#{forth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{forth_rank_review.title}"
            end
            within(".recent-review-#{fifth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{fifth_rank_review.title}"
            end
            within(".recent-review-#{sixth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{sixth_rank_review.title}"
            end
            within(".recent-review-#{seventh_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{seventh_rank_review.title}"
            end
            expect(page).to have_no_selector 'div', class: "recent-review-#{first_rank_review.id}"
            expect(page).to have_no_selector 'a', text: "#{first_rank_review.title}"
          end
        end
      end
    end

    describe '表示が入れ替わることの検証' do
      let!(:user) { create(:user) }
      let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
      let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
      let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }
      let!(:forth_rank_review) { create(:good_review, title: "楽しいlaravel入門") }
      let!(:fifth_rank_review) { create(:good_review, title: "楽しいrails入門") }
      let!(:sixth_rank_review) { create(:good_review, title: "楽しいpython入門") }
      let!(:seventh_rank_review) { create(:good_review, title: "楽しいdjango入門") }

      it '表示が入れ替わること', js: true do
        log_in_as(user.email, user.password)
        visit "/all_reviews"
        visit "/reviews/#{first_rank_review.id}"
        visit "/reviews/#{second_rank_review.id}"
        visit "/reviews/#{third_rank_review.id}"
        visit "/reviews/#{forth_rank_review.id}"
        visit "/reviews/#{fifth_rank_review.id}"
        visit "/reviews/#{sixth_rank_review.id}"
        visit "/all_reviews"
        within(".wrap-tab-content") do
          within(".recent-reviews") do
            within(".recent-review-#{first_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{first_rank_review.title}"
            end
            within(".recent-review-#{second_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
            end
            within(".recent-review-#{third_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{third_rank_review.title}"
            end
            within(".recent-review-#{forth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{forth_rank_review.title}"
            end
            within(".recent-review-#{fifth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{fifth_rank_review.title}"
            end
            within(".recent-review-#{sixth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{sixth_rank_review.title}"
            end
          end
        end
        visit "/reviews/#{seventh_rank_review.id}"
        visit "/all_reviews"
        within(".wrap-tab-content") do
          within(".recent-reviews") do
            expect(page).to have_no_selector 'div', class: "recent-review-#{first_rank_review.id}"
            expect(page).to have_no_selector 'a', text: "#{first_rank_review.title}"
            within(".recent-review-#{second_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
            end
            within(".recent-review-#{third_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{third_rank_review.title}"
            end
            within(".recent-review-#{forth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{forth_rank_review.title}"
            end
            within(".recent-review-#{fifth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{fifth_rank_review.title}"
            end
            within(".recent-review-#{sixth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{sixth_rank_review.title}"
            end
            within(".recent-review-#{seventh_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{seventh_rank_review.title}"
            end
          end
        end
      end
    end
  end

  describe '投稿詳細ページにおける最近見た投稿機能の検証' do
    describe '最近見た投稿機能の要素検証' do
      let!(:user) { create(:user) }
      let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }

      it '要素検証をすること', js: true do
        log_in_as(user.email, user.password)
        visit "/reviews/#{first_rank_review.id}"
        within(".wrap-tab") do
          within("#js-tab") do
            expect(page).to have_selector 'li', text: "最近見た投稿"
          end
          within(".wrap-tab-content") do
            within(".recent-reviews") do
              within(".recent-review-#{first_rank_review.id}") do
                expect(page).to have_selector('a', count: 2)
                expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
                expect(page).to have_selector 'a', text: "#{first_rank_review.title}"
              end
            end
          end
        end
      end
    end

    describe '最近見た投稿機能の表示の検証' do
      let!(:user) { create(:user) }
      let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
      let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }

      it '投稿が表示されること', js: true do
        log_in_as(user.email, user.password)
        visit "/all_reviews"
        within(".wrap-tab-content") do
          within(".recent-reviews") do
            expect(page).to have_selector 'div', text: "最近見た投稿はありません"
          end
        end
        visit "/reviews/#{first_rank_review.id}"
        visit "/reviews/#{second_rank_review.id}"
        within(".wrap-tab-content") do
          within(".recent-reviews") do
            within(".recent-review-#{first_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{first_rank_review.title}"
            end
            within(".recent-review-#{second_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
            end
          end
        end
      end
    end

    describe '6投稿が表示の限界であることの検証' do
      let!(:user) { create(:user) }
      let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
      let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
      let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }
      let!(:forth_rank_review) { create(:good_review, title: "楽しいlaravel入門") }
      let!(:fifth_rank_review) { create(:good_review, title: "楽しいrails入門") }
      let!(:sixth_rank_review) { create(:good_review, title: "楽しいpython入門") }
      let!(:seventh_rank_review) { create(:good_review, title: "楽しいdjango入門") }

      it '6投稿が表示の限界であること', js: true do
        log_in_as(user.email, user.password)
        visit "/all_reviews"
        visit "/reviews/#{first_rank_review.id}"
        visit "/reviews/#{second_rank_review.id}"
        visit "/reviews/#{third_rank_review.id}"
        visit "/reviews/#{forth_rank_review.id}"
        visit "/reviews/#{fifth_rank_review.id}"
        visit "/reviews/#{sixth_rank_review.id}"
        visit "/reviews/#{seventh_rank_review.id}"
        within(".wrap-tab-content") do
          within(".recent-reviews") do
            within(".recent-review-#{second_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
            end
            within(".recent-review-#{third_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{third_rank_review.title}"
            end
            within(".recent-review-#{forth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{forth_rank_review.title}"
            end
            within(".recent-review-#{fifth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{fifth_rank_review.title}"
            end
            within(".recent-review-#{sixth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{sixth_rank_review.title}"
            end
            within(".recent-review-#{seventh_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{seventh_rank_review.title}"
            end
            expect(page).to have_no_selector 'div', class: "recent-review-#{first_rank_review.id}"
            expect(page).to have_no_selector 'a', text: "#{first_rank_review.title}"
          end
        end
      end
    end

    describe '表示が入れ替わることの検証' do
      let!(:user) { create(:user) }
      let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
      let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
      let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }
      let!(:forth_rank_review) { create(:good_review, title: "楽しいlaravel入門") }
      let!(:fifth_rank_review) { create(:good_review, title: "楽しいrails入門") }
      let!(:sixth_rank_review) { create(:good_review, title: "楽しいpython入門") }
      let!(:seventh_rank_review) { create(:good_review, title: "楽しいdjango入門") }

      it '表示が入れ替わること', js: true do
        log_in_as(user.email, user.password)
        visit "/reviews/#{first_rank_review.id}"
        visit "/reviews/#{second_rank_review.id}"
        visit "/reviews/#{third_rank_review.id}"
        visit "/reviews/#{forth_rank_review.id}"
        visit "/reviews/#{fifth_rank_review.id}"
        visit "/reviews/#{sixth_rank_review.id}"
        within(".wrap-tab-content") do
          within(".recent-reviews") do
            within(".recent-review-#{first_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{first_rank_review.title}"
            end
            within(".recent-review-#{second_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
            end
            within(".recent-review-#{third_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{third_rank_review.title}"
            end
            within(".recent-review-#{forth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{forth_rank_review.title}"
            end
            within(".recent-review-#{fifth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{fifth_rank_review.title}"
            end
            within(".recent-review-#{sixth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{sixth_rank_review.title}"
            end
          end
        end
        visit "/reviews/#{seventh_rank_review.id}"
        within(".wrap-tab-content") do
          within(".recent-reviews") do
            expect(page).to have_no_selector 'div', class: "recent-review-#{first_rank_review.id}"
            expect(page).to have_no_selector 'a', text: "#{first_rank_review.title}"
            within(".recent-review-#{second_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
            end
            within(".recent-review-#{third_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{third_rank_review.title}"
            end
            within(".recent-review-#{forth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{forth_rank_review.title}"
            end
            within(".recent-review-#{fifth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{fifth_rank_review.title}"
            end
            within(".recent-review-#{sixth_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{sixth_rank_review.title}"
            end
            within(".recent-review-#{seventh_rank_review.id}") do
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              expect(page).to have_selector 'a', text: "#{seventh_rank_review.title}"
            end
          end
        end
      end
    end
  end
end
