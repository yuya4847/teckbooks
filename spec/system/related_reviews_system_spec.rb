require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "関連した投稿機能の検証", type: :system do
  describe '全投稿一覧ページにおける関連した投稿機能の検証' do
    let!(:user) { create(:user) }
    let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }

    it '要素検証をすること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within(".wrap-tab") do
        within("#js-tab") do
          expect(page).to have_selector 'li', text: "関連した投稿"
        end
      end
    end

    it '関連した投稿が表示されないこと', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within(".wrap-tab-content") do
        expect(page).to have_selector 'div', text: "最近見た投稿はありません"
      end
      find(".related_reviews_class").click
      within(".wrap-tab-content") do
        expect(page).to have_no_selector 'div', text: "関連した投稿はありません"
      end
    end
  end

  describe '投稿詳細ページにおける関連した投稿機能の検証' do
    describe '関連した投稿機能の要素検証' do
      let!(:user) { create(:user) }
      let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
      let!(:second_rank_review) { create(:good_review, title: "素晴らしいrails入門") }
      let!(:ruby_tag) { create(:tag, name: "ruby") }
      let!(:first_ruby_tag_relationship) { create(:tag_relationship, review_id: first_rank_review.id, tag_id: ruby_tag.id) }
      let!(:second_ruby_tag_relationship) { create(:tag_relationship, review_id: second_rank_review.id, tag_id: ruby_tag.id) }

      it '要素検証をすること', js: true do
        log_in_as(user.email, user.password)
        visit "/reviews/#{first_rank_review.id}"
        within(".wrap-tab-content") do
          within(".recent-review-#{first_rank_review.id}") do
            expect(page).to have_selector('a', count: 2)
            expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
            expect(page).to have_selector 'a', text: "#{first_rank_review.title}"
          end
        end
        find('#related-review').click
        expect(page).to have_no_selector 'div', class: "recent-review-#{first_rank_review.id}"
        within(".wrap-tab-content") do
          within(".related-review-#{second_rank_review.id}") do
            expect(page).to have_selector('a', count: 2)
            expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
            expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
          end
        end
      end
    end

    describe '最近見た投稿機能の表示の検証' do
      context '表示されない場合' do
        let!(:user) { create(:user) }
        let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }

        it '投稿が表示さないこと', js: true do
          log_in_as(user.email, user.password)
          visit "/reviews/#{first_rank_review.id}"
          find('#related-review').click
          within(".wrap-tab-content") do
            expect(page).to have_content "関連した投稿はありません"
          end
        end
      end

      context '表示される場合' do
        let!(:user) { create(:user) }
        let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
        let!(:second_rank_review) { create(:good_review, title: "素晴らしいrails入門") }
        let!(:ruby_tag) { create(:tag, name: "ruby") }
        let!(:first_ruby_tag_relationship) { create(:tag_relationship, review_id: first_rank_review.id, tag_id: ruby_tag.id) }
        let!(:second_ruby_tag_relationship) { create(:tag_relationship, review_id: second_rank_review.id, tag_id: ruby_tag.id) }

        it '投稿が表示されること', js: true do
          log_in_as(user.email, user.password)
          visit "/reviews/#{first_rank_review.id}"
          find('#related-review').click
          within(".wrap-tab-content") do
            expect(page).to have_no_content "関連した投稿はありません"
            within(".related-review-#{second_rank_review.id}") do
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
      let!(:fifth_rank_review) { create(:good_review, title: "楽しいpython入門") }
      let!(:sixth_rank_review) { create(:good_review, title: "楽しいdjango入門") }
      let!(:seventh_rank_review) { create(:good_review, title: "楽しいaws入門") }
      let!(:ruby_tag) { create(:tag, name: "ruby") }
      let!(:first_ruby_tag_relationship) { create(:tag_relationship, review_id: first_rank_review.id, tag_id: ruby_tag.id) }
      let!(:second_ruby_tag_relationship) { create(:tag_relationship, review_id: second_rank_review.id, tag_id: ruby_tag.id) }
      let!(:third_ruby_tag_relationship) { create(:tag_relationship, review_id: third_rank_review.id, tag_id: ruby_tag.id) }
      let!(:forth_ruby_tag_relationship) { create(:tag_relationship, review_id: forth_rank_review.id, tag_id: ruby_tag.id) }
      let!(:fifth_ruby_tag_relationship) { create(:tag_relationship, review_id: fifth_rank_review.id, tag_id: ruby_tag.id) }
      let!(:sixth_ruby_tag_relationship) { create(:tag_relationship, review_id: sixth_rank_review.id, tag_id: ruby_tag.id) }
      let!(:seventh_ruby_tag_relationship) { create(:tag_relationship, review_id: seventh_rank_review.id, tag_id: ruby_tag.id) }

      it '6投稿が表示の限界であること', js: true do
        log_in_as(user.email, user.password)
        visit "/reviews/#{first_rank_review.id}"
        find('#related-review').click
        within(".wrap-tab-content") do
          expect(page).to have_no_selector 'div', class: "related-review-#{first_rank_review.id}"
          expect(page).to have_no_selector 'a', text: "#{first_rank_review.title}"
          within(".related-review-#{second_rank_review.id}") do
            expect(page).to have_selector('a', count: 2)
            expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
            expect(page).to have_selector 'a', text: "#{second_rank_review.title}"
          end
          within(".related-review-#{third_rank_review.id}") do
            expect(page).to have_selector('a', count: 2)
            expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
            expect(page).to have_selector 'a', text: "#{third_rank_review.title}"
          end
          within(".related-review-#{forth_rank_review.id}") do
            expect(page).to have_selector('a', count: 2)
            expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
            expect(page).to have_selector 'a', text: "#{forth_rank_review.title}"
          end
          within(".related-review-#{fifth_rank_review.id}") do
            expect(page).to have_selector('a', count: 2)
            expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
            expect(page).to have_selector 'a', text: "#{fifth_rank_review.title}"
          end
          within(".related-review-#{sixth_rank_review.id}") do
            expect(page).to have_selector('a', count: 2)
            expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
            expect(page).to have_selector 'a', text: "#{sixth_rank_review.title}"
          end
          within(".related-review-#{seventh_rank_review.id}") do
            expect(page).to have_selector('a', count: 2)
            expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
            expect(page).to have_selector 'a', text: "#{seventh_rank_review.title}"
          end
        end
      end
    end
  end
end
