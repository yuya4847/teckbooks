require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "Reviews", type: :system do
  describe 'レビューの投稿・表示に関する検証' do
    describe 'レビューの投稿・表示ページの要素検証' do
      context 'ページ内にページネーションが存在しない場合' do
        let!(:user) { create(:user) }
        let!(:good_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:ruby_tag) { create(:tag, name: "ruby") }
        let!(:ruby_tag_relationship) { create(:tag_relationship, review_id: good_review.id, tag_id: ruby_tag.id) }
        let!(:php_tag) { create(:tag, name: "php") }
        let!(:php_tag_relationship) { create(:tag_relationship, review_id: good_review.id, tag_id: php_tag.id) }

        it 'レビュー投稿ページの要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit '/reviews/new'
          within(".post-review-area") do
            within(".post-review-big") do
              within(".post-review-big-title-label") do
                expect(page).to have_content "投稿"
              end
              within(".post-review-big-title-form") do
                expect(page).to have_selector 'div', text: "レビューを投稿"
              end
            end
            within(".post-review-title") do
              within(".post-review-title-label") do
                expect(page).to have_content "タイトル"
              end
              within(".post-review-title-form") do
                expect(page).to have_selector 'input', id: "review_title"
              end
            end
            within(".post-review-rate") do
              within(".post-review-rate-label") do
                expect(page).to have_content "評価"
              end
              within(".post-review-rate-form") do
                within(".stars") do
                  expect(page).to have_selector('svg', count: 5)
                end
              end
            end
            within(".post-review-content") do
              within(".post-review-content-label") do
                expect(page).to have_content "レビュー・感想"
              end
              within(".post-review-content-form") do
                expect(page).to have_selector 'textarea', id: "review_content"
              end
            end
            within(".post-review-link") do
              within(".post-review-link-label") do
                expect(page).to have_content "リンク"
              end
              within(".post-review-link-form") do
                expect(page).to have_selector 'input', id: "review_link"
              end
            end
            within(".post-review-tag") do
              within(".post-review-tag-label") do
                expect(page).to have_content "タグ"
              end
              within(".post-review-tag-form") do
                expect(page).to have_selector 'textarea', id: "review_tag_ids"
              end
            end
            within(".post-review-image") do
              within(".post-review-image-label") do
                expect(page).to have_content "画像"
              end
              within(".post-review-image-form") do
                expect(page).to have_selector 'label', text: "画像を選択"
              end
            end
            within(".post-review-btn-div") do
              expect(page).to have_selector("input[value$='投稿']")
            end
          end
        end

        it 'レビュー編集ページの要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit "/reviews/#{good_review.id}"
          within('.show-review-related-links') do
            click_link '編集'
          end
          expect(current_path).to eq edit_review_path(good_review.id)
          within(".post-review-area") do
            within(".post-review-big") do
              within(".post-review-big-title-label") do
                expect(page).to have_content "編集"
              end
              within(".post-review-big-title-form") do
                expect(page).to have_selector 'div', text: "レビューを編集"
              end
            end
            within(".post-review-title") do
              within(".post-review-title-label") do
                expect(page).to have_content "タイトル"
              end
              within(".post-review-title-form") do
                title_form = find('#review_title')
                expect(title_form.value).to match "#{good_review.title}"
                expect(page).to have_selector 'input', id: "review_title"
              end
            end
            within(".post-review-rate") do
              within(".post-review-rate-label") do
                expect(page).to have_content "評価"
              end
              within(".post-review-rate-form") do
                expect(page).to have_selector('svg', count: 5)
              end
            end
            within(".post-review-content") do
              within(".post-review-content-label") do
                expect(page).to have_content "レビュー・感想"
              end
              within(".post-review-content-form") do
                content_form = find('#review_content')
                expect(content_form.value).to match "#{good_review.content}"
                expect(page).to have_selector 'textarea', id: "review_content"
              end
            end
            within(".post-review-link") do
              within(".post-review-link-label") do
                expect(page).to have_content "リンク"
              end
              within(".post-review-link-form") do
                link_form = find('#review_link')
                expect(link_form.value).to match "#{good_review.link}"
                expect(page).to have_selector 'input', id: "review_link"
              end
            end
            within(".post-review-tag") do
              within(".post-review-tag-label") do
                expect(page).to have_content "タグ"
              end
              within(".post-review-tag-form") do
                tag_form = find('#review_tag_ids')
                expect(tag_form.value).to match "#{ruby_tag.name},#{php_tag.name}"
                expect(page).to have_selector 'textarea', id: "review_tag_ids"
              end
            end
            within(".post-review-image") do
              within(".post-review-image-label") do
                expect(page).to have_content "画像"
              end
              within(".post-review-image-form") do
                expect(page).to have_selector 'label', text: "画像を選択"
              end
            end
            within(".post-review-btn-div") do
              expect(page).to have_selector("input[value$='編集完了']")
            end
          end
        end

        it '投稿詳細ページの要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit "/reviews/#{good_review.id}"
          within('.review-show-center') do
            within('.review-show-post') do
              within('.review-show-post-header') do
                within('.review-show-post-names') do
                  expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                  expect(page).to have_selector 'div', text: "#{user.username}"
                  expect(page).to have_selector 'div', text: "Since #{user.created_at.strftime("%Y/%m/%d")}"
                end
                within('.review-show-post-follows') do
                  expect(page).to have_selector 'div', text: "1PV"
                end
              end
              within('.all-reviews-stars') do
                expect(page).to have_selector('svg', count: 3)
              end
              within('.review-show-title-pv') do
                expect(page).to have_content "#{good_review.title}"
                within('.show-review-related-links') do
                  expect(page).to have_selector 'a', text: "編集"
                  expect(page).to have_selector 'a', text: "削除"
                end
              end
              within('.all-reviews-content') do
                expect(page).to have_content "#{good_review.content}"
                expect(page).to have_selector 'span', text: "##{ruby_tag.name}"
                expect(page).to have_selector 'span', text: "##{php_tag.name}"
              end
              within('.review-show-link-div') do
                expect(page).to have_selector 'span', class: "review-show-link"
              end
              within('.review-show-post-img') do
                expect(page).to have_selector 'div', text: "𝙉𝙤 𝙄𝙢𝙖𝙜𝙚"
              end
              within('.show-review-bottom') do
                within('.mypage-review-bottom-icons') do
                  expect(page).to have_selector 'div', id: "like-div#{good_review.id}"
                  expect(page).to have_selector 'label', class: "mypage-reviews-recommend-icon"
                  expect(page).to have_selector 'div', id: "report-div-btn-#{good_review.id}"
                end
                expect(page).to have_selector 'div', text: "#{I18n.l(good_review.created_at)}"
              end
            end
          end
        end
      end

      context 'ページ内にページネーションが存在する場合' do
        let!(:user) { create(:user) }
        let!(:first_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:second_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:third_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:forth_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:fifth_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:sixth_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:seventh_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:eighth_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:ninth_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:tenth_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:eleven_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:twelve_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }
        let!(:thirteen_review) { create(:good_review, rate: 3, title: "Goodガイド", content: "Goodガイド面白い", link: "https://good.jp/") }

        let!(:ruby_tag) { create(:tag, name: "ruby") }
        let!(:ruby_tag_relationship) { create(:tag_relationship, review_id: thirteen_review.id, tag_id: ruby_tag.id) }
        let!(:php_tag) { create(:tag, name: "php") }
        let!(:php_tag_relationship) { create(:tag_relationship, review_id: thirteen_review.id, tag_id: php_tag.id) }


        it '全投稿一覧ページの要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit '/all_reviews'
          within("#review_#{thirteen_review.id}") do
            within('.all-reviews-post-names-div') do
              within('.all-reviews-post-name-titles') do
                expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                expect(page).to have_selector 'div', text: "#{user.username}"
                expect(page).to have_selector 'span', text: "Since #{user.created_at.strftime("%Y/%m/%d")}"
              end
            end
            within(".all-reviews-stars") do
              expect(page).to have_selector('svg', count: 3)
            end
            within(".all-reviews-content") do
              expect(page).to have_content "#{thirteen_review.content}"
              expect(page).to have_selector('a', count: 2)
              expect(page).to have_selector 'span', text: "#{ruby_tag.name}"
              expect(page).to have_selector 'span', text: "#{php_tag.name}"
            end
            within(".all-reviews-detail-link") do
              expect(page).to have_selector('a', count: 1)
              within(".all-review-to-detail") do
                expect(page).to have_selector 'span', text: "投稿詳細へ"
              end
            end
            within(".mypage-review-bottom") do
              within(".mypage-review-bottom-icons") do
                expect(page).to have_selector 'div', id: "like-div#{thirteen_review.id}"
                expect(page).to have_selector 'label', class: "mypage-reviews-recommend-icon"
                expect(page).to have_selector 'div', id: "report-div-btn-#{thirteen_review.id}"
              end
              expect(page).to have_content "#{I18n.l(thirteen_review.created_at)}"
            end
          end
        end

        it '全投稿一覧ページのページネーションの要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit '/all_reviews'
          within('.all-reviews-left') do
            expect(page).to have_selector('.each-review', count: 6)
          end
          within('.pagination') do
            expect(page).to have_no_selector("a[rel$='prev']")
            expect(page).to have_selector 'span', class: 'current', text: '1'
            expect(page).to have_selector 'a', text: '2'
            expect(page).to have_selector 'a', text: '3'
            expect(page).to have_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
          within('.next') do
            find('.translation_missing').click
          end
          sleep 1
          within('.pagination') do
            expect(page).to have_selector("a[rel$='prev']")
            expect(page).to have_selector 'a', text: '1'
            expect(page).to have_selector 'span', class: 'current', text: '2'
            expect(page).to have_selector 'a', text: '3'
            expect(page).to have_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
          within('.next') do
            find('.translation_missing').click
          end
          sleep 1
          within('.pagination') do
            expect(page).to have_selector("a[rel$='prev']")
            expect(page).to have_selector 'a', text: '1'
            expect(page).to have_selector 'a', text: '2'
            expect(page).to have_selector 'span', class: 'current', text: '3'
            expect(page).to have_no_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
          within('.prev') do
            find('.translation_missing').click
          end
          sleep 1
          within('.pagination') do
            expect(page).to have_selector("a[rel$='prev']")
            expect(page).to have_selector 'a', text: '1'
            expect(page).to have_selector 'span', class: 'current', text: '2'
            expect(page).to have_selector 'a', text: '3'
            expect(page).to have_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
          within('.prev') do
            find('.translation_missing').click
          end
          sleep 1
          within('.pagination') do
            expect(page).to have_no_selector("a[rel$='prev']")
            expect(page).to have_selector 'span', class: 'current', text: '1'
            expect(page).to have_selector 'a', text: '2'
            expect(page).to have_selector 'a', text: '3'
            expect(page).to have_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
        end

        it 'ユーザーのレビューページの要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit "/userpages/profile_reviews/#{user.id}"
          within(".mypage-reviews-post-#{thirteen_review.id}") do
            within(".mypage-reviews-post-names-div") do
              within(".mypage-reviews-post-names") do
                expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
                expect(page).to have_selector 'div', text: "#{user.username}"
                expect(page).to have_selector 'span', text: "Since #{user.created_at.strftime("%Y-%m-%d")}"
              end
            end
            within(".mypage-reviews-stars") do
              expect(page).to have_selector('svg', count: 3)
            end
            within(".mypage-review-content") do
              expect(page).to have_content "#{thirteen_review.content}"
              expect(page).to have_selector 'span', text: "#{ruby_tag.name}"
              expect(page).to have_selector 'span', text: "#{php_tag.name}"
            end
            within(".mypage-review-bottom") do
              within(".mypage-review-bottom-icons") do
                expect(page).to have_selector("i[class$='mypage-reviews-comment-icon']")
                expect(page).to have_selector("i[class$='mypage-reviews-recommend-icon']")
                expect(page).to have_selector("i[class$='mypage-reviews-like-icon']")
              end
              expect(page).to have_content "#{I18n.l(thirteen_review.created_at)}"
            end
          end
        end

        it 'ユーザーのレビューページのページネーションの要素検証をすること', js: true do
          log_in_as(user.email, user.password)
          visit "/userpages/profile_reviews/#{user.id}"
          within('.mypage-reviews-posts') do
            expect(page).to have_selector('.mypage-reviews-post', count: 6)
          end
          within('.pagination') do
            expect(page).to have_no_selector("a[rel$='prev']")
            expect(page).to have_selector 'span', class: 'current', text: '1'
            expect(page).to have_selector 'a', text: '2'
            expect(page).to have_selector 'a', text: '3'
            expect(page).to have_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
          within('.next') do
            find('.translation_missing').click
          end
          within('.pagination') do
            expect(page).to have_selector("a[rel$='prev']")
            expect(page).to have_selector 'a', text: '1'
            expect(page).to have_selector 'span', class: 'current', text: '2'
            expect(page).to have_selector 'a', text: '3'
            expect(page).to have_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
          within('.next') do
            find('.translation_missing').click
          end
          within('.pagination') do
            expect(page).to have_selector("a[rel$='prev']")
            expect(page).to have_selector 'a', text: '1'
            expect(page).to have_selector 'a', text: '2'
            expect(page).to have_selector 'span', class: 'current', text: '3'
            expect(page).to have_no_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
          within('.prev') do
            find('.translation_missing').click
          end
          within('.pagination') do
            expect(page).to have_selector("a[rel$='prev']")
            expect(page).to have_selector 'a', text: '1'
            expect(page).to have_selector 'span', class: 'current', text: '2'
            expect(page).to have_selector 'a', text: '3'
            expect(page).to have_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
          within('.prev') do
            find('.translation_missing').click
          end
          within('.pagination') do
            expect(page).to have_no_selector("a[rel$='prev']")
            expect(page).to have_selector 'span', class: 'current', text: '1'
            expect(page).to have_selector 'a', text: '2'
            expect(page).to have_selector 'a', text: '3'
            expect(page).to have_selector("a[rel$='next']")
            expect(page).to have_selector('.page', count: 3)
          end
        end
      end
    end

    describe 'レビューの投稿機能の検証' do
      context 'フォームの値が不適切な場合' do
        context '必要な値が空白の場合' do
          let!(:user) { create(:user) }

          it 'エラーが発生し、投稿できないこと', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews/new'
            find('.post-review-btn').click
            expect(current_path).to eq reviews_path
            within(".post-review-errors") do
               expect(page).to have_selector 'div', class: 'post-review-error', text: '・ タイトルを入力してください'
               expect(page).to have_selector 'div', class: 'post-review-error', text: '・ 内容を入力してください'
            end
          end
        end
        context '必要な値が文字数超えしている場合' do
          let!(:user) { create(:user) }

          it 'エラーが発生し、投稿できないこと', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews/new'
            fill_in 'review_title', with: 'a' * 51
            fill_in 'review_content', with: 'a' * 251
            find('.post-review-btn').click
            expect(current_path).to eq reviews_path
            within(".post-review-errors") do
               expect(page).to have_selector 'div', class: 'post-review-error', text: '・ タイトルは50文字以内で入力してください'
               expect(page).to have_selector 'div', class: 'post-review-error', text: '・ 内容は250文字以内で入力してください'
            end
          end
        end
      end
      context 'フォームの値が適切な場合' do
        context '最低限必要な情報のみの場合' do
          let!(:user) { create(:user) }

          it '投稿できること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews/new'
            fill_in 'review_title', with: 'Rails チュートリアル'
            fill_in 'review_content', with: 'Rails チュートリアルは面白い'
            find('.post-review-btn').click
            expect(current_path).to eq userpage_path(user.id)
            within('.notice') do
              expect(page).to have_content 'レビューを投稿しました'
            end
          end
        end
        context '最低限必要な情報以外の情報を含む場合' do
          let!(:user) { create(:user) }

          it '投稿できること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews/new'
            fill_in 'review_title', with: 'Rails チュートリアル'
            find('.star-forth').click
            fill_in 'review_content', with: 'Rails チュートリアルは面白い'
            fill_in 'review_link', with: 'https://www.amazon.co.jp/'
            fill_in 'review_tag_ids', with: 'ruby,php'
            attach_file 'review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg", make_visible: true
            find('.post-review-btn').click
            expect(current_path).to eq userpage_path(user.id)
            within('.notice') do
              expect(page).to have_content 'レビューを投稿しました'
            end
          end
        end
      end
    end

    describe '投稿したレビューが各ページで適切で表示されていることの検証' do
      let!(:user) { create(:user) }

      it '投稿が反映されること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: 'Rails チュートリアル'
        find('.star-forth').click
        fill_in 'review_content', with: 'Rails チュートリアルは面白い'
        fill_in 'review_link', with: 'https://www.amazon.co.jp/'
        fill_in 'review_tag_ids', with: 'ruby,php'
        attach_file 'review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg", make_visible: true
        find('.post-review-btn').click
        expect(current_path).to eq userpage_path(user.id)
        within('.notice') do
          expect(page).to have_content 'レビューを投稿しました'
        end
        visit '/all_reviews'
        within("#review_1") do
          expect(page).to have_content "#{user.username}"
          expect(page).to have_content 'Rails チュートリアルは面白い'
          expect(page).to have_content '#ruby'
          expect(page).to have_content '#php'
          within('.all-reviews-stars') do
            expect(page).to have_selector('svg', count: 4)
          end
        end
        visit '/reviews/1'
        within(".review-show-post") do
          expect(page).to have_content "#{user.username}"
          within('.all-reviews-stars') do
            expect(page).to have_selector('svg', count: 4)
          end
          expect(page).to have_content 'Rails チュートリアルは面白い'
          expect(page).to have_content '#ruby'
          expect(page).to have_content '#php'
          expect(page).to have_content 'https://www.amazon.co.jp/'
          expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
        end
        visit '/userpages/profile_reviews/1'
        within(".mypage-reviews-post-1") do
          expect(page).to have_content "#{user.username}"
          within('.mypage-reviews-stars') do
            expect(page).to have_selector('svg', count: 4)
          end
          expect(page).to have_content 'Rails チュートリアルは面白い'
          expect(page).to have_content '#ruby'
          expect(page).to have_content '#php'
        end
      end
    end

    describe 'レビューの編集機能の検証' do
      context 'フォームの値が不適切な場合' do
        context '必要な値が空白の場合' do
          let!(:user) { create(:user) }

          it 'エラーが発生し、投稿できないこと', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews/new'
            fill_in 'review_title', with: 'Rails チュートリアル'
            fill_in 'review_content', with: 'Rails チュートリアルは面白い'
            find('.post-review-btn').click
            visit '/reviews/1'
            click_link '編集'
            fill_in 'review_title', with: ''
            fill_in 'review_content', with: ''
            find('.post-review-btn').click
            within(".post-review-errors") do
               expect(page).to have_selector 'div', class: 'post-review-error', text: '・ タイトルを入力してください'
               expect(page).to have_selector 'div', class: 'post-review-error', text: '・ 内容を入力してください'
            end
          end
        end

        context '必要な値が文字数超えしている場合' do
          let!(:user) { create(:user) }

          it 'エラーが発生し、投稿できないこと', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews/new'
            fill_in 'review_title', with: 'Rails チュートリアル'
            fill_in 'review_content', with: 'Rails チュートリアルは面白い'
            find('.post-review-btn').click
            visit '/reviews/1'
            click_link '編集'
            fill_in 'review_title', with: 'a' * 51
            fill_in 'review_content', with: 'a' * 251
            find('.post-review-btn').click
            within(".post-review-errors") do
               expect(page).to have_selector 'div', class: 'post-review-error', text: '・ タイトルは50文字以内で入力してください'
               expect(page).to have_selector 'div', class: 'post-review-error', text: '・ 内容は250文字以内で入力してください'
            end
          end
        end
      end

      context 'フォームの値が適切な場合' do
        context '最低限必要な情報のみの場合' do
          let!(:user) { create(:user) }

          it '編集できること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews/new'
            fill_in 'review_title', with: 'Rails チュートリアル'
            fill_in 'review_content', with: 'Rails チュートリアルは面白い'
            find('.post-review-btn').click
            visit '/reviews/1'
            click_link '編集'
            fill_in 'review_title', with: '編集後のRails チュートリアル'
            fill_in 'review_content', with: '編集後のRails チュートリアルは面白い'
            find('.post-review-btn').click
            expect(current_path).to eq userpage_path(user.id)
            within('.notice') do
              expect(page).to have_content '投稿を編集しました'
            end
          end
        end

        context '最低限必要な情報以外の情報を含む場合' do
          let!(:user) { create(:user) }

          it '編集できること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews/new'
            fill_in 'review_title', with: 'Rails チュートリアル'
            fill_in 'review_content', with: 'Rails チュートリアルは面白い'
            find('.post-review-btn').click
            visit '/reviews/1'
            click_link '編集'
            fill_in 'review_title', with: '編集後のRails チュートリアル'
            find('.star-fifth').click
            fill_in 'review_content', with: '編集後のRails チュートリアルは面白い'
            fill_in 'review_link', with: 'https://www.amazon.co.jp/'
            fill_in 'review_tag_ids', with: 'ruby,php'
            attach_file 'review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg", make_visible: true
            find('.post-review-btn').click
            expect(current_path).to eq userpage_path(user.id)
            within('.notice') do
              expect(page).to have_content '投稿を編集しました'
            end
          end
        end
      end
    end

    describe '編集したレビューが各ページで適切で表示されていることの検証' do
      let!(:user) { create(:user) }

      it '編集が反映されること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: 'Python チュートリアル'
        find('.star-first').click
        fill_in 'review_content', with: 'Python チュートリアルは面白い'
        fill_in 'review_link', with: 'https://www.amazon-site.co.jp/'
        fill_in 'review_tag_ids', with: 'python,django'
        find('.post-review-btn').click
        expect(current_path).to eq userpage_path(user.id)
        within('.notice') do
          expect(page).to have_content 'レビューを投稿しました'
        end
        visit '/all_reviews'
        within("#review_1") do
          expect(page).to have_content "#{user.username}"
          expect(page).to have_content 'Python チュートリアルは面白い'
          expect(page).to have_content '#python'
          expect(page).to have_content '#django'
          within('.all-reviews-stars') do
            expect(page).to have_selector('svg', count: 1)
          end
        end
        visit '/reviews/1'
        within(".review-show-post") do
          expect(page).to have_content "#{user.username}"
          within('.all-reviews-stars') do
            expect(page).to have_selector('svg', count: 1)
          end
          expect(page).to have_content 'Python チュートリアル'
          expect(page).to have_content 'Python チュートリアルは面白い'
          expect(page).to have_content '#python'
          expect(page).to have_content '#django'
          expect(page).to have_content 'https://www.amazon-site.co.jp/'
        end
        visit '/userpages/profile_reviews/1'
        within(".mypage-reviews-post-1") do
          expect(page).to have_content "#{user.username}"
          within('.mypage-reviews-stars') do
            expect(page).to have_selector('svg', count: 1)
          end
          expect(page).to have_content 'Python チュートリアルは面白い'
          expect(page).to have_content '#python'
          expect(page).to have_content '#django'
        end
        visit '/reviews/1'
        click_link '編集'
        fill_in 'review_title', with: 'Rails チュートリアル'
        find('.star-fifth').click
        fill_in 'review_content', with: 'Rails チュートリアルは面白い'
        fill_in 'review_link', with: 'https://www.amazon.co.jp/'
        fill_in 'review_tag_ids', with: 'ruby,php'
        attach_file 'review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg", make_visible: true
        find('.post-review-btn').click
        expect(current_path).to eq userpage_path(user.id)
        within('.notice') do
          expect(page).to have_content '投稿を編集しました'
        end
        visit '/all_reviews'
        within("#review_1") do
          expect(page).to have_content "#{user.username}"
          expect(page).to have_content 'Rails チュートリアルは面白い'
          expect(page).to have_content '#ruby'
          expect(page).to have_content '#php'
          within('.all-reviews-stars') do
            expect(page).to have_selector('svg', count: 5)
          end
        end
        visit '/reviews/1'
        within(".review-show-post") do
          expect(page).to have_content "#{user.username}"
          within('.all-reviews-stars') do
            expect(page).to have_selector('svg', count: 5)
          end
          expect(page).to have_content 'Rails チュートリアル'
          expect(page).to have_content 'Rails チュートリアルは面白い'
          expect(page).to have_content '#ruby'
          expect(page).to have_content '#php'
          expect(page).to have_content 'https://www.amazon.co.jp/'
          expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
        end
        visit '/userpages/profile_reviews/1'
        within(".mypage-reviews-post-1") do
          expect(page).to have_content "#{user.username}"
          within('.mypage-reviews-stars') do
            expect(page).to have_selector('svg', count: 5)
          end
          expect(page).to have_content 'Rails チュートリアルは面白い'
          expect(page).to have_content '#ruby'
          expect(page).to have_content '#php'
        end
      end
    end

    describe 'レビューの削除機能の検証' do
      let!(:user) { create(:user) }

      it 'レビューを削除できること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: 'Python チュートリアル'
        find('.star-first').click
        fill_in 'review_content', with: 'Python チュートリアルは面白い'
        fill_in 'review_link', with: 'https://www.amazon-site.co.jp/'
        fill_in 'review_tag_ids', with: 'python,django'
        find('.post-review-btn').click
        expect(current_path).to eq userpage_path(user.id)
        within('.notice') do
          expect(page).to have_content 'レビューを投稿しました'
        end
        visit '/reviews/1'
        within('.show-review-related-links') do
          click_link '削除'
        end
        expect(current_path).to eq userpage_path(user.id)
        within('.notice') do
          expect(page).to have_content '投稿を削除しました'
        end
      end
    end

    describe 'レビューの削除が各ページで適切に反映されていることの検証' do
      let!(:user) { create(:user) }
      let!(:recent_review) { create(:recent_review) }
      let!(:good_review) { create(:good_review) }
      let!(:great_review) { create(:great_review) }

      it 'レビューの削除が各ページで反映されること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/new'
        fill_in 'review_title', with: 'Python チュートリアル'
        find('.star-first').click
        fill_in 'review_content', with: 'Python チュートリアルは面白い'
        fill_in 'review_link', with: 'https://www.amazon-site.co.jp/'
        fill_in 'review_tag_ids', with: 'python,django'
        find('.post-review-btn').click
        expect(current_path).to eq userpage_path(user.id)
        within('.notice') do
          expect(page).to have_content 'レビューを投稿しました'
        end
        visit '/all_reviews'
        within("#review_4") do
          expect(page).to have_content "#{user.username}"
          expect(page).to have_content 'Python チュートリアルは面白い'
          expect(page).to have_content '#python'
          expect(page).to have_content '#django'
          within('.all-reviews-stars') do
            expect(page).to have_selector('svg', count: 1)
          end
        end
        visit '/reviews/4'
        within(".review-show-post") do
          expect(page).to have_content "#{user.username}"
          within('.all-reviews-stars') do
            expect(page).to have_selector('svg', count: 1)
          end
          expect(page).to have_content 'Python チュートリアル'
          expect(page).to have_content 'Python チュートリアルは面白い'
          expect(page).to have_content '#python'
          expect(page).to have_content '#django'
          expect(page).to have_content 'https://www.amazon-site.co.jp/'
        end
        visit '/userpages/profile_reviews/1'
        within(".mypage-reviews-post-4") do
          expect(page).to have_content "#{user.username}"
          within('.mypage-reviews-stars') do
            expect(page).to have_selector('svg', count: 1)
          end
          expect(page).to have_content 'Python チュートリアルは面白い'
          expect(page).to have_content '#python'
          expect(page).to have_content '#django'
        end
        visit '/reviews/4'
        within('.show-review-related-links') do
          click_link '削除'
        end
        visit '/all_reviews'
        expect(page).to have_no_selector 'div', id: "review_4"
        visit '/reviews/4'
        expect(page).to have_no_selector 'div', class: "review-show-post"
        visit '/userpages/profile_reviews/1'
        expect(page).to have_no_selector 'div', class: "mypage-reviews-post-4"
      end
    end
  end
end
