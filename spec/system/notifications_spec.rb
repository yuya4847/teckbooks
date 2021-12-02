require 'rails_helper'
RSpec.describe "Notifications", type: :system do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }
  let!(:good_review) { create(:good_review, user_id: user.id) }

  describe '通知ができる' do
    it '通知一覧画面の要素検証ができること', js: true do
      log_in_as(user.email, user.password)
      visit '/reviews/1'
      fill_in 'comment_form', with: "良いレビューですね！！"
      click_button 'コメント'
      click_link "ログアウト"
      log_in_as(second_user.email, second_user.password)
      visit '/all_reviews'
      within(".like_class#{good_review.id}") do
        click_button 'Like'
      end
      visit '/userpages/1'
      click_button 'Follow'
      visit '/reviews/1'
      fill_in 'comment_form', with: "レビューに対するコメントです。"
      click_button 'コメント'
      fill_in "response_form1", with: "レビューに対するレスポンスコメントです。"
      within("#response_area1") do
        click_button '返信'
      end
      visit '/all_reviews'
      within("#review_#{good_review.id}") do
        find('.open_modal').click()
      end
      within("#review_#{good_review.id}") do
        within('.recommend_modal_body') do
          find(".recommend_user_#{user.id}").click()
        end
      end
      find(".recommend_send").click()
      find(".swal2-confirm").click()
      visit '/all_reviews'
      find("#open_report_modal_#{good_review.id}").click
      expect(page).to have_selector("input[value$='通報']")
      click_on '通報'
      visit '/userpages/1'
      click_button "チャットを始める"
      fill_in 'message_form', with: "こんにちはuserさん"
      click_button "送信"
      click_link "ログアウト"
      log_in_as(user.email, user.password)
      visit '/notifications'
      expect(page).to have_selector 'div', text: '全て削除', class: 'open_report_modal'
      within(".notification-1") do
        have_link "#{user.username}"
        have_link "あなたの投稿"
        expect(page).to have_content 'にコメントしました。'
        expect(page).to have_content '良いレビューですね！！'
        have_link "削除"
      end
      within(".notification-2") do
        have_link "#{second_user.username}"
        have_link "あなたの投稿"
        expect(page).to have_content 'にいいねしました'
        have_link "削除"
      end
      within(".notification-3") do
        have_link "#{second_user.username}"
        expect(page).to have_content 'があなたをフォローしました'
        have_link "削除"
      end
      within(".notification-4") do
        have_link "#{second_user.username}"
        have_link "あなたの投稿"
        expect(page).to have_content 'にコメントしました。'
        expect(page).to have_content 'レビューに対するコメントです。'
        have_link "削除"
      end
      within(".notification-5") do
        have_link "#{second_user.username}"
        have_link "#{good_review.title}"
        expect(page).to have_content 'のあなたのコメントにコメントしました。'
        expect(page).to have_content 'レビューに対するレスポンスコメントです。'
        have_link "削除"
      end
      within(".notification-6") do
        have_link "#{second_user.username}"
        have_link "#{good_review.title}"
        expect(page).to have_content 'をあなたにリコメンドしました。'
        have_link "削除"
      end
      within(".notification-7") do
        have_link "#{second_user.username}"
        have_link "あなたの投稿"
        expect(page).to have_content 'を通報しました。'
        have_link "削除"
      end
      within(".notification-8") do
        have_link "#{second_user.username}"
        expect(page).to have_content 'があなたにメッセージを送りました。'
        expect(page).to have_content 'こんにちはuserさん'
        have_link "削除"
      end
    end

    it '通知一覧の全削除ができること', js: true do
      log_in_as(second_user.email, second_user.password)
      visit '/all_reviews'
      within(".like_class#{good_review.id}") do
        click_button 'Like'
      end
      visit '/userpages/1'
      click_button 'Follow'
      click_link "ログアウト"
      log_in_as(user.email, user.password)
      visit '/notifications'
      within(".notification-1") do
        have_link "#{second_user.username}"
        have_link "あなたの投稿"
        expect(page).to have_content 'にいいねしました'
        have_link "削除"
      end
      within(".notification-2") do
        have_link "#{second_user.username}"
        expect(page).to have_content 'があなたをフォローしました'
        have_link "削除"
      end
      find(".open_report_modal").click()
      click_link '本当に全て削除する'
      expect(page).to have_no_content 'にいいねしました'
      expect(page).to have_no_content 'があなたをフォローしました'
      expect(page).to have_content '通知はありません'
    end

    it '通知一覧の削除ができること', js: true do
      log_in_as(second_user.email, second_user.password)
      visit '/all_reviews'
      within(".like_class#{good_review.id}") do
        click_button 'Like'
      end
      visit '/userpages/1'
      click_button 'Follow'
      click_link "ログアウト"
      log_in_as(user.email, user.password)
      visit '/notifications'
      within(".notification-1") do
        have_link "#{second_user.username}"
        have_link "あなたの投稿"
        expect(page).to have_content 'にいいねしました'
        have_link "削除"
      end
      within(".notification-2") do
        have_link "#{second_user.username}"
        expect(page).to have_content 'があなたをフォローしました'
        have_link "削除"
      end
      have_link '全て削除'
      within(".notification-1") do
        click_link '削除'
      end
      expect(page).to have_no_content 'にいいねしました'
      within(".notification-2") do
        click_link '削除'
      end
      expect(page).to have_no_content 'があなたをフォローしました'
      expect(page).to have_content '通知はありません'
      expect(page).to have_no_content '全て削除'
    end

    it '通知が表示されること' do
      log_in_as(second_user.email, second_user.password)
      visit '/all_reviews'
      within(".like_class#{good_review.id}") do
        click_button 'Like'
      end
      click_link "ログアウト"
      log_in_as(user.email, user.password)
      within(".notification-link") do
        expect(page).to have_selector 'span', class: 'notify-red-icon', text: '1'
      end
      click_link '通知'
      within(".notification-link") do
        expect(page).to have_no_selector 'span', class: 'notify-red-icon', text: '1'
      end
    end

    it '通知一覧画面の要素検証ができること', js: true do
      log_in_as(second_user.email, second_user.password)
      visit '/all_reviews'
      within(".like_class#{good_review.id}") do
        click_button 'Like'
      end
      visit '/userpages/1'
      click_button 'Follow'
      visit '/reviews/1'
      fill_in 'comment_form', with: "レビューに対するコメントです。"
      click_button 'コメント'
      visit '/reviews/1'
      fill_in 'comment_form', with: "レビューに対するコメントでsssす。"
      click_button 'コメント'
      visit '/all_reviews'
      find("#open_report_modal_#{good_review.id}").click
      expect(page).to have_selector("input[value$='通報']")
      click_on '通報'
      visit '/all_reviews'
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end
  end
end
