require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "Comments", type: :system do
  describe 'コメントの検証' do
    describe 'コメントの検証' do
      let!(:user) { create(:user, id: 1) }
      let!(:second_user) { create(:second_user, id: 2) }
      let!(:good_review) { create(:good_review, id: 1) }
      let!(:normal_review) { create(:normal_review, id: 2) }

      describe '要素の検証' do
        it '要素検証をすること' do
          log_in_as(user.email, user.password)
          visit "/reviews/#{good_review.id}"
          within('.review-show-post') do
            expect(page).to have_selector 'div', class: 'show-review-comments-count', text: "0件コメント"
            within('.review-show-new-comment') do
              within('.review-show-post-icon') do
                expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              end
              within('.show-review-form_with') do
                within('.FlexTextarea') do
                  expect(page).to have_selector 'textarea', id: "FlexTextarea"
                end
                within('.review-show-new-btns') do
                  expect(page).to have_selector 'div', id: "review-show-new-comment-cancel-btn"
                  expect(page).to have_selector 'input', class: "review-show-new-comment-bt"
                end
              end
            end
          end
        end
      end

      describe 'キャンセル機能の検証' do
        it '途中までフォームに入力したコメントがキャンセルされること' do
          log_in_as(user.email, user.password)
          visit "/reviews/#{good_review.id}"
          comment_textarea = find('#FlexTextarea')
          expect(comment_textarea.value).to match ''
          fill_in 'FlexTextarea', with: "キャンセルされるコメント"
          expect(comment_textarea.value).to match 'キャンセルされるコメント'
          find('#review-show-new-comment-cancel-btn').click
          expect(comment_textarea.value).to match ''
        end
      end

      describe '投稿機能の検証' do
        context '未記入の場合' do
          it '未入力でコメントするとエラーが表示されること', js: true do
            log_in_as(user.email, user.password)
            visit "/reviews/#{good_review.id}"
            expect(page).to have_no_selector 'div', id: "comments_error", text: 'コメント内容を入力してください'
            fill_in 'FlexTextarea', with: ""
            find('.review-show-new-comment-bt').click
            expect(page).to have_selector 'div', id: "comments_error", text: 'コメント内容を入力してください'
          end
        end

        # 手動だと正しく表示されるが、system_specで文字入力を行うとスタイルが崩れる。
        # context '文字数オーバーの場合' do
        #   it '文字数オーバーでコメントするとエラーが表示されること' do
        #     log_in_as(user.email, user.password)
        #     visit '/reviews/1'
        #     expect(page).to have_no_selector 'div', id: "comments_error", text: 'コメント内容は500文字以内で入力してください'
        #     find('#comment-btn-new-comment').click
        #     expect(page).to have_selector 'div', id: "comments_error", text: 'コメント内容は500文字以内で入力してください'
        #   end
        # end

        context 'フォームの入力値が正常の場合' do
          context '自分のレビューに投稿する場合' do
            it '正しくコメントが投稿されること', js: true do
              log_in_as(user.email, user.password)
              visit "/reviews/#{good_review.id}"
              fill_in 'FlexTextarea', with: "aaaaa"
              find('.review-show-new-comment-bt').click
              within('.show-review-each-comment') do
                within('.review-show-post-icon') do
                  expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                end
                within('.show-review-each-comment-content') do
                  within('.show-review-each-content-sentences') do
                    expect(page).to have_selector 'a', text: "#{user.username}"
                    expect(page).to have_selector 'span', text: "#{time_ago_in_words(Comment.first.created_at).delete("約").delete("未満") }"
                    expect(page).to have_selector 'div', text: "aaaaa"
                  end
                  within('.show-review-each-delete-div') do
                    expect(page).to have_selector 'span', text: "返信"
                    expect(page).to have_selector 'a', text: "削除"
                  end
                end
              end
            end
          end

          context '他者のレビューに投稿する場合' do
            it '正しくコメントが投稿されること', js: true do
              log_in_as(second_user.email, second_user.password)
              visit "/reviews/#{good_review.id}"
              fill_in 'FlexTextarea', with: "aaaaa"
              find('.review-show-new-comment-bt').click
              within('.show-review-each-comment') do
                within('.review-show-post-icon') do
                  expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                end
                within('.show-review-each-comment-content') do
                  within('.show-review-each-content-sentences') do
                    expect(page).to have_selector 'a', text: "#{second_user.username}"
                    expect(page).to have_selector 'span', text: "#{time_ago_in_words(Comment.first.created_at).delete("約").delete("未満") }"
                    expect(page).to have_selector 'div', text: "aaaaa"
                  end
                  within('.show-review-each-delete-div') do
                    expect(page).to have_selector 'span', text: "返信"
                    expect(page).to have_selector 'a', text: "削除"
                  end
                end
              end
            end
          end
        end
      end

      describe '削除機能の検証' do
        it 'コメントを削除することができる', js: true do
          log_in_as(user.email, user.password)
          visit "/reviews/#{good_review.id}"
          fill_in 'FlexTextarea', with: "aaaaa"
          find('.review-show-new-comment-bt').click
          within('#comments_area') do
            find('.show-review-each-delete-btn').click
            sleep 1
            expect(page).to have_no_selector 'div', class: "show-review-each-comment"
          end
        end
      end
    end

    describe 'コメント返信機能の検証' do
      describe '要素の検証' do
        let!(:user) { create(:user, id: 1) }
        let!(:second_user) { create(:second_user, id: 2) }
        let!(:good_review) { create(:good_review, id: 1) }
        let!(:normal_review) { create(:normal_review, id: 2) }
        let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }
        let!(:response_comment) { create(:comment, user_id: user.id, review_id: good_review.id, parent_id: parent_comment.id, content: "bbbbb", id: 2) }

        it '要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit "/reviews/#{good_review.id}"
          within('.show-review-each-right') do
            within('.review-show-all-reponse-comments') do
              expect(page).to have_selector 'span', text: "返信の表示"
              find("#response-default-commnet-btn-id-#{parent_comment.id}").click
            end
            expect(page).to have_selector 'div', class: "response-reviews-default-comments-css"
            within("#response-default-display-commnet-btn-id-#{parent_comment.id}") do
              within('.response-reviews-response-each-comment') do
                expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                expect(page).to have_selector 'a', text: "#{user.username}"
                expect(page).to have_selector 'span', text: "#{time_ago_in_words(response_comment.created_at).delete("約").delete("未満") }"
                expect(page).to have_selector 'div', text: "bbbbb"
              end
              within('.response-each-comment-right-in-left') do
                expect(page).to have_selector 'span', text: "削除"
              end
            end
            within('.review-show-all-reponse-comments') do
              expect(page).to have_selector 'span', text: "返信の非表示"
              find("#response-default-commnet-btn-id-#{parent_comment.id}").click
            end
            expect(page).to have_no_selector 'div', class: "response-reviews-default-comments-css"
          end
        end
      end

      describe 'キャンセル機能の検証' do
        let!(:user) { create(:user, id: 1)}
        let!(:second_user) { create(:second_user, id: 2) }
        let!(:good_review) { create(:good_review, id: 1) }
        let!(:normal_review) { create(:normal_review, id: 2) }
        let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }

        it '要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit "/reviews/#{good_review.id}"
          within('.show-review-each-response-btn-div') do
            find('.show-review-each-response-btn').click
          end
          expect(page).to have_selector 'div', id: "comment-responses-#{parent_comment.id}"
          response_comment_textarea = find(".response-comment-form-#{parent_comment.id}")
          within("#comment-responses-#{parent_comment.id}") do
            fill_in 'FlexTextarea', with: "キャンセルされるレスポンスコメント"
            expect(response_comment_textarea.value).to match "キャンセルされるレスポンスコメント"
            find('.review-show-reponse-cancel-btn').click
          end
          expect(page).to have_no_selector 'div', id: "comment-responses-#{parent_comment.id}"
          within('.show-review-each-response-btn-div') do
            find('.show-review-each-response-btn').click
          end
          expect(page).to have_selector 'div', id: "comment-responses-#{parent_comment.id}"
          response_comment_textarea = find(".response-comment-form-#{parent_comment.id}")
          within("#comment-responses-#{parent_comment.id}") do
            fill_in 'FlexTextarea', with: "キャンセルされるレスポンスコメント"
            expect(response_comment_textarea.value).to match ''
          end
        end
      end

      describe '投稿機能の検証' do
        context '未記入の場合' do
          let!(:user) { create(:user, id: 1) }
          let!(:second_user) { create(:second_user, id: 2) }
          let!(:good_review) { create(:good_review, id: 1) }
          let!(:normal_review) { create(:normal_review, id: 2) }
          let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }

          it '未入力で返信するとエラーが表示されること', js: true do
            log_in_as(user.email, user.password)
            visit "/reviews/#{good_review.id}"
            within('.show-review-each-response-btn-div') do
              find('.show-review-each-response-btn').click
            end
            response_comment_textarea = find(".response-comment-form-#{parent_comment.id}")
            within("#comment-responses-#{parent_comment.id}") do
              fill_in 'FlexTextarea', with: ""
              find(".review-show-review-id-#{parent_comment.id}").click
              expect(page).to have_selector 'div', text: "・返信内容を入力してください"
            end
          end
        end

        context '文字数オーバーの場合' do
          let!(:user) { create(:user, id: 1) }
          let!(:second_user) { create(:second_user, id: 2) }
          let!(:good_review) { create(:good_review, id: 1) }
          let!(:normal_review) { create(:normal_review, id: 2) }
          let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }

          # 手動だと正しく表示されるが、system_specで文字入力を行うとスタイルが崩れる。
          # it '文字数オーバーで返信するとエラーが表示されること' do
          #   log_in_as(user.email, user.password)
          #   visit '/reviews/1'
          #   within('.show-review-each-response-btn-div') do
          #     find('.show-review-each-response-btn').click
          #   end
          #   response_comment_textarea = find(".response-comment-form-#{parent_comment.id}")
          #   within("#comment-responses-#{parent_comment.id}") do
          #     fill_in 'FlexTextarea', with: 'a' * 501
          #     find(".review-show-review-id-#{parent_comment.id}").click
          #     expect(page).to have_selector 'div', text: "・返信内容は500文字以内で入力してください"
          #   end
          # end
        end

        context 'フォームの入力値が正常の場合' do
          context '自分のレビューに投稿する場合' do
            context '自分のコメントに返信する場合' do
              let!(:user) { create(:user, id: 1) }
              let!(:second_user) { create(:second_user, id: 2) }
              let!(:good_review) { create(:good_review, id: 1) }
              let!(:parent_comment) { create(:comment, user_id: second_user.id, review_id: good_review.id, content: "aaaaa", id: 1) }

              it '正しくコメントが投稿されること', js: true do
                log_in_as(user.email, user.password)
                visit "/reviews/#{good_review.id}"
                within('.show-review-each-response-btn-div') do
                  find('.show-review-each-response-btn').click
                end
                response_comment_textarea = find(".response-comment-form-#{parent_comment.id}")
                within("#comment-responses-#{parent_comment.id}") do
                  fill_in 'FlexTextarea', with: 'ccccc'
                  find(".review-show-review-id-#{parent_comment.id}").click
                  expect(page).to have_no_selector 'div', class: "response_error_alert"
                end
                within(".response-reviews-comment-css") do
                  within(".response-reviews-response-each-comment") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{user.username}"
                    expect(page).to have_selector 'span', text: "1分前"
                    expect(page).to have_selector 'div', text: "ccccc"
                  end
                  within(".response-each-comment-right-in-left") do
                    expect(page).to have_selector 'span', text: "削除"
                  end
                end
              end
            end

            context '他人のコメントに返信する場合' do
              let!(:user) { create(:user, id: 1) }
              let!(:second_user) { create(:second_user, id: 2) }
              let!(:good_review) { create(:good_review, id: 1) }
              let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }

              it '正しくコメントが投稿されること', js: true do
                log_in_as(user.email, user.password)
                visit "/reviews/#{good_review.id}"
                within('.show-review-each-response-btn-div') do
                  find('.show-review-each-response-btn').click
                end
                response_comment_textarea = find(".response-comment-form-#{parent_comment.id}")
                within("#comment-responses-#{parent_comment.id}") do
                  fill_in 'FlexTextarea', with: 'ccccc'
                  find(".review-show-review-id-#{parent_comment.id}").click
                  expect(page).to have_no_selector 'div', class: "response_error_alert"
                end
                within(".response-reviews-comment-css") do
                  within(".response-reviews-response-each-comment") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{user.username}"
                    expect(page).to have_selector 'span', text: "1分前"
                    expect(page).to have_selector 'div', text: "ccccc"
                  end
                  within(".response-each-comment-right-in-left") do
                    expect(page).to have_selector 'span', text: "削除"
                  end
                end
              end
            end
          end

          context '他者のレビューに投稿する場合' do
            context '自分のコメントに返信する場合' do
              let!(:user) { create(:user, id: 1) }
              let!(:second_user) { create(:second_user, id: 2) }
              let!(:good_review) { create(:good_review, id: 1) }
              let!(:normal_review) { create(:normal_review, id: 2) }
              let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }
              let!(:second_parent_comment) { create(:comment, user_id: user.id, review_id: normal_review.id, content: "bbbbb", id: 2) }

              it '正しくコメントが投稿されること', js: true do
                log_in_as(user.email, user.password)
                visit "/reviews/#{normal_review.id}"
                within('.show-review-each-response-btn-div') do
                  find('.show-review-each-response-btn').click
                end
                response_comment_textarea = find(".response-comment-form-#{second_parent_comment.id}")
                within("#comment-responses-#{second_parent_comment.id}") do
                  fill_in 'FlexTextarea', with: 'ccccc'
                  find(".review-show-review-id-#{second_parent_comment.id}").click
                  expect(page).to have_no_selector 'div', class: "response_error_alert"
                end
                within(".response-reviews-comment-css") do
                  within(".response-reviews-response-each-comment") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{user.username}"
                    expect(page).to have_selector 'span', text: "1分前"
                    expect(page).to have_selector 'div', text: "ccccc"
                  end
                  within(".response-each-comment-right-in-left") do
                    expect(page).to have_selector 'span', text: "削除"
                  end
                end
              end
            end

            context '他人のコメントに返信する場合' do
              let!(:user) { create(:user, id: 1) }
              let!(:second_user) { create(:second_user, id: 2) }
              let!(:good_review) { create(:good_review, id: 1) }
              let!(:normal_review) { create(:normal_review, id: 2) }
              let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }
              let!(:second_parent_comment) { create(:comment, user_id: second_user.id, review_id: normal_review.id, content: "bbbbb", id: 2) }

              it '正しくコメントが投稿されること', js: true do
                log_in_as(user.email, user.password)
                visit "/reviews/#{normal_review.id}"
                within('.show-review-each-response-btn-div') do
                  find('.show-review-each-response-btn').click
                end
                response_comment_textarea = find(".response-comment-form-#{second_parent_comment.id}")
                within("#comment-responses-#{second_parent_comment.id}") do
                  fill_in 'FlexTextarea', with: 'ccccc'
                  find(".review-show-review-id-#{second_parent_comment.id}").click
                  expect(page).to have_no_selector 'div', class: "response_error_alert"
                end
                within(".response-reviews-comment-css") do
                  within(".response-reviews-response-each-comment") do
                    expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                    expect(page).to have_selector 'a', text: "#{user.username}"
                    expect(page).to have_selector 'span', text: "1分前"
                    expect(page).to have_selector 'div', text: "ccccc"
                  end
                  within(".response-each-comment-right-in-left") do
                    expect(page).to have_selector 'span', text: "削除"
                  end
                end
              end
            end
          end
        end
      end

      describe '削除機能の検証' do
        context '返信を単体で削除する場合' do
          let!(:user) { create(:user, id: 1) }
          let!(:second_user) { create(:second_user, id: 2) }
          let!(:good_review) { create(:good_review, id: 1) }
          let!(:normal_review) { create(:normal_review, id: 2) }
          let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }
          let!(:response_comment) { create(:comment, user_id: user.id, review_id: good_review.id, parent_id: parent_comment.id, content: "bbbbb", id: 2) }

          it '削除できること', js: true do
            log_in_as(user.email, user.password)
            visit "/reviews/#{good_review.id}"
            find("#response-default-commnet-btn-id-#{parent_comment.id}").click
            find(".response-comment-destroy-#{response_comment.id}").click
            expect(page).to have_no_selector 'div', class: "response-default-display-commnet-btn-id-#{response_comment.id}"
          end
        end

        context '親コメントの削除と同時に削除される場合' do
          let!(:user) { create(:user, id: 1) }
          let!(:second_user) { create(:second_user, id: 2) }
          let!(:good_review) { create(:good_review, id: 1) }
          let!(:normal_review) { create(:normal_review, id: 2) }
          let!(:parent_comment) { create(:comment, user_id: user.id, review_id: good_review.id, content: "aaaaa", id: 1) }
          let!(:response_comment) { create(:comment, user_id: user.id, review_id: good_review.id, parent_id: parent_comment.id, content: "bbbbb", id: 2) }

          it '両方とも削除できること', js: true do
            log_in_as(user.email, user.password)
            visit "/reviews/#{good_review.id}"
            find("#response-default-commnet-btn-id-#{parent_comment.id}").click
            expect(page).to have_selector 'div', class: "show-review-each-comment"
            find(".show-review-each-delete-btn").click
            expect(page).to have_no_selector 'div', class: "show-review-each-comment"
          end
        end
      end
    end
  end
end
