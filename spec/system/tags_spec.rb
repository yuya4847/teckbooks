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
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        click_button 'レビューを投稿する'
        within('#userpage_review_tags') do
          expect(page).to have_content "ruby"
        end
      end

      it '複数のタグをつけてレビューが投稿できること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby,Python,PHP"
        click_button 'レビューを投稿する'
        within('#userpage_review_tags') do
          expect(page).to have_content "ruby"
          expect(page).to have_content "python"
          expect(page).to have_content "php"
        end
      end

      it '重複したタグを一つだけが投稿されること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby,Ruby,Ruby"
        click_button 'レビューを投稿する'
        within('#userpage_review_tags') do
          expect(page).to have_content "ruby", count: 1
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
        click_button 'レビューを投稿する'
        within('#userpage_review_tags') do
          expect(page).to have_content "ruby"
        end
        visit '/reviews/1/edit'
        tag_form = find('#review_tag_ids')
        expect(tag_form.value).to match 'ruby'
        fill_in 'review_tag_ids', with: "Ruby,Python"
        click_button '編集完了'
        within('#userpage_review_tags') do
          expect(page).to have_content "ruby"
          expect(page).to have_content "python"
        end
      end

      it '同じタグは追加できないこと' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        click_button 'レビューを投稿する'
        within('#userpage_review_tags') do
          expect(page).to have_content "ruby"
        end
        visit '/reviews/1/edit'
        tag_form = find('#review_tag_ids')
        expect(tag_form.value).to match 'ruby'
        fill_in 'review_tag_ids', with: "Ruby,Ruby,Ruby"
        click_button '編集完了'
        within('#userpage_review_tags') do
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
        click_button 'レビューを投稿する'
        within('#userpage_review_tags') do
          expect(page).to have_content "ruby"
        end
        visit '/reviews/1/edit'
        tag_form = find('#review_tag_ids')
        expect(tag_form.value).to match 'ruby'
        fill_in 'review_tag_ids', with: ""
        click_button '編集完了'
        within('#userpage_review_tags') do
          expect(page).to have_no_content "ruby"
        end
      end
    end

    describe 'タグ付けがそれぞれのページに反映される' do
      it 'userpageページにタグの投稿が反映されること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        click_button 'レビューを投稿する'
        within('#userpage_review_tags') do
          expect(page).to have_content "ruby"
        end
      end

      it 'all_reviewsページにタグの投稿が反映されること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        click_button 'レビューを投稿する'
        click_link "全ての投稿"
        within('#all_review_tags') do
          expect(page).to have_content "ruby"
        end
      end

      it 'showページにタグの投稿が反映されること' do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: good_review.title
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        fill_in 'review_tag_ids', with: "Ruby"
        click_button 'レビューを投稿する'
        click_link "#{good_review.title}"
        within('#show_review_tags') do
          expect(page).to have_content "ruby"
        end
      end
    end
  end
end
