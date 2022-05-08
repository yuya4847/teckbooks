require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "Homes_before_login", type: :system do
  describe 'ログイン前のトップページの検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:sample_user) { create(:second_user, email: "example@samp.com", id: 2) }
    let!(:recent_review) { create(:recent_review, id: 1) }
    let!(:good_review) { create(:good_review, id: 2) }
    let!(:great_review) { create(:great_review, id: 3) }

    it 'トップページの要素検証すること', js: true do
      visit '/'
      within('.header') do
        expect(page).to have_selector 'a', text: 'ログイン'
      end
      within('.home-title-part') do
        expect(page).to have_selector 'label', text: '今すぐ始める'
        expect(page).to have_selector 'label', text: 'サインアップ'
      end
      within('.sample-review-left') do
        expect(page).to have_selector 'img', class: "user-logo-home"
        expect(page).to have_selector 'span', text: "#{user.username}"
        expect(page).to have_selector 'div', text: "#{recent_review.title}"
        expect(page).to have_selector 'div', text: "#{ApplicationController.helpers.truncate(recent_review.content, length: 45)}"
        expect(page).to have_selector 'div', text: "#{I18n.l(recent_review.created_at)}"
      end
      within('.sample-review-center') do
        expect(page).to have_selector 'img', class: "user-logo-home"
        expect(page).to have_selector 'span', text: "#{user.username}"
        expect(page).to have_selector 'div', text: "#{good_review.title}"
        expect(page).to have_selector 'div', text: "#{ApplicationController.helpers.truncate(good_review.content, length: 45)}"
        expect(page).to have_selector 'div', text: "#{I18n.l(good_review.created_at)}"
      end
      within('.sample-review-right') do
        expect(page).to have_selector 'img', class: "user-logo-home"
        expect(page).to have_selector 'span', text: "#{user.username}"
        expect(page).to have_selector 'div', text: "#{great_review.title}"
        expect(page).to have_selector 'div', text: "#{ApplicationController.helpers.truncate(great_review.content, length: 45)}"
        expect(page).to have_selector 'div', text: "#{I18n.l(great_review.created_at)}"
      end
      within('#footer') do
        expect(page).to have_selector 'a', text: '利用規約'
        expect(page).to have_selector 'a', text: 'プライバシーポリシー'
        expect(page).to have_selector 'a', class: 'footer-sentence-link-in'
        expect(page).to have_selector("a[href$='https://twitter.com/0je3EP7f4PZPpLm']")
      end
      find(".now-start-btn").click
      within('.now-signup-modal-link') do
        expect(page).to have_selector 'a', text: 'プライバシーポリシー'
      end
      within('.modal-guest-login-checkboxes') do
        expect(page).to have_selector("label[for$='register-checkbox-now']")
      end
      within('.terms-consent-links-guest-login') do
        expect(page).to have_selector 'label', class: 'consent-link-cancel'
        expect(page).to have_selector 'a', text: "ゲストログイン"
      end
      find(".consent-link-cancel").click
      find(".signup-btn").click
      within('.signup-modal-link') do
        expect(page).to have_selector 'a', text: 'プライバシーポリシー'
      end
      within('.modal-sing-up-checkboxes') do
        expect(page).to have_selector("label[for$='register-checkbox']")
      end
      within('.terms-consent-links-signup') do
        expect(page).to have_selector 'label', class: 'consent-link-cancel'
        expect(page).to have_selector 'a', text: "登録する"
      end
    end

    it 'リンクの動作確認をすること', js: true do
      visit '/'
      find(".header-login").click
      expect(current_path).to eq new_user_session_path
      visit '/'
      click_link "利用規約"
      expect(current_path).to eq show_terms_path
      visit '/'
      click_link "プライバシーポリシー"
      expect(current_path).to eq show_privacy_policy_path
      visit '/'
      find('.sample-review-left').click
      expect(current_path).to eq guest_sign_in_review_show_path(recent_review.id)
      click_link "ログアウト"
      visit '/'
      find('.sample-review-center').click
      expect(current_path).to eq guest_sign_in_review_show_path(good_review.id)
      click_link "ログアウト"
      visit '/'
      find('.sample-review-right').click
      expect(current_path).to eq guest_sign_in_review_show_path(great_review.id)
    end

    it 'モーダル内のリンクの動作確認をすること' do
      visit '/'
      find('.consent-link-resister-display-none').click
      expect(current_path).to eq userpage_path(sample_user.id)
      click_link "ログアウト"
      visit '/'
      find('.consent-link-signup-display-none').click
      expect(current_path).to eq new_user_registration_path
    end
  end

  describe 'ログイン前の利用規約ページの検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:sample_user) { create(:second_user, email: "example@samp.com", id: 2) }
    let!(:recent_review) { create(:recent_review, id: 1) }
    let!(:good_review) { create(:good_review, id: 2) }
    let!(:great_review) { create(:great_review, id: 3) }

    it '利用規約ページの要素検証すること', js: true do
      visit '/'
      click_link "利用規約"
      expect(current_path).to eq show_terms_path
      expect(page).to have_selector 'div', text: "利用規約"
      expect(page).to have_selector 'a', text: 'プライバシーポリシー', class: 'privacy-link'
    end
  end

  describe 'ログイン前のプライバシーポリシーページの検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:sample_user) { create(:second_user, email: "example@samp.com", id: 2) }
    let!(:recent_review) { create(:recent_review, id: 1) }
    let!(:good_review) { create(:good_review, id: 2) }
    let!(:great_review) { create(:great_review, id: 3) }

    it 'プライバシーポリシーページの要素検証すること', js: true do
      visit '/'
      click_link "プライバシーポリシー"
      expect(current_path).to eq show_privacy_policy_path
      expect(page).to have_selector 'div', text: "プライバシーポリシー"
    end
  end
end
