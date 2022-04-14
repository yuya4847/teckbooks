require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "DmRooms", type: :system do
  describe 'DMルーム一覧の要素検証' do
    context 'ルームが存在しない1場合' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }

      it '要素検証をすること', js: true do
        log_in_as(user.email, user.password)
        visit '/dms'
        within(".dm-rooms-frame") do
          within(".dm-rooms-title") do
            expect(page).to have_selector 'div', text: "DM"
          end
          within(".dm-rooms-scroll") do
            expect(page).to have_selector 'div', text: "DMはありません"
          end
        end
      end
    end

    context 'ルームが存在する場合' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:third_user) { create(:third_user) }
      let!(:user_and_second_user_room) { create(:room) }
      let!(:user_and_second_user_room_entry1) { create(:entry, user_id: user.id, room_id: user_and_second_user_room.id) }
      let!(:user_and_second_user_room_entry2) { create(:entry, user_id: second_user.id, room_id: user_and_second_user_room.id) }
      let!(:user_and_third_user_room) { create(:room) }
      let!(:user_and_third_user_roomentry1) { create(:entry, user_id: user.id, room_id: user_and_third_user_room.id) }
      let!(:user_and_third_user_room_entry2) { create(:entry, user_id: third_user.id, room_id: user_and_third_user_room.id) }
      let!(:message) { create(:message, content: "メッセージ", user_id: user.id, room_id: user_and_third_user_room.id) }

      it '要素検証をすること', js: true do
        log_in_as(user.email, user.password)
        visit '/dms'
        within(".dm-rooms-frame") do
          within(".dm-rooms-scroll") do
            within(".each-dm-room-#{user_and_second_user_room.id}") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'span', text: "#{second_user.username}"
              expect(page).to have_selector 'span', text: "#{time_ago_in_words(user_and_second_user_room.created_at).delete("約").delete("未満")}前"
            end
            within(".each-dm-room-#{user_and_third_user_room.id}") do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'span', text: "#{third_user.username}"
              expect(page).to have_selector 'span', text: "#{message.content}"
              expect(page).to have_selector 'span', text: "#{time_ago_in_words(user_and_third_user_room.created_at).delete("約").delete("未満")}前"
            end
          end
        end
      end
    end
  end

  describe 'DMルーム一覧の表示の検証' do
    context 'ルームを追加する場合' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }

      it 'ルームが追加されること', js: true do
        log_in_as(user.email, user.password)
        visit '/dms'
        within(".dm-rooms-frame") do
          within(".dm-rooms-scroll") do
            expect(page).to have_no_selector 'a', class: "each-dm-room-1"
          end
        end
        visit "/userpages/#{second_user.id}"
        find('.start-dm').click
        visit '/dms'
        within(".dm-rooms-frame") do
          within(".dm-rooms-scroll") do
            expect(page).to have_selector 'a', class: "each-dm-room-1"
          end
        end
      end
    end

    context 'すでにルームが存在する場合' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:user_and_second_user_room) { create(:room) }
      let!(:user_and_second_user_room_entry1) { create(:entry, user_id: user.id, room_id: user_and_second_user_room.id) }
      let!(:user_and_second_user_room_entry2) { create(:entry, user_id: second_user.id, room_id: user_and_second_user_room.id) }

      it 'ルーム一覧に変化がないこと', js: true do
        log_in_as(user.email, user.password)
        visit '/dms'
        within(".dm-rooms-frame") do
          within(".dm-rooms-scroll") do
            expect(page).to have_selector 'a', class: "each-dm-room-#{user_and_second_user_room.id}"
          end
        end
        visit "/userpages/#{second_user.id}"
        find('.to-dm').click
        find('.dm-chat-back-icon-div').click
        within(".dm-rooms-frame") do
          within(".dm-rooms-scroll") do
            expect(page).to have_selector 'a', class: "each-dm-room-#{user_and_second_user_room.id}"
          end
        end
      end
    end

    context 'ルームを削除する場合' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:user_and_second_user_room) { create(:room) }
      let!(:user_and_second_user_room_entry1) { create(:entry, user_id: user.id, room_id: user_and_second_user_room.id) }
      let!(:user_and_second_user_room_entry2) { create(:entry, user_id: second_user.id, room_id: user_and_second_user_room.id) }

      it 'ルームが削除されていること', js: true do
        log_in_as(user.email, user.password)
        visit '/dms'
        within(".dm-rooms-frame") do
          within(".dm-rooms-scroll") do
            expect(page).to have_selector 'a', class: "each-dm-room-#{user_and_second_user_room.id}"
          end
        end
        find(".each-dm-room-#{user_and_second_user_room.id}").click
        find('.help_icon').click
        find('.tooltips').click
        visit '/dms'
        within(".dm-rooms-frame") do
          within(".dm-rooms-scroll") do
            expect(page).to have_no_selector 'a', class: "each-dm-room-#{user_and_second_user_room.id}"
          end
        end
      end
    end
  end
end
