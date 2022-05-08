require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "DmMessages", type: :system do
  describe 'DMルーム内の要素検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:second_user) { create(:second_user, id: 2) }
    let!(:room) { create(:room, id: 1) }
    let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id, id: 1) }
    let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id, id: 2) }
    let!(:user_message) { create(:message, content: "自分のメッセージ", user_id: user.id, room_id: room.id, id: 1) }
    let!(:second_user_message) { create(:message, content: "相手のメッセージ", user_id: second_user.id, room_id: room.id, id: 2) }

    it '要素検証をすること' do
      log_in_as(user.email, user.password)
      visit "/rooms/#{room.id}"
      within(".dm-chat-frame") do
        within(".dm-chat-titles") do
          expect(page).to have_selector 'a', class: "dm-chat-back-icon-div"
          expect(page).to have_selector 'img', class: "icon-image-class", count: 2
          expect(page).to have_selector 'div', class: "help_icon"
        end
        within(".dm-chat-content") do
          expect(page).to have_selector 'div', text: "#{I18n.l(room.created_at)}"
          within(".dm-chat-message-each-currentuser") do
            expect(page).to have_selector("a[href$='/userpages/1']")
            expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
            expect(page).to have_content "#{user_message.content}"
            expect(page).to have_selector 'span', text: "#{time_ago_in_words(user_message.created_at).delete("約").delete("未満")}前"
          end
          within(".dm-chat-message-each-user") do
            expect(page).to have_selector("a[href$='/userpages/2']")
            expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
            expect(page).to have_content "#{second_user_message.content}"
            expect(page).to have_selector 'span', text: "#{time_ago_in_words(second_user_message.created_at).delete("約").delete("未満")}前"
          end
        end
        within(".dm-chat-form") do
          expect(page).to have_selector 'input', id: "message_form"
          expect(page).to have_selector("input[value$='送信']")
        end
      end
    end
  end

  describe 'メッセージ送信に関する検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:second_user) { create(:second_user, id: 2) }
    let!(:recent_review) { create(:recent_review, id: 1) }
    let!(:good_review) { create(:good_review, id: 2) }
    let!(:great_review) { create(:great_review, id: 3) }

    it '相互にメッセージを送りあえること', js: true do
      log_in_as(user.email, user.password)
      visit "/userpages/#{second_user.id}"
      find('.start-dm').click
      fill_in 'message_form', with: 'こんにちは'
      find('.dm-chat-form-btn').click
      within(".dm-chat-content") do
        within(".dm-chat-message-each-currentuser") do
          expect(page).to have_selector("a[href$='/userpages/1']")
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_content "こんにちは"
          expect(page).to have_selector 'span', text: "1分前"
        end
      end
      click_link 'ログアウト'
      log_in_as(second_user.email, second_user.password)
      find('.mypage-profile-dm-btn').click
      find(".each-dm-room-#{Room.last.id}").click
      within(".dm-chat-content") do
        within(".dm-chat-message-each-user") do
          expect(page).to have_selector("a[href$='/userpages/1']")
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_content "こんにちは"
          expect(page).to have_selector 'span', text: "1分前"
        end
      end
      fill_in 'message_form', with: 'こちらこそこんにちは'
      find('.dm-chat-form-btn').click
      within(".dm-chat-content") do
        within(".dm-chat-message-each-currentuser") do
          expect(page).to have_selector("a[href$='/userpages/2']")
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_content "こちらこそこんにちは"
          expect(page).to have_selector 'span', text: "1分前"
        end
      end
      click_link 'ログアウト'
      log_in_as(user.email, user.password)
      find('.mypage-profile-dm-btn').click
      find(".each-dm-room-#{Room.last.id}").click
      within(".dm-chat-content") do
        within(".dm-chat-message-each-user") do
          expect(page).to have_selector("a[href$='/userpages/2']")
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_content "こちらこそこんにちは"
          expect(page).to have_selector 'span', text: "1分前"
        end
      end
    end
  end
end
