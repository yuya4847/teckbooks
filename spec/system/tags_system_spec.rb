require 'rails_helper'
RSpec.describe "Tags", type: :system do
  describe 'タグの作成と編集' do
    let!(:user) { create(:user) }
    let!(:good_review) { build(:good_review) }

    describe '作成することができる' do
      it '単一のタグをつけてレビューが投稿できること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.reviwe-tag-link-class') do
          expect(page).to have_selector 'span', text: '#ruby'
        end
      end

      it '複数のタグをつけてレビューが投稿できること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby,Python,PHP"
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.all-reviews-content') do
          expect(page).to have_selector 'span', text: '#ruby'
          expect(page).to have_selector 'span', text: '#python'
          expect(page).to have_selector 'span', text: '#php'
        end
      end

      it '重複したタグを一つだけが投稿されること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby,Ruby,Ruby"
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.reviwe-tag-link-class') do
          expect(page).to have_selector 'span', text: '#ruby', count: 1
        end
      end
    end

    describe '編集することができる' do
      it 'タグを編集できること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.reviwe-tag-link-class') do
          expect(page).to have_selector 'span', text: '#ruby'
        end
        visit '/reviews/1/edit'
        tag_form = find('#review_tag_ids')
        expect(tag_form.value).to match 'ruby'
        fill_in 'review_tag_ids', with: "Ruby,Python"
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.all-reviews-content') do
          expect(page).to have_selector 'span', text: '#ruby'
          expect(page).to have_selector 'span', text: '#python'
        end
      end

      it '同じタグは追加できないこと' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.reviwe-tag-link-class') do
          expect(page).to have_selector 'span', text: '#ruby'
        end
        visit '/reviews/1/edit'
        tag_form = find('#review_tag_ids')
        expect(tag_form.value).to match 'ruby'
        fill_in 'review_tag_ids', with: "Ruby,Ruby,Ruby"
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.all-reviews-content') do
          expect(page).to have_content "ruby", count: 1
        end
      end

      it 'タグを削除できること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.reviwe-tag-link-class') do
          expect(page).to have_selector 'span', text: '#ruby'
        end
        visit '/reviews/1/edit'
        tag_form = find('#review_tag_ids')
        expect(tag_form.value).to match 'ruby'
        fill_in 'review_tag_ids', with: ""
        find('.post-review-btn').click
        visit "/reviews/1"
        within('.all-reviews-content') do
          expect(page).to have_no_content "ruby"
        end
      end
    end

    describe 'タグ付けがそれぞれのページに反映される' do
      it 'profile_reviewsページにタグの投稿が反映されること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        find('.post-review-btn').click
        visit '/userpages/profile_reviews/1'
        within('.mypage-review-content') do
          expect(page).to have_selector 'span', text: '#ruby'
        end
      end

      it 'all_reviewsページにタグの投稿が反映されること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        find('.post-review-btn').click
        visit '/all_reviews'
        within('.all-reviews-content') do
          expect(page).to have_selector 'span', text: '#ruby'
        end
      end

      it 'showページにタグの投稿が反映されること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        find('.post-review-btn').click
        visit '/reviews/1'
        within('.all-reviews-content') do
          expect(page).to have_content "#ruby"
        end
      end

      it 'レビュー検索ページにタグの投稿が反映されること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        find('.post-review-btn').click
        visit '/reviews'
        find('#ruby_search_tag').click
        within('.mypage-review-content') do
          expect(page).to have_selector 'span', text: '#ruby'
        end
      end
    end
  end
end
