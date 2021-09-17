require 'rails_helper'
RSpec.describe "DmMessages", type: :system do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }

  describe 'DMを送ることができる' do
    context "roomが存在する場合" do
      it 'DMを相互に送ることができること', js: true do
        log_in_as(user.email, user.password)
        visit '/userpages/2'
        click_button "チャットを始める"
        expect(current_path).to eq room_path(1)
        expect(page).to have_content 'DM'
        expect(page).to have_link "#{user.username}"
        expect(page).to have_link "#{second_user.username}"
        fill_in 'message_form', with: "こんにちは"
        click_button "送信"
        expect(current_path).to eq room_path(1)
        expect(page).to have_content "こんにちは"
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        expect(current_path).to eq userpage_path(2)
        expect(page).to have_content "#{user.username}"
        click_link "チャットへ"
        expect(page).to have_content "こんにちは"
        fill_in 'message_form', with: "こちらこそこんにちは"
        click_button "送信"
        expect(page).to have_content "こちらこそこんにちは"
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        click_link "チャットへ"
        expect(page).to have_content "こちらこそこんにちは"
      end

      it 'DMroomを削除できること' do
        log_in_as(user.email, user.password)
        visit '/userpages/2'
        click_button "チャットを始める"
        click_link "プロフィール"
        expect(page).to have_content "#{second_user.username}"
        expect(page).to have_link "チャットへ"
        expect(page).to have_link "削除"
        click_link "削除"
        within('.notice') do
          expect(page).to have_content 'DMを削除しました。'
        end
        expect(page).to have_no_content "#{second_user.username}"
        expect(page).to have_no_link "チャットへ"
        expect(page).to have_no_link "削除"
      end
    end

    context "roomが存在しない場合" do
      it 'DMページを閲覧できないこと' do
        log_in_as(user.email, user.password)
        visit '/rooms/2'
        expect(current_path).to eq root_path
        within('.alert') do
          expect(page).to have_content 'メッセージはありません'
        end
      end
    end
  end
end
