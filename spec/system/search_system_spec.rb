require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "Search", type: :system do
  describe 'アプリ内検索の検証' do
    describe 'アプリの内検索ページの要素検証' do
      let!(:user) { create(:user) }
      let!(:ruby_review) { create(:good_review, title: "Rubyガイド", content: "Rubyガイド面白い") }
      let!(:ruby_tag) { create(:tag, name: "ruby") }
      let!(:ruby_tag_relationship) { create(:tag_relationship, review_id: ruby_review.id, tag_id: ruby_tag.id) }

      it 'アプリの内検索フォームの要素検証をすること' do
        log_in_as(user.email, user.password)
        visit '/reviews'
        within('.search-reviews-index-size') do
          within('.search-reviews-forms') do
            within('.search-reviews-index-explains') do
              expect(page).to have_selector 'span', text: 'サイト内からレビューを探せます!'
            end
            within('.search-index-form-groups') do
              expect(page).to have_selector 'input', id: 'q_title_or_content_cont'
              expect(page).to have_selector("input[value$='タイトルで検索']")
              expect(page).to have_selector 'div', text: 'or'
              expect(page).to have_selector("input[value$='内容で検索']")
            end
            within('.search-reviews-index-words') do
              expect(page).to have_selector 'a', id: 'ruby_search_tag', text: '# Ruby'
              expect(page).to have_selector 'a', id: 'rails_search_tag', text: '# Rails'
              expect(page).to have_selector 'a', id: 'php_search_tag', text: '# PHP'
              expect(page).to have_selector 'a', id: 'laravel_search_tag', text: '# Laravel'
              expect(page).to have_selector 'a', id: 'python_search_tag', text: '# Python'
              expect(page).to have_selector 'a', id: 'django_search_tag', text: '# Django'
              expect(page).to have_selector 'a', id: 'go_search_tag', text: '# Go'
              expect(page).to have_selector 'a', id: 'java_search_tag', text: '# Java'
              expect(page).to have_selector 'a', id: 'javascript_search_tag', text: '# Javascript'
              expect(page).to have_selector 'a', id: 'typescript_search_tag', text: '# Typescript'
              expect(page).to have_selector 'a', id: 'aws_search_tag', text: '# AWS'
              expect(page).to have_selector 'a', id: 'docker_search_tag', text: '# Docker'
              expect(page).to have_selector 'a', id: 'linux_search_tag', text: '# Linux'
              expect(page).to have_selector 'a', id: 'sql_search_tag', text: '# SQL'
              expect(page).to have_selector 'a', id: 'vue_search_tag', text: '# Vue.js'
              expect(page).to have_selector 'a', id: 'react_search_tag', text: '# React.js'
              expect(page).to have_selector 'a', id: 'html_search_tag', text: '# HTML'
              expect(page).to have_selector 'a', id: 'kurbenetes_search_tag', text: '# Kurbenetes'
              expect(page).to have_selector 'a', id: 'swift_search_tag', text: '# Swift'
              expect(page).to have_selector 'a', id: 'flutter_search_tag', text: '# Flutter'
              expect(page).to have_selector 'a', id: 'other_search_tag', text: 'その他'
            end
          end
        end
      end

      it '検索結果の要素検証をすること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews'
        within('.search-reviews-index-size') do
          within('.search-reviews-index-words') do
            find('#ruby_search_tag').click
          end
        end
        within('.index') do
          within('.mypage-reviews-post') do
            within('.mypage-reviews-post-names-div') do
              expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
              expect(page).to have_selector 'div', text: "#{user.username}"
              expect(page).to have_selector 'span', text: "Since #{user.created_at.strftime("%Y-%m-%d")}"
            end
            within('.mypage-reviews-stars') do
              expect(page).to have_selector('svg', count: 2)
            end
            within('.mypage-review-content') do
              expect(page).to have_content "#{ruby_review.content}"
              expect(page).to have_selector 'span', text: "#ruby"
            end
            within('.mypage-review-bottom') do
              within('.mypage-review-bottom-icons') do
                expect(page).to have_selector("i[class$='mypage-reviews-comment-icon']")
                expect(page).to have_selector("i[class$='mypage-reviews-recommend-icon']")
                expect(page).to have_selector("i[class$='mypage-reviews-like-icon']")
              end
              expect(page).to have_selector 'div', text: "#{I18n.l(ruby_review.created_at)}"
            end
          end
        end
      end
    end

    describe '検索機能の検証' do
      describe 'タイトル・内容検索機能の検証' do
        describe '一つのレビューを検索' do
          let!(:user) { create(:user) }
          let!(:ruby_review) { create(:good_review, title: "ruby", content: "面白い") }

          it 'タイトル・内容検索できること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "ruby"
            find('.title-search-btn').click
            within(".mypage-reviews-post-#{Review.last.id}") do
              expect(page).to have_content "#{ruby_review.content}"
            end
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "面白い"
            find('.title-search-btn').click
            within(".mypage-reviews-post-#{Review.last.id}") do
              expect(page).to have_content "#{ruby_review.content}"
            end
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "ruby"
            find('.content-search-btn').click
            within(".mypage-reviews-post-#{Review.last.id}") do
              expect(page).to have_content "#{ruby_review.content}"
            end
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "面白い"
            find('.content-search-btn').click
            within(".mypage-reviews-post-#{Review.last.id}") do
              expect(page).to have_content "#{ruby_review.content}"
            end
          end
        end

        describe '複数のレビューを検索' do
          let!(:user) { create(:user) }
          let!(:ruby_review) { create(:good_review, title: "rubyガイド", content: "面白い") }
          let!(:php_review) { create(:good_review, title: "phpガイド", content: "面白い") }
          let!(:python_review) { create(:good_review, title: "pythonガイド", content: "面白い") }

          it 'タイトル・内容検索できること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "ガイド"
            find('.title-search-btn').click
            within('.index') do
              expect(page).to have_content "#{ruby_review.content}"
              expect(page).to have_content "#{php_review.content}"
              expect(page).to have_content "#{python_review.content}"
            end
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "面白い"
            find('.title-search-btn').click
            within('.index') do
              expect(page).to have_content "#{ruby_review.content}"
              expect(page).to have_content "#{php_review.content}"
              expect(page).to have_content "#{python_review.content}"
            end
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "ガイド"
            find('.content-search-btn').click
            within('.index') do
              expect(page).to have_content "#{ruby_review.content}"
              expect(page).to have_content "#{php_review.content}"
              expect(page).to have_content "#{python_review.content}"
            end
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "面白い"
            find('.content-search-btn').click
            within('.index') do
              expect(page).to have_content "#{ruby_review.content}"
              expect(page).to have_content "#{php_review.content}"
              expect(page).to have_content "#{python_review.content}"
            end
          end

          it 'リンクで投稿詳細を閲覧できること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews'
            fill_in 'q_title_or_content_cont', with: "ガイド"
            find('.title-search-btn').click
            within(".mypage-reviews-post-#{ruby_review.id}") do
              expect(page).to have_content "#{ruby_review.content}"
            end
            find(".mypage-reviews-post-#{ruby_review.id}").click
            expect(current_path).to eq review_path(ruby_review.id)
          end
        end
      end

      describe 'タグ検索機能の検証' do
        describe '一つのレビューを検索' do
          let!(:user) { create(:user) }
          let!(:ruby_review) { create(:good_review, title: "ruby", content: "ruby content") }
          let!(:ruby_tag) { create(:tag, name: "ruby") }
          let!(:ruby_tag_relationship) { create(:tag_relationship, review_id: ruby_review.id, tag_id: ruby_tag.id) }

          let!(:rails_review) { create(:good_review, title: "rails", content: "rails content") }
          let!(:rails_tag) { create(:tag,name: "rails") }
          let!(:rails_tag_relationship) { create(:tag_relationship, review_id: rails_review.id, tag_id: rails_tag.id) }

          let!(:php_review) { create(:good_review, title: "php", content: "php content") }
          let!(:php_tag) { create(:tag, name: "php") }
          let!(:php_tag_relationship) { create(:tag_relationship, review_id: php_review.id, tag_id: php_tag.id) }

          let!(:laravel_review) { create(:good_review, title: "laravel", content: "laravel content") }
          let!(:laravel_tag) { create(:tag, name: "laravel") }
          let!(:laravel_tag_relationship) { create(:tag_relationship, review_id: laravel_review.id, tag_id: laravel_tag.id) }

          let!(:python_review) { create(:good_review, title: "python", content: "python content") }
          let!(:python_tag) { create(:tag, name: "python") }
          let!(:python_tag_relationship) { create(:tag_relationship, review_id: python_review.id, tag_id: python_tag.id) }

          let!(:django_review) { create(:good_review, title: "django", content: "django content") }
          let!(:django_tag) { create(:tag, name: "django") }
          let!(:django_tag_relationship) { create(:tag_relationship, review_id: django_review.id, tag_id: django_tag.id) }

          let!(:go_review) { create(:good_review, title: "go", content: "go content") }
          let!(:go_tag) { create(:tag, name: "go") }
          let!(:go_tag_relationship) { create(:tag_relationship, review_id: go_review.id, tag_id: go_tag.id) }

          let!(:java_review) { create(:good_review, title: "java", content: "java content") }
          let!(:java_tag) { create(:tag, name: "java") }
          let!(:java_tag_relationship) { create(:tag_relationship, review_id: java_review.id, tag_id: java_tag.id) }

          let!(:javascript_review) { create(:good_review, title: "javascript", content: "javascript content") }
          let!(:javascript_tag) { create(:tag, name: "javascript") }
          let!(:javascript_tag_relationship) { create(:tag_relationship, review_id: javascript_review.id, tag_id: javascript_tag.id) }

          let!(:typescript_review) { create(:good_review, title: "typescript", content: "typescript content") }
          let!(:typescript_tag) { create(:tag, name: "typescript") }
          let!(:typescript_tag_relationship) { create(:tag_relationship, review_id: typescript_review.id, tag_id: typescript_tag.id) }

          let!(:aws_review) { create(:good_review, title: "aws", content: "aws content") }
          let!(:aws_tag) { create(:tag, name: "aws") }
          let!(:aws_tag_relationship) { create(:tag_relationship, review_id: aws_review.id, tag_id: aws_tag.id) }

          let!(:docker_review) { create(:good_review, title: "docker", content: "docker content") }
          let!(:docker_tag) { create(:tag, name: "docker") }
          let!(:docker_tag_relationship) { create(:tag_relationship, review_id: docker_review.id, tag_id: docker_tag.id) }

          let!(:linux_review) { create(:good_review, title: "linux", content: "linux content") }
          let!(:linux_tag) { create(:tag, name: "linux") }
          let!(:linux_tag_relationship) { create(:tag_relationship, review_id: linux_review.id, tag_id: linux_tag.id) }

          let!(:sql_review) { create(:good_review, title: "sql", content: "sql content") }
          let!(:sql_tag) { create(:tag, name: "sql") }
          let!(:sql_tag_relationship) { create(:tag_relationship, review_id: sql_review.id, tag_id: sql_tag.id) }

          let!(:vue_review) { create(:good_review, title: "vue", content: "vue content") }
          let!(:vue_tag) { create(:tag, name: "vue") }
          let!(:vue_tag_relationship) { create(:tag_relationship, review_id: vue_review.id, tag_id: vue_tag.id) }

          let!(:react_review) { create(:good_review, title: "react", content: "react content") }
          let!(:react_tag) { create(:tag, name: "react") }
          let!(:react_tag_relationship) { create(:tag_relationship, review_id: react_review.id, tag_id: react_tag.id) }

          let!(:html_review) { create(:good_review, title: "html", content: "html content") }
          let!(:html_tag) { create(:tag, name: "html") }
          let!(:html_tag_relationship) { create(:tag_relationship, review_id: html_review.id, tag_id: html_tag.id) }

          let!(:kurbenetes_review) { create(:good_review, title: "kurbenetes", content: "kurbenetes content") }
          let!(:kurbenetes_tag) { create(:tag, name: "kurbenetes") }
          let!(:kurbenetes_tag_relationship) { create(:tag_relationship, review_id: kurbenetes_review.id, tag_id: kurbenetes_tag.id) }

          let!(:swift_review) { create(:good_review, title: "swift", content: "swift content") }
          let!(:swift_tag) { create(:tag, name: "swift") }
          let!(:swift_tag_relationship) { create(:tag_relationship, review_id: swift_review.id, tag_id: swift_tag.id) }

          let!(:flutter_review) { create(:good_review, title: "flutter", content: "flutter content") }
          let!(:flutter_tag) { create(:tag, name: "flutter") }
          let!(:flutter_tag_relationship) { create(:tag_relationship, review_id: flutter_review.id, tag_id: flutter_tag.id) }

          let!(:other_review) { create(:good_review, title: "other", content: "other content") }
          let!(:other_tag) { create(:tag, name: "other") }
          let!(:other_tag_relationship) { create(:tag_relationship, review_id: other_review.id, tag_id: other_tag.id) }

          it 'Rubyタグ検索の検証をすること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews'
            find('#ruby_search_tag').click
            within(".mypage-reviews-post-#{ruby_review.id}") do
              expect(page).to have_content "#{ruby_review.content}"
            end
            find('#rails_search_tag').click
            within(".mypage-reviews-post-#{rails_review.id}") do
              expect(page).to have_content "#{rails_review.content}"
            end
            find('#php_search_tag').click
            within(".mypage-reviews-post-#{php_review.id}") do
              expect(page).to have_content "#{php_review.content}"
            end
            find('#laravel_search_tag').click
            within(".mypage-reviews-post-#{laravel_review.id}") do
              expect(page).to have_content "#{laravel_review.content}"
            end
            find('#python_search_tag').click
            within(".mypage-reviews-post-#{python_review.id}") do
              expect(page).to have_content "#{python_review.content}"
            end
            find('#django_search_tag').click
            within(".mypage-reviews-post-#{django_review.id}") do
              expect(page).to have_content "#{django_review.content}"
            end
            find('#go_search_tag').click
            within(".mypage-reviews-post-#{go_review.id}") do
              expect(page).to have_content "#{go_review.content}"
            end
            find('#java_search_tag').click
            within(".mypage-reviews-post-#{java_review.id}") do
              expect(page).to have_content "#{java_review.content}"
            end
            find('#javascript_search_tag').click
            within(".mypage-reviews-post-#{javascript_review.id}") do
              expect(page).to have_content "#{javascript_review.content}"
            end
            find('#typescript_search_tag').click
            within(".mypage-reviews-post-#{typescript_review.id}") do
              expect(page).to have_content "#{typescript_review.content}"
            end
            find('#aws_search_tag').click
            within(".mypage-reviews-post-#{aws_review.id}") do
              expect(page).to have_content "#{aws_review.content}"
            end
            find('#docker_search_tag').click
            within(".mypage-reviews-post-#{docker_review.id}") do
              expect(page).to have_content "#{docker_review.content}"
            end
            find('#linux_search_tag').click
            within(".mypage-reviews-post-#{linux_review.id}") do
              expect(page).to have_content "#{linux_review.content}"
            end
            find('#sql_search_tag').click
            within(".mypage-reviews-post-#{sql_review.id}") do
              expect(page).to have_content "#{sql_review.content}"
            end
            find('#vue_search_tag').click
            within(".mypage-reviews-post-#{vue_review.id}") do
              expect(page).to have_content "#{vue_review.content}"
            end
            find('#react_search_tag').click
            within(".mypage-reviews-post-#{react_review.id}") do
              expect(page).to have_content "#{react_review.content}"
            end
            find('#html_search_tag').click
            within(".mypage-reviews-post-#{html_review.id}") do
              expect(page).to have_content "#{html_review.content}"
            end
            find('#kurbenetes_search_tag').click
            within(".mypage-reviews-post-#{kurbenetes_review.id}") do
              expect(page).to have_content "#{kurbenetes_review.content}"
            end
            find('#swift_search_tag').click
            within(".mypage-reviews-post-#{swift_review.id}") do
              expect(page).to have_content "#{swift_review.content}"
            end
            find('#flutter_search_tag').click
            within(".mypage-reviews-post-#{flutter_review.id}") do
              expect(page).to have_content "#{flutter_review.content}"
            end
            find('#other_search_tag').click
            within(".mypage-reviews-post-#{other_review.id}") do
              expect(page).to have_content "#{other_review.content}"
            end
          end
        end

        describe '複数のレビューを検索' do
          let!(:user) { create(:user) }
          let!(:first_review) { create(:good_review, title: "最初の投稿", content: "最初の投稿の内容") }
          let!(:second_review) { create(:good_review, title: "２回目の投稿", content: "２回目の投稿の内容") }
          let!(:third_review) { create(:good_review, title: "３回目の投稿", content: "３回目の投稿の内容") }
          let!(:ruby_tag) { create(:tag, name: "ruby") }
          let!(:php_tag) { create(:tag, name: "php") }
          let!(:python_tag) { create(:tag, name: "python") }
          let!(:first_ruby_tag_relationship) { create(:tag_relationship, review_id: first_review.id, tag_id: ruby_tag.id) }
          let!(:second_ruby_tag_relationship) { create(:tag_relationship, review_id: second_review.id, tag_id: ruby_tag.id) }
          let!(:third_ruby_tag_relationship) { create(:tag_relationship, review_id: third_review.id, tag_id: ruby_tag.id) }
          let!(:first_php_tag_relationship) { create(:tag_relationship, review_id: first_review.id, tag_id: php_tag.id) }
          let!(:second_php_tag_relationship) { create(:tag_relationship, review_id: second_review.id, tag_id: php_tag.id) }
          let!(:first_python_tag_relationship) { create(:tag_relationship, review_id: first_review.id, tag_id: python_tag.id) }

          it 'タグ検索で複数のレビューが表示されること', js: true do
            log_in_as(user.email, user.password)
            visit '/reviews'
            find('#ruby_search_tag').click
            within(".mypage-reviews-post-#{first_review.id}") do
              expect(page).to have_content "#{first_review.content}"
            end
            within(".mypage-reviews-post-#{second_review.id}") do
              expect(page).to have_content "#{second_review.content}"
            end
            within(".mypage-reviews-post-#{third_review.id}") do
              expect(page).to have_content "#{third_review.content}"
            end
            find('#php_search_tag').click
            within(".mypage-reviews-post-#{first_review.id}") do
              expect(page).to have_content "#{first_review.content}"
            end
            within(".mypage-reviews-post-#{second_review.id}") do
              expect(page).to have_content "#{second_review.content}"
            end
            find('#python_search_tag').click
            within(".mypage-reviews-post-#{first_review.id}") do
              expect(page).to have_content "#{first_review.content}"
            end
          end
        end
      end
    end

    describe '全投稿一覧ページのタグ検索の要素検証' do
      let!(:user) { create(:user) }

      it '要素検証をすること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        within(".all-reviews-tag") do
          within(".tag-ranking-title") do
            expect(page).to have_selector 'div', class: "like-ranking-title-word", text: "タグ"
          end
          within(".all-review-tags") do
            expect(page).to have_selector('a', count: 20)
            expect(page).to have_selector 'span', text: "#Ruby"
            expect(page).to have_selector 'span', text: "#Rails"
            expect(page).to have_selector 'span', text: "#PHP"
            expect(page).to have_selector 'span', text: "#Laravel"
            expect(page).to have_selector 'span', text: "#Python"
            expect(page).to have_selector 'span', text: "#Django"
            expect(page).to have_selector 'span', text: "#Go"
            expect(page).to have_selector 'span', text: "#Javascript"
            expect(page).to have_selector 'span', text: "#Typescript"
            expect(page).to have_selector 'span', text: "#AWS"
            expect(page).to have_selector 'span', text: "#Docker"
            expect(page).to have_selector 'span', text: "#Linux"
            expect(page).to have_selector 'span', text: "#SQL"
            expect(page).to have_selector 'span', text: "#Vue.js"
            expect(page).to have_selector 'span', text: "#React.js"
            expect(page).to have_selector 'span', text: "#HTML"
            expect(page).to have_selector 'span', text: "#Kurbenetes"
            expect(page).to have_selector 'span', text: "#Swift"
            expect(page).to have_selector 'span', text: "#Flutter"
          end
        end
      end
    end

    describe '全投稿一覧ページのタグ検索機能の検証' do
      let!(:user) { create(:user) }
      let!(:ruby_review) { create(:good_review, title: "ruby", content: "ruby content") }
      let!(:ruby_tag) { create(:tag, name: "ruby") }
      let!(:ruby_tag_relationship) { create(:tag_relationship, review_id: ruby_review.id, tag_id: ruby_tag.id) }

      let!(:rails_review) { create(:good_review, title: "rails", content: "rails content") }
      let!(:rails_tag) { create(:tag,name: "rails") }
      let!(:rails_tag_relationship) { create(:tag_relationship, review_id: rails_review.id, tag_id: rails_tag.id) }

      let!(:php_review) { create(:good_review, title: "php", content: "php content") }
      let!(:php_tag) { create(:tag, name: "php") }
      let!(:php_tag_relationship) { create(:tag_relationship, review_id: php_review.id, tag_id: php_tag.id) }

      let!(:laravel_review) { create(:good_review, title: "laravel", content: "laravel content") }
      let!(:laravel_tag) { create(:tag, name: "laravel") }
      let!(:laravel_tag_relationship) { create(:tag_relationship, review_id: laravel_review.id, tag_id: laravel_tag.id) }

      let!(:python_review) { create(:good_review, title: "python", content: "python content") }
      let!(:python_tag) { create(:tag, name: "python") }
      let!(:python_tag_relationship) { create(:tag_relationship, review_id: python_review.id, tag_id: python_tag.id) }

      let!(:django_review) { create(:good_review, title: "django", content: "django content") }
      let!(:django_tag) { create(:tag, name: "django") }
      let!(:django_tag_relationship) { create(:tag_relationship, review_id: django_review.id, tag_id: django_tag.id) }

      let!(:go_review) { create(:good_review, title: "go", content: "go content") }
      let!(:go_tag) { create(:tag, name: "go") }
      let!(:go_tag_relationship) { create(:tag_relationship, review_id: go_review.id, tag_id: go_tag.id) }

      let!(:java_review) { create(:good_review, title: "java", content: "java content") }
      let!(:java_tag) { create(:tag, name: "java") }
      let!(:java_tag_relationship) { create(:tag_relationship, review_id: java_review.id, tag_id: java_tag.id) }

      let!(:javascript_review) { create(:good_review, title: "javascript", content: "javascript content") }
      let!(:javascript_tag) { create(:tag, name: "javascript") }
      let!(:javascript_tag_relationship) { create(:tag_relationship, review_id: javascript_review.id, tag_id: javascript_tag.id) }

      let!(:typescript_review) { create(:good_review, title: "typescript", content: "typescript content") }
      let!(:typescript_tag) { create(:tag, name: "typescript") }
      let!(:typescript_tag_relationship) { create(:tag_relationship, review_id: typescript_review.id, tag_id: typescript_tag.id) }

      let!(:aws_review) { create(:good_review, title: "aws", content: "aws content") }
      let!(:aws_tag) { create(:tag, name: "aws") }
      let!(:aws_tag_relationship) { create(:tag_relationship, review_id: aws_review.id, tag_id: aws_tag.id) }

      let!(:docker_review) { create(:good_review, title: "docker", content: "docker content") }
      let!(:docker_tag) { create(:tag, name: "docker") }
      let!(:docker_tag_relationship) { create(:tag_relationship, review_id: docker_review.id, tag_id: docker_tag.id) }

      let!(:linux_review) { create(:good_review, title: "linux", content: "linux content") }
      let!(:linux_tag) { create(:tag, name: "linux") }
      let!(:linux_tag_relationship) { create(:tag_relationship, review_id: linux_review.id, tag_id: linux_tag.id) }

      let!(:sql_review) { create(:good_review, title: "sql", content: "sql content") }
      let!(:sql_tag) { create(:tag, name: "sql") }
      let!(:sql_tag_relationship) { create(:tag_relationship, review_id: sql_review.id, tag_id: sql_tag.id) }

      let!(:vue_review) { create(:good_review, title: "vue", content: "vue content") }
      let!(:vue_tag) { create(:tag, name: "vue") }
      let!(:vue_tag_relationship) { create(:tag_relationship, review_id: vue_review.id, tag_id: vue_tag.id) }

      let!(:react_review) { create(:good_review, title: "react", content: "react content") }
      let!(:react_tag) { create(:tag, name: "react") }
      let!(:react_tag_relationship) { create(:tag_relationship, review_id: react_review.id, tag_id: react_tag.id) }

      let!(:html_review) { create(:good_review, title: "html", content: "html content") }
      let!(:html_tag) { create(:tag, name: "html") }
      let!(:html_tag_relationship) { create(:tag_relationship, review_id: html_review.id, tag_id: html_tag.id) }

      let!(:kurbenetes_review) { create(:good_review, title: "kurbenetes", content: "kurbenetes content") }
      let!(:kurbenetes_tag) { create(:tag, name: "kurbenetes") }
      let!(:kurbenetes_tag_relationship) { create(:tag_relationship, review_id: kurbenetes_review.id, tag_id: kurbenetes_tag.id) }

      let!(:swift_review) { create(:good_review, title: "swift", content: "swift content") }
      let!(:swift_tag) { create(:tag, name: "swift") }
      let!(:swift_tag_relationship) { create(:tag_relationship, review_id: swift_review.id, tag_id: swift_tag.id) }

      let!(:flutter_review) { create(:good_review, title: "flutter", content: "flutter content") }
      let!(:flutter_tag) { create(:tag, name: "flutter") }
      let!(:flutter_tag_relationship) { create(:tag_relationship, review_id: flutter_review.id, tag_id: flutter_tag.id) }

      it 'rubyのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-ruby').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{ruby_review.id}"
          within(".mypage-reviews-post-#{ruby_review.id}") do
            expect(page).to have_content "#ruby"
          end
        end
      end

      it 'railsのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-rails').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{rails_review.id}"
          within(".mypage-reviews-post-#{rails_review.id}") do
            expect(page).to have_content "#rails"
          end
        end
      end

      it 'phpのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-php').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{php_review.id}"
          within(".mypage-reviews-post-#{php_review.id}") do
            expect(page).to have_content "#php"
          end
        end
      end

      it 'laravelのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-laravel').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{laravel_review.id}"
          within(".mypage-reviews-post-#{laravel_review.id}") do
            expect(page).to have_content "#laravel"
          end
        end
      end

      it 'pythonのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-python').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{python_review.id}"
          within(".mypage-reviews-post-#{python_review.id}") do
            expect(page).to have_content "#python"
          end
        end
      end

      it 'djangoのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-django').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{django_review.id}"
          within(".mypage-reviews-post-#{django_review.id}") do
            expect(page).to have_content "#django"
          end
        end
      end

      it 'goのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-go').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{go_review.id}"
          within(".mypage-reviews-post-#{go_review.id}") do
            expect(page).to have_content "#go"
          end
        end
      end

      it 'javaのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-java').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{java_review.id}"
          within(".mypage-reviews-post-#{java_review.id}") do
            expect(page).to have_content "#java"
          end
        end
      end

      it 'javascriptのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-javascript').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{javascript_review.id}"
          within(".mypage-reviews-post-#{javascript_review.id}") do
            expect(page).to have_content "#javascript"
          end
        end
      end

      it 'typescriptのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-typescript').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{typescript_review.id}"
          within(".mypage-reviews-post-#{typescript_review.id}") do
            expect(page).to have_content "#typescript"
          end
        end
      end

      it 'awsのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-aws').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{aws_review.id}"
          within(".mypage-reviews-post-#{aws_review.id}") do
            expect(page).to have_content "#aws"
          end
        end
      end

      it 'dockerのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-docker').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{docker_review.id}"
          within(".mypage-reviews-post-#{docker_review.id}") do
            expect(page).to have_content "#docker"
          end
        end
      end

      it 'linuxのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-linux').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{linux_review.id}"
          within(".mypage-reviews-post-#{linux_review.id}") do
            expect(page).to have_content "#linux"
          end
        end
      end

      it 'sqlのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-sql').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{sql_review.id}"
          within(".mypage-reviews-post-#{sql_review.id}") do
            expect(page).to have_content "#sql"
          end
        end
      end

      it 'vueのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-vue').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{vue_review.id}"
          within(".mypage-reviews-post-#{vue_review.id}") do
            expect(page).to have_content "#vue"
          end
        end
      end

      it 'reactのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-react').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{react_review.id}"
          within(".mypage-reviews-post-#{react_review.id}") do
            expect(page).to have_content "#react"
          end
        end
      end

      it 'htmlのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-html').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{html_review.id}"
          within(".mypage-reviews-post-#{html_review.id}") do
            expect(page).to have_content "#html"
          end
        end
      end

      it 'kurbenetesのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-kurbenetes').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{kurbenetes_review.id}"
          within(".mypage-reviews-post-#{kurbenetes_review.id}") do
            expect(page).to have_content "#kurbenetes"
          end
        end
      end

      it 'swiftのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-swift').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{swift_review.id}"
          within(".mypage-reviews-post-#{swift_review.id}") do
            expect(page).to have_content "#swift"
          end
        end
      end

      it 'flutterのタグ検索できること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        find('.all-review-tag-flutter').click
        expect(current_path).to eq reviews_path
        within('#search_result_reviews') do
          expect(page).to have_selector 'a', class: "mypage-reviews-post-#{flutter_review.id}"
          within(".mypage-reviews-post-#{flutter_review.id}") do
            expect(page).to have_content "#flutter"
          end
        end
      end
    end
  end
end
