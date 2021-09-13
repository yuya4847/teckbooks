require 'rails_helper'
RSpec.describe "Search", type: :system do
  describe '検索機能が機能する' do
    let!(:user) { create(:user) }
    let!(:ruby_review) { create(:good_review, title: "Rubyガイド", content: "Rubyガイド面白い") }
    let!(:php_review) { create(:good_review, title: "phpガイド", content: "pythonガイドより面白い") }

    let!(:ruby_tag) { create(:tag, name: "ruby") }
    let!(:ruby_tag_relationship) { create(:tag_relationship, review_id: ruby_review.id, tag_id: ruby_tag.id) }
    let!(:php_tag) { create(:tag, name: "php") }
    let!(:php_tag_relationship) { create(:tag_relationship, review_id: php_review.id, tag_id: php_tag.id) }

    let!(:rails_review) { create(:good_review, title: "railsガイド", content: "railsガイド面白い") }
    let!(:python_review) { create(:good_review, title: "pythonガイド", content: "pythonガイド面白い") }
    let!(:go_review) { create(:good_review, title: "goガイド", content: "goガイド面白い") }
    let!(:java_review) { create(:good_review, title: "javaガイド", content: "javaガイド面白い") }
    let!(:javascript_review) { create(:good_review, title: "javascriptガイド", content: "javascriptガイド面白い") }
    let!(:typescript_review) { create(:good_review, title: "typescriptガイド", content: "typescriptガイド面白い") }
    let!(:aws_review) { create(:good_review, title: "awsガイド", content: "awsガイド面白い") }
    let!(:docker_review) { create(:good_review, title: "dockerガイド", content: "dockerガイド面白い") }
    let!(:linux_review) { create(:good_review, title: "linuxガイド", content: "linuxガイド面白い") }
    let!(:sql_review) { create(:good_review, title: "sqlガイド", content: "sqlガイド面白い") }
    let!(:vue_review) { create(:good_review, title: "vueガイド", content: "vueガイド面白い") }
    let!(:react_review) { create(:good_review, title: "reactガイド", content: "reactガイド面白い") }

    let!(:rails_tag) { create(:tag, name: "rails") }
    let!(:rails_tag_relationship) { create(:tag_relationship, review_id: rails_review.id, tag_id: rails_tag.id) }
    let!(:python_tag) { create(:tag, name: "python") }
    let!(:python_tag_relationship) { create(:tag_relationship, review_id: python_review.id, tag_id: python_tag.id) }
    let!(:go_tag) { create(:tag, name: "go") }
    let!(:go_tag_relationship) { create(:tag_relationship, review_id: go_review.id, tag_id: go_tag.id) }
    let!(:java_tag) { create(:tag, name: "java") }
    let!(:java_tag_relationship) { create(:tag_relationship, review_id: java_review.id, tag_id: java_tag.id) }
    let!(:javascript_tag) { create(:tag, name: "javascript") }
    let!(:javascript_tag_relationship) { create(:tag_relationship, review_id: javascript_review.id, tag_id: javascript_tag.id) }
    let!(:typescript_tag) { create(:tag, name: "typescript") }
    let!(:typescript_tag_relationship) { create(:tag_relationship, review_id: typescript_review.id, tag_id: typescript_tag.id) }
    let!(:aws_tag) { create(:tag, name: "aws") }
    let!(:aws_tag_relationship) { create(:tag_relationship, review_id: aws_review.id, tag_id: aws_tag.id) }
    let!(:docker_tag) { create(:tag, name: "docker") }
    let!(:docker_tag_relationship) { create(:tag_relationship, review_id: docker_review.id, tag_id: docker_tag.id) }
    let!(:linux_tag) { create(:tag, name: "linux") }
    let!(:linux_tag_relationship) { create(:tag_relationship, review_id: linux_review.id, tag_id: linux_tag.id) }
    let!(:sql_tag) { create(:tag, name: "sql") }
    let!(:sql_tag_relationship) { create(:tag_relationship, review_id: sql_review.id, tag_id: sql_tag.id) }
    let!(:vue_tag) { create(:tag, name: "vue") }
    let!(:vue_tag_relationship) { create(:tag_relationship, review_id: vue_review.id, tag_id: vue_tag.id) }
    let!(:react_tag) { create(:tag, name: "react") }
    let!(:react_tag_relationship) { create(:tag_relationship, review_id: react_review.id, tag_id: react_tag.id) }

    let!(:other_review) { create(:good_review, title: "otherガイド", content: "otherは面白い") }

    let!(:other_tag) { create(:tag, name: "other_tag") }
    let!(:other_tag_relationship) { create(:tag_relationship, review_id: other_review.id, tag_id: other_tag.id) }

    describe '検索ページの要素検証' do
      it '単一のタグをつけてレビューが投稿できること' do
        log_in_as(user.email, user.password)
        visit '/reviews'
        expect(page).to have_selector 'label', text: 'タイトル'
        expect(page).to have_selector 'input', id: 'q_title_cont'
        expect(page).to have_selector 'label', text: '内容'
        expect(page).to have_selector 'input', id: 'q_content_cont'
        expect(page).to have_button '検索'
        expect(page).to have_link "Ruby"
        expect(page).to have_link "Rails"
        expect(page).to have_link "PHP"
        expect(page).to have_link "Python"
        expect(page).to have_link "Go"
        expect(page).to have_link "Java"
        expect(page).to have_link "Javascript"
        expect(page).to have_link "Typescript"
        expect(page).to have_link "AWS"
        expect(page).to have_link "Docker"
        expect(page).to have_link "Linux"
        expect(page).to have_link "SQL"
        expect(page).to have_link "Vue.js"
        expect(page).to have_link "React.js"
      end
    end

    describe '検索結果の表示', js: true do
      context "タイトルと内容の両方に同じキーワードが含まれる場合" do
        it 'タイトル検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          fill_in 'q_title_cont', with: "ruby"
          click_button "検索"
          expect(page).to have_content "#{ruby_review.title}"
          expect(page).to have_content "#{ruby_review.content}"
          expect(page).to have_content ruby_review.rate.to_s
          expect(page).to have_content "10分前"
        end

        it '内容検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          fill_in 'q_content_cont', with: "ruby"
          click_button "検索"
          expect(page).to have_content "#{ruby_review.title}"
          expect(page).to have_content "#{ruby_review.content}"
          expect(page).to have_content ruby_review.rate.to_s
          expect(page).to have_content "10分前"
        end

        it 'タイトルと内容の同時検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          fill_in 'q_title_cont', with: "ruby"
          fill_in 'q_content_cont', with: "ruby"
          click_button "検索"
          expect(page).to have_content "#{ruby_review.title}"
          expect(page).to have_content "#{ruby_review.content}"
          expect(page).to have_content ruby_review.rate.to_s
          expect(page).to have_content "10分前"
        end
      end

      context "タイトルと内容の両方に異なるキーワードが含まれる場合" do
        it 'タイトル検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          fill_in 'q_title_cont', with: "php"
          click_button "検索"
          expect(page).to have_content "#{php_review.title}"
          expect(page).to have_content "#{php_review.content}"
          expect(page).to have_content php_review.rate.to_s
          expect(page).to have_content "10分前"
        end

        it '内容検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          fill_in 'q_content_cont', with: "python"
          click_button "検索"
          expect(page).to have_content "#{php_review.title}"
          expect(page).to have_content "#{php_review.content}"
          expect(page).to have_content php_review.rate.to_s
          expect(page).to have_content "10分前"
        end

        it 'タイトルと内容の同時検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          fill_in 'q_title_cont', with: "php"
          fill_in 'q_content_cont', with: "python"
          click_button "検索"
          expect(page).to have_content "#{php_review.title}"
          expect(page).to have_content "#{php_review.content}"
          expect(page).to have_content php_review.rate.to_s
          expect(page).to have_content "10分前"
        end
      end

      context "存在しないレビューのキーワードが含まれる場合" do
        it 'タイトル検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          fill_in 'q_title_cont', with: "flutter"
          click_button "検索"
          expect(page).not_to have_content "#{ruby_review.title}"
          expect(page).not_to have_content "#{ruby_review.content}"
          expect(page).not_to have_content ruby_review.rate.to_s
          expect(page).not_to have_content "10分前"
          expect(page).not_to have_content "#{php_review.title}"
          expect(page).not_to have_content "#{php_review.content}"
          expect(page).not_to have_content php_review.rate.to_s
          expect(page).not_to have_content "10分前"
        end

        it '内容検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          fill_in 'q_content_cont', with: "flutter"
          click_button "検索"
          expect(page).not_to have_content "#{ruby_review.title}"
          expect(page).not_to have_content "#{ruby_review.content}"
          expect(page).not_to have_content ruby_review.rate.to_s
          expect(page).not_to have_content "10分前"
          expect(page).not_to have_content "#{php_review.title}"
          expect(page).not_to have_content "#{php_review.content}"
          expect(page).not_to have_content php_review.rate.to_s
          expect(page).not_to have_content "10分前"
        end
      end

      describe 'タグ検索結果の表示', js: true do
        it 'タグ検索ができること' do
          log_in_as(user.email, user.password)
          visit '/reviews'
          click_link "Ruby"
          expect(page).to have_content "#{ruby_review.title}"
          expect(page).to have_content "#{ruby_review.content}"
          expect(page).to have_content ruby_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Rails"
          expect(page).to have_content "#{rails_review.title}"
          expect(page).to have_content "#{rails_review.content}"
          expect(page).to have_content rails_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "PHP"
          expect(page).to have_content "#{php_review.title}"
          expect(page).to have_content "#{php_review.content}"
          expect(page).to have_content php_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Python"
          expect(page).to have_content "#{python_review.title}"
          expect(page).to have_content "#{python_review.content}"
          expect(page).to have_content python_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Go"
          expect(page).to have_content "#{go_review.title}"
          expect(page).to have_content "#{go_review.content}"
          expect(page).to have_content go_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Java"
          expect(page).to have_content "#{java_review.title}"
          expect(page).to have_content "#{java_review.content}"
          expect(page).to have_content java_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Javascript"
          expect(page).to have_content "#{javascript_review.title}"
          expect(page).to have_content "#{javascript_review.content}"
          expect(page).to have_content javascript_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Typescript"
          expect(page).to have_content "#{typescript_review.title}"
          expect(page).to have_content "#{typescript_review.content}"
          expect(page).to have_content typescript_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "AWS"
          expect(page).to have_content "#{aws_review.title}"
          expect(page).to have_content "#{aws_review.content}"
          expect(page).to have_content aws_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Docker"
          expect(page).to have_content "#{docker_review.title}"
          expect(page).to have_content "#{docker_review.content}"
          expect(page).to have_content docker_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Linux"
          expect(page).to have_content "#{linux_review.title}"
          expect(page).to have_content "#{linux_review.content}"
          expect(page).to have_content linux_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "SQL"
          expect(page).to have_content "#{sql_review.title}"
          expect(page).to have_content "#{sql_review.content}"
          expect(page).to have_content sql_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "Vue.js"
          expect(page).to have_content "#{vue_review.title}"
          expect(page).to have_content "#{vue_review.content}"
          expect(page).to have_content vue_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "React.js"
          expect(page).to have_content "#{react_review.title}"
          expect(page).to have_content "#{react_review.content}"
          expect(page).to have_content react_review.rate.to_s
          expect(page).to have_content "10分前"
          click_link "その他"
          expect(page).to have_content "#{other_review.title}"
          expect(page).to have_content "#{other_review.content}"
          expect(page).to have_content other_review.rate.to_s
          expect(page).to have_content "10分前"
        end
      end
    end
  end

  describe '投稿が検索機能に反映される', js: true do
    let!(:user) { create(:user) }
    let!(:ruby_review) { build(:good_review, title: "Rubyガイド", content: "Rubyガイド面白い") }

    it '投稿がタイトル・内容検索機能に反映される' do
      log_in_as(user.email, user.password)
      visit '/reviews/new'
      attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
      fill_in 'review_title', with: ruby_review.title
      fill_in 'review_link', with: ruby_review.link
      fill_in 'review_rate', with: ruby_review.rate
      fill_in 'review_content', with: ruby_review.content
      fill_in 'review_tag_ids', with: "ruby"
      click_button 'レビューを投稿する'
      click_link "検索"
      fill_in 'q_title_cont', with: "ruby"
      fill_in 'q_content_cont', with: "ruby"
      click_button "検索"
      expect(page).to have_content "#{ruby_review.title}"
      expect(page).to have_content "#{ruby_review.content}"
      expect(page).to have_content ruby_review.rate.to_s
      expect(page).to have_content "1分前"
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
    end

    it '投稿がタグ検索機能に反映される' do
      log_in_as(user.email, user.password)
      visit '/reviews/new'
      attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
      fill_in 'review_title', with: ruby_review.title
      fill_in 'review_link', with: ruby_review.link
      fill_in 'review_rate', with: ruby_review.rate
      fill_in 'review_content', with: ruby_review.content
      fill_in 'review_tag_ids', with: "ruby"
      click_button 'レビューを投稿する'
      click_link "検索"
      click_link "Ruby"
      expect(page).to have_content "#{ruby_review.title}"
      expect(page).to have_content "#{ruby_review.content}"
      expect(page).to have_content ruby_review.rate.to_s
      expect(page).to have_content "1分前"
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
    end
  end
end
