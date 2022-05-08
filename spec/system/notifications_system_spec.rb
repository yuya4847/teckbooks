require 'rails_helper'
RSpec.describe "Notifications", type: :system do
  describe '通知の検証' do
    describe '通知ページの要素検証' do
      describe 'モーダルの要素検証' do
        let!(:user) { create(:user, id: 1) }

        it 'モーダルの検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit "/notifications"
          within('.notification-size') do
            find('.notification-all-delete-btn').click
          end
          within('.report_modal_content') do
            expect(page).to have_selector 'div', text: '本当に全て削除しますか？'
            expect(page).to have_selector 'div', text: '(※後から戻す事はできません)'
            within('.report_modal_btns') do
              expect(page).to have_selector 'label', text: 'キャンセル'
              expect(page).to have_selector 'a', text: '削除'
              find('.report-cancel-btn').click
            end
          end
          expect(page).to have_selector 'div', class: 'report_modal_content'
        end
      end

      describe '通知一覧の要素検証' do
        context '通知が存在する場合' do
          let!(:user) { create(:user, id: 1) }
          let!(:second_user) { create(:second_user, id: 2) }
          let!(:good_review) { create(:good_review, id: 1) }
          let!(:comment) { create(:comment, content: "abcdefghijklmnopqrstu", user_id: second_user.id, review_id: good_review.id, id: 1) }
          let!(:response_comment) { create(:comment, content: "abcdefghijklmnopqrstu", parent_id: comment.id, user_id: second_user.id, review_id: good_review.id, id: 2) }
          let!(:room) { create(:room, id: 1) }
          let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id, id: 1) }
          let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id, id: 2) }
          let!(:message) { create(:message, user_id: second_user.id, room_id: room.id, content: "abcdefghijklmnopqrstu", id: 1) }
          let!(:dm_message_notification) { create(:notification,
            visitor_id: second_user.id,
            visited_id: user.id,
            dm_message_id: message.id,
            action: "dm",
            checked: false,
            id: 1,
          )}

          let!(:like_notification) { create(:notification,
            visitor_id: second_user.id,
            visited_id: user.id,
            review_id: good_review.id,
            action: "like",
            checked: false,
            id: 2,
          )}

          let!(:report_notification) { create(:notification,
            visitor_id: second_user.id,
            visited_id: user.id,
            review_id: good_review.id,
            action: "report",
            checked: false,
            id: 3,
          )}

          let!(:follow_notification) { create(:notification,
            visitor_id: second_user.id,
            visited_id: user.id,
            action: "follow",
            checked: false,
            id: 4,
          )}

          let!(:comment_notification) { create(:notification,
            visitor_id: second_user.id,
            visited_id: user.id,
            review_id: good_review.id,
            comment_id: comment.id,
            action: "comment",
            checked: false,
            id: 5,
          )}

          let!(:response_comment_notification) { create(:notification,
            visitor_id: second_user.id,
            visited_id: user.id,
            review_id: good_review.id,
            response_comment_id: response_comment.id,
            action: "response_comment",
            checked: false,
            id: 6,
          )}

          let!(:recommend_notification) { create(:notification,
            visitor_id: second_user.id,
            visited_id: user.id,
            review_id: good_review.id,
            action: "recommend",
            checked: false,
            id: 7,
          )}

          it '通知一覧の要素検証をすること' do
            log_in_as(user.email, user.password)
            visit "/userpages/#{user.id}"
            within('.subheader-btns') do
              within('.subheader-menu-link-notify') do
                expect(page).to have_selector 'span', class: 'notification-red-mark', text: "7"
              end
            end
            visit "/notifications"
            within('.subheader-btns') do
              within('.subheader-menu-link-notify') do
                expect(page).to have_no_selector 'span', class: 'notification-red-mark', text: "7"
              end
            end
            within('.notification-size') do
              within('.notifications-header') do
                expect(page).to have_selector 'div', text: '通知'
                expect(page).to have_selector 'label', text: '全て削除'
              end
              within('.each-notifications') do
                within(".notification-#{recommend_notification.id}") do
                  within(".notification-each-left") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{recommend_notification.visitor.username}"
                    expect(page).to have_selector 'a', text: "あなたの投稿"
                    expect(page).to have_content 'あなたにリコメンドしました'
                  end
                  within(".notification-each-right") do
                    expect(page).to have_selector 'a', class: "notification-trash-icon"
                  end
                end
                within(".notification-#{response_comment_notification.id}") do
                  within(".notification-each-left") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{response_comment_notification.visitor.username}"
                    expect(page).to have_selector 'a', text: "あなたの投稿"
                    expect(page).to have_content "あなたのコメントにコメントしました"
                    expect(page).to have_content "abcdefg..."
                  end
                  within(".notification-each-right") do
                    expect(page).to have_selector 'a', class: "notification-trash-icon"
                  end
                end
                within(".notification-#{comment_notification.id}") do
                  within(".notification-each-left") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{comment_notification.visitor.username}"
                    expect(page).to have_selector 'a', text: "あなたの投稿"
                    expect(page).to have_content "にコメントしました"
                    expect(page).to have_content "abcdefghijklmnopq..."
                  end
                  within(".notification-each-right") do
                    expect(page).to have_selector 'a', class: "notification-trash-icon"
                  end
                end
                within(".notification-#{follow_notification.id}") do
                  within(".notification-each-left") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{follow_notification.visitor.username}"
                    expect(page).to have_content "があなたをフォローしました"
                  end
                  within(".notification-each-right") do
                    expect(page).to have_selector 'a', class: "notification-trash-icon"
                  end
                end
                within(".notification-#{report_notification.id}") do
                  within(".notification-each-left") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{report_notification.visitor.username}"
                    expect(page).to have_selector 'a', text: "あなたの投稿"
                    expect(page).to have_content "を通報しました"
                  end
                  within(".notification-each-right") do
                    expect(page).to have_selector 'a', class: "notification-trash-icon"
                  end
                end
                within(".notification-#{like_notification.id}") do
                  within(".notification-each-left") do
                  expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                  expect(page).to have_selector 'a', text: "#{like_notification.visitor.username}"
                  expect(page).to have_selector 'a', text: "あなたの投稿"
                  expect(page).to have_content "にいいねしました"
                  end
                  within(".notification-each-right") do
                    expect(page).to have_selector 'a', class: "notification-trash-icon"
                  end
                end
                within(".notification-#{dm_message_notification.id}") do
                  within(".notification-each-left") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{dm_message_notification.visitor.username}"
                    expect(page).to have_content "があなたにメッセージを送りました"
                    expect(page).to have_content "abcd..."
                  end
                  within(".notification-each-right") do
                    expect(page).to have_selector 'a', class: "notification-trash-icon"
                  end
                end
              end
            end
          end
        end

        context '通知が存在しない場合' do
          let!(:user) { create(:user, id: 1) }

          it '通知一覧の要素検証をすること', js: true do
            log_in_as(user.email, user.password)
            visit "/notifications"
            within('.notification-size') do
              within('.each-notifications') do
                expect(page).to have_selector 'div', text: "通知はありません"
              end
            end
          end
        end
      end
    end

    describe '通知の検証' do
      let!(:user) { create(:user, id: 1) }
      let!(:second_user) { create(:second_user, id: 2) }
      let!(:sample_first_review) { create(:good_review, user_id: second_user.id, id: 1) }
      let!(:sample_second_review) { create(:good_review, user_id: second_user.id, id: 2) }
      let!(:sample_third_review) { create(:good_review, user_id: second_user.id, id: 3) }
      let!(:first_review) { create(:good_review, user_id: user.id, id: 4) }
      let!(:second_review) { create(:good_review, user_id: user.id, id: 5) }

      it 'いいねの通知ができること', js: true do
        log_in_as(second_user.email, second_user.password)
        visit "/all_reviews"
        within("#review_#{first_review.id}") do
          find("#like_btn#{first_review.id}").click
        end
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          expect(page).to have_selector 'a', text: "#{second_user.username}"
          expect(page).to have_content "にいいねしました"
        end
      end

      it '再度のいいねは通知に反映されないこと', js: true do
        log_in_as(second_user.email, second_user.password)
        visit "/all_reviews"
        within("#review_#{first_review.id}") do
          find("#like_btn#{first_review.id}").click
        end
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}"
            expect(page).to have_content "にいいねしました"
          end
        end
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit "/all_reviews"
        within("#review_#{first_review.id}") do
          find("#not_like_btn#{first_review.id}").click
          find("#like_btn#{first_review.id}").click
        end
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}", count: 1
            expect(page).to have_content "にいいねしました", count: 1
          end
        end
      end

      it '通報の通知ができること', js: true do
        log_in_as(second_user.email, second_user.password)
        visit "/all_reviews"
        within("#review_#{first_review.id}") do
          find("#report-div-btn-#{first_review.id}").click
          find(".report-review-id-#{first_review.id}").click
        end
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}"
            expect(page).to have_content "を通報しました"
          end
        end
      end

      it 'フォローの通知ができること', js: true do
        log_in_as(second_user.email, second_user.password)
        visit "/all_reviews"
        within("#review_#{first_review.id}") do
          find("#follow-div#{first_review.id}").click
        end
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}"
            expect(page).to have_content "があなたをフォローしました"
          end
        end
      end

      it '再度のフォローは通知に反映されないこと', js: true do
        log_in_as(second_user.email, second_user.password)
        visit "/all_reviews"
        within("#review_#{first_review.id}") do
          find("#follow-div#{first_review.id}").click
        end
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}"
            expect(page).to have_content "があなたをフォローしました"
          end
        end
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit "/all_reviews"
        within("#review_#{first_review.id}") do
          find("#follow-div#{first_review.id}").click
          find("#follow-div#{first_review.id}").click
        end
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}", count: 1
            expect(page).to have_content "があなたをフォローしました", count: 1
          end
        end
      end

      it 'リコメンドの通知ができること', js: true do
        log_in_as(second_user.email, second_user.password)
        visit "/all_reviews"
        within("#review_#{first_review.id}") do
          within(".mypage-review-bottom-icons") do
            find(".recommend_review_id_#{first_review.id}").click
          end
        end
        find(".recommend_user_#{user.id}").click
        find(".recommend-btn-update").click
        find(".swal2-confirm").click
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}"
            expect(page).to have_selector 'a', text: "あなたの投稿"
          end
        end
      end

      it 'コメントの通知ができること', js: true do
        log_in_as(second_user.email, second_user.password)
        visit "/reviews/#{first_review.id}"
        fill_in 'FlexTextarea', with: "abcdefghijklmnopqrstu"
        find('#comment-btn-new-comment').click
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}"
            expect(page).to have_content "にコメントしました"
            expect(page).to have_content "abcdefghijklmnopq..."
          end
        end
      end

      it 'コメントの返信の通知ができること', js: true do
        log_in_as(user.email, user.password)
        visit "/reviews/#{first_review.id}"
        fill_in 'FlexTextarea', with: "abcdefghijklmnopqrstu"
        find('#comment-btn-new-comment').click
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit "/reviews/#{first_review.id}"
        find("#comment-response-id-#{Comment.last.id}").click
        within(".show-review-responses") do
          fill_in 'FlexTextarea', with: "ABCDEFGHIJKLMNOPQRSTU"
          find("#comment-responses-response-#{Comment.last.id}").click
        end
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
            expect(page).to have_selector 'a', text: "#{second_user.username}"
            expect(page).to have_selector 'a', text: "あなたの投稿"
            expect(page).to have_content "あなたのコメントにコメントしました"
            expect(page).to have_content "ABCDEFG..."
          end
        end
      end

      it 'メッセージの通知ができること', js: true do
        log_in_as(second_user.email, second_user.password)
        visit "/userpages/1"
        find('.start-dm').click
        fill_in 'message_form', with: "ABCDEFGHIJKLMNOPQRSTU"
        find(".dm-chat-form-btn").click
        click_link "ログアウト"
        log_in_as(user.email, user.password)
        visit "/notifications"
        within('.notification-size') do
          within('.each-notifications') do
            expect(page).to have_selector 'a', text: "#{second_user.username}"
            expect(page).to have_content "があなたにメッセージを送りました"
            expect(page).to have_content "ABCD..."
          end
        end
      end
    end

    describe '通知削除機能の検証' do
      context '通知を単体で削除する場合' do
        let!(:user) { create(:user, id: 1) }
        let!(:second_user) { create(:second_user, id: 2) }
        let!(:good_review) { create(:good_review, id: 1) }
        let!(:like_notification) { create(:notification,
          visitor_id: second_user.id,
          visited_id: user.id,
          review_id: good_review.id,
          action: "like",
          checked: false,
          id: 1,
        )}
        let!(:report_notification) { create(:notification,
          visitor_id: second_user.id,
          visited_id: user.id,
          review_id: good_review.id,
          action: "report",
          checked: false,
          id: 2,
        )}

        it '通知を単体で削除できること' do
          log_in_as(user.email, user.password)
          visit "/notifications"
          within('.notification-size') do
            within('.each-notifications') do
              within(".notification-#{like_notification.id}") do
                within(".notification-each-left") do
                expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                expect(page).to have_selector 'a', text: "#{like_notification.visitor.username}"
                expect(page).to have_selector 'a', text: "あなたの投稿"
                expect(page).to have_content "にいいねしました"
                end
                within(".notification-each-right") do
                  expect(page).to have_selector 'a', class: "notification-trash-icon"
                end
              end
              within(".notification-#{report_notification.id}") do
                within(".notification-each-left") do
                  expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                  expect(page).to have_selector 'a', text: "#{report_notification.visitor.username}"
                  expect(page).to have_selector 'a', text: "あなたの投稿"
                  expect(page).to have_content "を通報しました"
                end
                within(".notification-each-right") do
                  expect(page).to have_selector 'a', class: "notification-trash-icon"
                end
              end
              within(".notification-right-#{like_notification.id}") do
                find('.notification-trash-icon').click
              end
              expect(page).to have_no_selector 'div', class: ".notification-#{like_notification.id}"
              within(".notification-right-#{report_notification.id}") do
                find('.notification-trash-icon').click
              end
              expect(page).to have_no_selector 'div', class: ".notification-#{report_notification.id}"
            end
            within('.each-notifications') do
              expect(page).to have_selector 'div', text: "通知はありません"
            end
          end
        end
      end

      context '通知を一括で削除する場合' do
        let!(:user) { create(:user, id: 1) }
        let!(:second_user) { create(:second_user, id: 2) }
        let!(:good_review) { create(:good_review, id: 1) }
        let!(:like_notification) { create(:notification,
          visitor_id: second_user.id,
          visited_id: user.id,
          review_id: good_review.id,
          action: "like",
          checked: false,
          id: 1,
        )}
        let!(:report_notification) { create(:notification,
          visitor_id: second_user.id,
          visited_id: user.id,
          review_id: good_review.id,
          action: "report",
          checked: false,
          id: 2,
        )}

        it '通知を単体で削除できること' do
          log_in_as(user.email, user.password)
          visit "/notifications"
          within('.notification-size') do
            within('.each-notifications') do
              expect(page).to have_selector 'a', text: "#{like_notification.visitor.username}"
              expect(page).to have_content "にいいねしました"
              expect(page).to have_selector 'a', text: "#{report_notification.visitor.username}"
              expect(page).to have_content "を通報しました"
            end
            find('.notification-all-delete-btn').click
            find('.report-really-btn').click
            expect(page).to have_no_selector 'div', class: ".notification-#{like_notification.id}"
            expect(page).to have_no_selector 'div', class: ".notification-#{report_notification.id}"
            within('.each-notifications') do
              expect(page).to have_selector 'div', text: "通知はありません"
            end
          end
        end
      end
    end
  end
end
