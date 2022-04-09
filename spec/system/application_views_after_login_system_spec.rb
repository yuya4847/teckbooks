require 'rails_helper'
RSpec.describe "ログイン後の共通表示を検証", type: :system do
  describe 'ヘッダーの要素検証' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:sample_first_review) { create(:good_review) }
    let!(:sample_second_review) { create(:good_review) }
    let!(:sample_third_review) { create(:good_review) }
    let!(:good_review) { create(:good_review) }

    it '自分のプロフィールページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{user.id}"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it '他者のプロフィールページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{second_user.id}"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'ネット検索ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it '全投稿一覧ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it '通知一覧ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/notifications"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it '検索ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'レビュー投稿ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/new"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'レビュー編集ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}/edit"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'プロフィール編集ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/users/edit"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'プロフィール投稿ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/profile_reviews/#{user.id}"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'DM一覧ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/dms"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'followingページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{user.id}/following"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'followersページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{user.id}/followers"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it '利用規約ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/homes/terms"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'プライバシーポリシーページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/homes/privacy_policy"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

    it 'DMルーム内ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{second_user.id}"
      find('.start-dm').click
      visit "/rooms/1"
      within(".header-btns") do
        expect(page).to have_selector 'a', class: "home-btn-logo-div"
        within(".header-menus") do
          expect(page).to have_selector 'a', text: "マイページ"
        end
      end
    end

  end

  describe 'サブヘッダーの要素検証' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:sample_first_review) { create(:good_review) }
    let!(:sample_second_review) { create(:good_review) }
    let!(:sample_third_review) { create(:good_review) }
    let!(:good_review) { create(:good_review) }

    it '自分のプロフィールページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{user.id}"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it '他者のプロフィールページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{second_user.id}"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it '全投稿一覧ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/all_reviews"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it '通知一覧ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/notifications"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it '検索ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'レビュー投稿ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/new"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'レビュー編集ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{good_review.id}/edit"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'プロフィール編集ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/users/edit"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'プロフィール投稿ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/profile_reviews/#{user.id}"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'DM一覧ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/dms"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'followingページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{user.id}/following"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'followersページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{user.id}/followers"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it '利用規約ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/homes/terms"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'プライバシーポリシーページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/homes/privacy_policy"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end

    it 'DMルーム内ページで、共通のテンプレートが表示されること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{second_user.id}"
      find('.start-dm').click
      visit "/rooms/1"
      within(".subheader-btns") do
        within(".subheader-menus") do
          expect(page).to have_selector('a', count: 4)
          expect(page).to have_selector 'div', text: "ネット検索"
          expect(page).to have_selector 'div', text: "投稿"
          expect(page).to have_selector 'span', text: "通知"
          expect(page).to have_selector 'div', text: "探す"
        end
        within(".subheader-review-up") do
          expect(page).to have_selector('a', count: 1)
          expect(page).to have_selector 'span', text: "レビューを投稿"
        end
      end
    end
  end
end
