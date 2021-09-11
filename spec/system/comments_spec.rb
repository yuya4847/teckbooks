require 'rails_helper'
RSpec.describe "Comments", type: :system do
  describe 'コメントの作成と削除' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:good_review) { create(:good_review) }
    let!(:normal_review) { create(:normal_review) }

    describe 'コメントすることができる' do
      context 'フォームの入力値が正常の場合' do
        it 'コメントとその削除がAjaxでできること', js: true do
          log_in_as(user.email, user.password)
          visit '/reviews/2'
          fill_in 'comment_form', with: "良いレビューですね！！"
          click_button 'コメント'
          expect(page).to have_content "1件コメント"
          expect(page).to have_content "#{user.username}"
          expect(page).to have_content "1分前"
          expect(page).to have_content "良いレビューですね！！"
          expect(page).to have_link "削除"
          expect(page).to have_selector 'textarea', id: "response_form1"
          expect(page).to have_button "返信"
          within('#res_cancel_btn') do
            expect(page).to have_button "キャンセル"
          end
          click_link '削除'
          expect(page).to have_content "1件コメント"
          expect(page).not_to have_content "#{user.username}"
          expect(page).not_to have_content "1分前"
          expect(page).not_to have_content "良いレビューですね！！"
          expect(page).not_to have_link "削除"
          expect(page).not_to have_selector 'textarea', id: "response_form1"
          expect(page).not_to have_button "返信"
          expect(page).to have_content "0件コメント"
          expect(page).not_to have_selector 'div', id: "res_cancel_btn"
        end
      end
      context '未記入の場合' do
        it 'エラーメッセージが出ること', js: true do
          log_in_as(user.email, user.password)
          visit '/reviews/2'
          fill_in 'comment_form', with: ""
          click_button 'コメント'
          expect(page).to have_content "0件コメント"
          within('#comments_error') do
            expect(page).to have_content "コメント内容を入力してください"
          end
        end
      end
      context '文字数オーバーの場合' do
        it 'エラーメッセージが出ること', js: true do
          log_in_as(user.email, user.password)
          visit '/reviews/2'
          fill_in 'comment_form', with: "a" * 51
          click_button 'コメント'
          expect(page).to have_content "0件コメント"
          within('#comments_error') do
            expect(page).to have_content "コメント内容は50文字以内で入力してください"
          end
        end
      end
    end

    describe '返信をすることができる' do
      context 'フォームの入力値が正常の場合' do
        it 'コメント(返信)とその削除がAjaxでできること', js: true do
          log_in_as(user.email, user.password)
          visit '/reviews/2'
          fill_in 'comment_form', with: "良いレビューですね！！"
          click_button 'コメント'
          fill_in "response_form1", with: "確かに良いレビューですね！！"
          click_button '返信'
          expect(page).to have_content "2件コメント"
          within("#response_content2") do
            expect(page).to have_content "#{user.username}"
            expect(page).to have_content "確かに良いレビューですね！！"
            expect(page).to have_link "返信を削除"
          end
          click_link '返信を削除'
          expect(page).to have_content "1件コメント"
          expect(page).not_to have_selector 'div', id: "response_content2"
        end

        it 'コメントを削除するとその返信も削除されること', js: true do
          log_in_as(user.email, user.password)
          visit '/reviews/2'
          fill_in 'comment_form', with: "良いレビューですね！！"
          click_button 'コメント'
          fill_in "response_form1", with: "確かに良いレビューですね！！"
          click_button '返信'
          expect(page).to have_content "2件コメント"
          click_link '削除'
          expect(page).to have_content "0件コメント"
          expect(page).not_to have_selector 'div', id: "response_content2"
        end
      end
      context '未記入の場合' do
        it 'エラーメッセージが出ること', js: true do
          log_in_as(user.email, user.password)
          visit '/reviews/2'
          fill_in 'comment_form', with: "良いレビューですね！！"
          click_button 'コメント'
          expect(page).to have_content "1件コメント"
          fill_in "response_form1", with: ""
          click_button '返信'
          expect(page).to have_content "1件コメント"
        end
      end
      context '文字数オーバーの場合' do
        it 'エラーメッセージが出ること', js: true do
          log_in_as(user.email, user.password)
          visit '/reviews/2'
          fill_in 'comment_form', with: "良いレビューですね！！"
          click_button 'コメント'
          expect(page).to have_content "1件コメント"
          fill_in "response_form1", with: "a" * 51
          click_button '返信'
          expect(page).to have_content "1件コメント"
        end
      end
    end

    describe 'コメントのキャンセルができる' do
      it 'コメントの記述をキャンセルできること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/2'
        fill_in 'comment_form', with: "良いレビューですね！！"
        within("#comments_buttons") do
          expect(page).to have_field 'comment[content]', with: '良いレビューですね！！'
        end
        within("#comments_buttons") do
          click_button 'キャンセル'
        end
        within("#comments_buttons") do
          expect(page).to have_field 'comment[content]', with: ''
        end
      end

      it 'コメント(返信)の記述をキャンセルできること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/2'
        fill_in 'comment_form', with: "良いレビューですね！！"
        click_button 'コメント'
        fill_in "response_form1", with: "確かに良いレビューですね！！"
        within("#response_area1") do
          expect(page).to have_field 'comment[content]', with: '確かに良いレビューですね！！'
        end
        within("#res_cancel_btn") do
          click_button 'キャンセル'
        end
        within("#response_area1") do
          expect(page).to have_field 'comment[content]', with: ''
        end
      end
    end
  end
end
