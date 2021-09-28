require 'rails_helper'
RSpec.describe "Reviews", type: :system do
  describe '#all_reviews' do
    let!(:user) { create(:user) }
    let!(:good_review) { build(:good_review) }
    let!(:great_review) { build(:great_review) }

    it '全ての投稿したレビューが表示されること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/reviews/new'
      attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
      fill_in 'review_title', with: good_review.title
      fill_in 'review_link', with: good_review.link
      fill_in 'review_rate', with: good_review.rate
      fill_in 'review_content', with: good_review.content
      click_button 'レビューを投稿する'
      expect(current_path).to eq userpage_path(user)
      within('.notice') do
        expect(page).to have_content 'レビューを投稿しました'
      end
      visit '/reviews/new'
      attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
      fill_in 'review_title', with: great_review.title
      fill_in 'review_link', with: great_review.link
      fill_in 'review_rate', with: great_review.rate
      fill_in 'review_content', with: great_review.content
      click_button 'レビューを投稿する'
      expect(current_path).to eq userpage_path(user)
      within('.notice') do
        expect(page).to have_content 'レビューを投稿しました'
      end
      visit '/all_reviews'
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
      expect(page).to have_content good_review.title
      expect(page).to have_content good_review.content
      expect(page).to have_content good_review.rate
      expect(page).to have_content "1分前"
      expect(page).to have_link good_review.link
      expect(page).to have_xpath "//a[@href='/reviews/1/exist']"
      visit '/all_reviews'
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
      expect(page).to have_content great_review.title
      expect(page).to have_content great_review.content
      expect(page).to have_content great_review.rate
      expect(page).to have_content "1分前"
      expect(page).to have_link great_review.link
      expect(page).to have_xpath "//a[@href='/reviews/2/exist']"
    end

    describe 'インプレッションを表示する' do
      let!(:second_user) { create(:second_user) }
      let!(:normal_review) { build(:normal_review) }
      let!(:recent_review) { build(:recent_review) }

      it 'インプレッションランキングが動的に表示されること' do
        good_review.save
        great_review.save
        normal_review.save
        recent_review.save
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        expect(page).not_to have_selector 'div', id: 'rank'
        visit '/reviews/1'
        visit '/reviews/1'
        visit '/reviews/1'
        visit '/reviews/1'
        visit '/reviews/2'
        visit '/reviews/2'
        visit '/reviews/2'
        visit '/reviews/3'
        visit '/reviews/3'
        visit '/all_reviews'
        within('#impression_rank') do
          expect(page).to have_content "1位"
          expect(page).to have_link "#{good_review.title}"
          expect(page).to have_content "4レビュー"

          expect(page).to have_content "2位"
          expect(page).to have_link "#{great_review.title}"
          expect(page).to have_content "3レビュー"

          expect(page).to have_content "3位"
          expect(page).to have_link "#{normal_review.title}"
          expect(page).to have_content "2レビュー"
        end
        click_link "ログアウト"
        log_in_as(second_user.email, second_user.password)
        visit '/reviews/4'
        visit '/reviews/4'
        visit '/reviews/4'
        visit '/reviews/4'
        visit '/reviews/4'
        visit '/reviews/4'
        visit '/reviews/2'
        visit '/reviews/2'
        visit '/all_reviews'
        within('#impression_rank') do
          expect(page).to have_content "1位"
          expect(page).to have_link "#{recent_review.title}"
          expect(page).to have_content "6レビュー"

          expect(page).to have_content "2位"
          expect(page).to have_link "#{great_review.title}"
          expect(page).to have_content "5レビュー"

          expect(page).to have_content "3位"
          expect(page).to have_link "#{good_review.title}"
          expect(page).to have_content "4レビュー"

          expect(page).not_to have_link "#{normal_review.title}"
          expect(page).not_to have_content "2レビュー"
        end
      end
    end

  end

  describe '#new' do
    let(:user) { create(:user) }

    it 'レビュー登録画面の要素検証すること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/reviews/new'
      expect(page).to have_selector 'span', text: '※必須', count: 3
      expect(page).to have_selector 'label', text: '画像'
      expect(page).to have_selector 'label', text: 'タイトル'
      expect(page).to have_selector 'label', text: 'リンク'
      expect(page).to have_selector 'label', text: '評価'
      expect(page).to have_selector 'label', text: '内容'
      expect(page).to have_selector 'label', text: 'タグ'
      expect(page).to have_selector 'input', class: 'file_form'
      expect(page).to have_selector 'input', class: 'title_form'
      expect(page).to have_selector 'input', class: 'link_form'
      expect(page).to have_selector 'input', class: 'rate_form'
      expect(page).to have_selector 'textarea', id: "review_tag_ids"
      expect(page).to have_selector 'textarea', class: 'content_form'
      expect(page).to have_button 'レビューを投稿する'
    end
  end

  describe '#create' do
    let(:user) { create(:user) }
    let(:good_review) { build(:good_review) }

    context "正しい値で投稿する場合" do
      context "全ての項目を埋めて投稿する場合" do
        it 'それぞれのページで投稿が反映されること' do
          log_in_as(user.email, user.password)
          within('.notice') do
            expect(page).to have_content 'ログインしました'
          end
          visit '/reviews/new'
          attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
          fill_in 'review_title', with: good_review.title
          fill_in 'review_link', with: good_review.link
          fill_in 'review_rate', with: good_review.rate
          fill_in 'review_content', with: good_review.content
          click_button 'レビューを投稿する'
          expect(current_path).to eq userpage_path(user)
          within('.notice') do
            expect(page).to have_content 'レビューを投稿しました'
          end
          expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
          expect(page).to have_link good_review.title
          expect(page).to have_content good_review.content
          expect(page).to have_content good_review.rate
          expect(page).to have_content "1分前"
          expect(page).to have_xpath "//a[@href='/reviews/1/edit']"
          expect(page).to have_link good_review.link
          expect(page).to have_xpath "//a[@href='/reviews/1/exist']"

          visit '/all_reviews'
          expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
          expect(page).to have_link good_review.title
          expect(page).to have_content good_review.content
          expect(page).to have_content good_review.rate
          expect(page).to have_content "1分前"
          expect(page).to have_link good_review.link
          expect(page).to have_xpath "//a[@href='/reviews/1/exist']"

          visit '/reviews/1'
          expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
          expect(page).to have_content good_review.title
          expect(page).to have_content good_review.content
          expect(page).to have_content good_review.rate
          expect(page).to have_content "1分前"
          expect(page).to have_xpath "//a[@href='/reviews/1/edit']"
          expect(page).to have_link good_review.link
          expect(page).to have_xpath "//a[@href='/reviews/1/not_exist']"
        end
      end

      context "必須項目のみを埋めて投稿する場合" do
        it 'それぞれのページで投稿が反映されること' do
          log_in_as(user.email, user.password)
          within('.notice') do
            expect(page).to have_content 'ログインしました'
          end
          visit '/reviews/new'
          attach_file('review[picture]', nil)
          fill_in 'review_title', with: good_review.title
          fill_in 'review_link', with: nil
          fill_in 'review_rate', with: good_review.rate
          fill_in 'review_content', with: good_review.content
          click_button 'レビューを投稿する'
          expect(current_path).to eq userpage_path(user)
          within('.notice') do
            expect(page).to have_content 'レビューを投稿しました'
          end
          expect(page).to have_content("画像はありません")
          expect(page).to have_link good_review.title
          expect(page).to have_content good_review.content
          expect(page).to have_content good_review.rate
          expect(page).to have_content "1分前"
          expect(page).to have_xpath "//a[@href='/reviews/1/edit']"
          expect(page).to have_no_link good_review.link
          expect(page).to have_xpath "//a[@href='/reviews/1/exist']"

          visit '/all_reviews'
          expect(page).to have_content("画像はありません")
          expect(page).to have_link good_review.title
          expect(page).to have_content good_review.content
          expect(page).to have_content good_review.rate
          expect(page).to have_content "1分前"
          expect(page).to have_no_link good_review.link
          expect(page).to have_xpath "//a[@href='/reviews/1/exist']"

          visit '/reviews/1'
          expect(page).to have_content("画像はありません")
          expect(page).to have_content good_review.title
          expect(page).to have_content good_review.content
          expect(page).to have_content good_review.rate
          expect(page).to have_content "1分前"
          expect(page).to have_xpath "//a[@href='/reviews/1/edit']"
          expect(page).to have_no_link good_review.link
          expect(page).to have_xpath "//a[@href='/reviews/1/not_exist']"
        end
      end
    end

    context "正しくない値で投稿する場合" do
      context "値が全てnilの場合" do
        it '投稿画面が再び表示されること' do
          log_in_as(user.email, user.password)
          within('.notice') do
            expect(page).to have_content 'ログインしました'
          end
          visit '/reviews/new'

          fill_in 'review_title', with: nil
          fill_in 'review_link', with: nil
          fill_in 'review_rate', with: nil
          fill_in 'review_content', with: nil
          click_button 'レビューを投稿する'
          expect(page).to have_content '投稿'
          expect(page).to have_content 'The form contains 3 error.'
          expect(page).to have_content 'タイトルを入力してください'
          expect(page).to have_content '評価を入力してください'
          expect(page).not_to have_content '評価は数値で入力してください'
          expect(page).to have_content '内容を入力してください'
        end
      end

      context "適正値を超えている場合" do
        it '投稿画面が再び表示されること' do
          log_in_as(user.email, user.password)
          within('.notice') do
            expect(page).to have_content 'ログインしました'
          end
          visit '/reviews/new'
          fill_in 'review_title', with: 'a' * 51
          fill_in 'review_link', with: nil
          fill_in 'review_rate', with: 6
          fill_in 'review_content', with: 'a' * 251
          click_button 'レビューを投稿する'
          expect(page).to have_content 'タイトルは50文字以内で入力してください'
          expect(page).to have_content '内容は250文字以内で入力してください'
          expect(page).to have_content '評価は1以上5以下の値にしてください'
        end
      end
    end
  end

  describe '#edit' do
    let!(:user) { create(:user) }
    let!(:good_review) { create(:good_review) }

    it 'レビュー編集画面の要素検証すること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/reviews/1/edit'
      expect(page).to have_selector 'span', text: '※必須', count: 3
      expect(page).to have_selector 'label', text: '画像'
      expect(page).to have_selector 'label', text: 'タイトル'
      expect(page).to have_selector 'label', text: 'リンク'
      expect(page).to have_selector 'label', text: '評価'
      expect(page).to have_selector 'label', text: '内容'
      expect(page).to have_selector 'label', text: 'タグ'
      expect(page).to have_selector 'input', class: 'file_edit_form'
      expect(page).to have_selector 'input', id: 'review_tag_ids'
      expect(page).to have_xpath "//input[@class='title_edit_form' and @value='it is good']"
      expect(page).to have_xpath "//input[@class='link_edit_form' and @value='https://qiita.com/']"
      expect(page).to have_xpath "//input[@class='rate_edit_form' and @value='2']"
      textarea = find('.content_edit_form')
      expect(textarea.value).to match 'it is very good'
      expect(page).to have_button '編集完了'
    end
  end

  describe '#update' do
    let!(:user) { create(:user) }
    let!(:good_review) { create(:good_review) }

    it 'レビューの編集がされていること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/reviews/1/edit'

      attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
      fill_in 'review_title', with: "it is wonderful"
      fill_in 'review_link', with: "https://home"
      fill_in 'review_rate', with: 4
      fill_in 'review_content', with: "it is so good"
      click_button '編集完了'
      expect(current_path).to eq userpage_path(user)
      within('.notice') do
        expect(page).to have_content '投稿を編集しました'
      end
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
      expect(page).to have_link "it is wonderful"
      expect(page).to have_content "it is so good"
      expect(page).to have_content 4
      expect(page).to have_content "10分前"
      expect(page).to have_xpath "//a[@href='/reviews/1/edit']"
      expect(page).to have_link "https://home"
      expect(page).to have_xpath "//a[@href='/reviews/1/exist']"

      visit '/all_reviews'
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
      expect(page).to have_content "it is wonderful"
      expect(page).to have_content "it is so good"
      expect(page).to have_content 4
      expect(page).to have_content "10分前"
      expect(page).to have_link "https://home"
      expect(page).to have_xpath "//a[@href='/reviews/1/exist']"

      visit '/reviews/1'
      expect(page).to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
      expect(page).to have_content "it is wonderful"
      expect(page).to have_content "it is so good"
      expect(page).to have_content 4
      expect(page).to have_content "10分前"
      expect(page).to have_xpath "//a[@href='/reviews/1/edit']"
      expect(page).to have_link "https://home"
      expect(page).to have_xpath "//a[@href='/reviews/1/not_exist']"
    end
  end

  describe '#show' do
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:good_review) { create(:good_review) }
    let!(:normal_review) { create(:normal_review) }

    context "レビューが存在しない場合" do
      it '存在しないレビューは閲覧できないこと' do
        log_in_as(second_user.email, second_user.password)
        within('.notice') do
          expect(page).to have_content 'ログインしました'
        end
        visit '/reviews/3'
        expect(current_path).to eq root_path
        within('.alert') do
          expect(page).to have_content 'レビューは存在しません。'
        end
      end
    end

    context "レビューが存在する場合" do

      it 'レビュー数が動的に表示されること' do
        log_in_as(second_user.email, second_user.password)
        visit '/reviews/2'
        within('#impression_count') do
          expect(page).to have_content '1レビュー'
        end
        visit current_path
        within('#impression_count') do
          expect(page).to have_content '2レビュー'
        end
        click_link "ログアウト"
        log_in_as(third_user.email, third_user.password)
        visit '/reviews/2'
        within('#impression_count') do
          expect(page).to have_content '3レビュー'
        end
      end

      context "自分の投稿を閲覧する場合" do
        let!(:ruby_tag) { create(:tag, name: "ruby") }
        let!(:php_tag) { create(:tag, name: "php") }
        let!(:python_tag) { create(:tag, name: "python") }

        let!(:ruby_tag_relationship) { create(:tag_relationship, review_id: good_review.id, tag_id: ruby_tag.id) }
        let!(:php_tag_relationship) { create(:tag_relationship, review_id: good_review.id, tag_id: php_tag.id) }
        let!(:python_tag_relationship) { create(:tag_relationship, review_id: good_review.id, tag_id: python_tag.id) }

        let!(:related_first_review) { create(:good_review, title: "It is first good review", content: "It is first very good review") }
        let!(:related_second_review) { create(:good_review, title: "It is second good review", content: "It is second very good review") }
        let!(:related_third_review) { create(:good_review, title: "It is third good review", content: "It is third very good review") }
        let!(:related_forth_review) { create(:good_review, title: "It is forth good review", content: "It is forth very good review") }
        let!(:related_fifth_review) { create(:good_review, title: "It is fifth good review", content: "It is fifth very good review") }
        let!(:related_sixth_review) { create(:good_review, title: "It is sixth good review", content: "It is sixth very good review") }
        let!(:related_seventh_review) { create(:good_review, title: "It is seventh good review", content: "It is seventh very good review") }
        let!(:related_eighth_review) { build(:good_review, title: "It is eighth good review", content: "It is eighth very good review") }

        let!(:first_ruby_tag_relationship) { create(:tag_relationship, review_id: related_first_review.id, tag_id: ruby_tag.id) }
        let!(:second_php_tag_relationship) { create(:tag_relationship, review_id: related_second_review.id, tag_id: php_tag.id) }
        let!(:third_python_tag_relationship) { create(:tag_relationship, review_id: related_third_review.id, tag_id: python_tag.id) }
        let!(:forth_ruby_tag_relationship) { create(:tag_relationship, review_id: related_forth_review.id, tag_id: ruby_tag.id) }
        let!(:fifth_ruby_tag_relationship) { create(:tag_relationship, review_id: related_fifth_review.id, tag_id: php_tag.id) }
        let!(:sixth_ruby_tag_relationship) { create(:tag_relationship, review_id: related_sixth_review.id, tag_id: python_tag.id) }
        let!(:seventh_ruby_tag_relationship) { create(:tag_relationship, review_id: related_seventh_review.id, tag_id: ruby_tag.id) }
        let!(:eighth_ruby_tag_relationship) { build(:tag_relationship, review_id: related_eighth_review.id, tag_id: python_tag.id) }

        it '編集・削除へのリンク・コンテンツがあること' do
          log_in_as(second_user.email, second_user.password)
          visit '/reviews/1'
          expect(page).to have_content second_user.username
          expect(page).to have_content good_review.title
          expect(page).to have_content good_review.content
          expect(page).to have_content good_review.rate.to_s
          expect(page).to have_content "10分前"
          expect(page).to have_link good_review.link
          expect(page).to have_link '編集する'
          expect(page).to have_link '削除する'
          expect(page).to have_selector 'textarea', id: 'comment_form'
          expect(page).to have_button 'コメント'
          expect(page).to have_button 'キャンセル'
          expect(page).to have_content '0件コメント'
        end

        it '関連した投稿の表示されること' do
          log_in_as(second_user.email, second_user.password)
          visit '/reviews/1'
          within('#related_reviews') do
            expect(page).not_to have_link "#{good_review.title}"
            expect(page).to have_link "#{related_first_review.title}"
            expect(page).to have_content related_first_review.user.username
            expect(page).to have_link "#{related_second_review.title}"
            expect(page).to have_content related_second_review.user.username
            expect(page).to have_link "#{related_third_review.title}"
            expect(page).to have_content related_third_review.user.username
            expect(page).to have_link "#{related_forth_review.title}"
            expect(page).to have_content related_forth_review.user.username
            expect(page).to have_link "#{related_fifth_review.title}"
            expect(page).to have_content related_fifth_review.user.username
            expect(page).to have_link "#{related_sixth_review.title}"
            expect(page).to have_content related_sixth_review.user.username
            expect(page).to have_link "#{related_seventh_review.title}"
            expect(page).to have_content related_seventh_review.user.username
          end
        end

        it '関連した投稿の表示が7つまでであること' do
          related_eighth_review.save
          eighth_ruby_tag_relationship.save
          log_in_as(second_user.email, second_user.password)
          visit '/reviews/1'
          within('#related_reviews') do
            expect(page).to have_selector 'div', class: 'related_review', count: 7
          end
        end

        it '最近見た投稿の表示されること' do
          log_in_as(second_user.email, second_user.password)
          visit '/reviews/8'
          visit '/reviews/7'
          visit '/reviews/6'
          visit '/reviews/5'
          visit '/reviews/4'
          visit '/reviews/3'
          visit '/reviews/2'
          visit '/reviews/1'
          within('#recent_reviews') do
            expect(page).to have_link "#{good_review.title}"
            expect(page).to have_content good_review.user.username
            expect(page).to have_link "#{normal_review.title}"
            expect(page).to have_content normal_review.user.username
            expect(page).to have_link "#{related_first_review.title}"
            expect(page).to have_content related_first_review.user.username
            expect(page).to have_link "#{related_second_review.title}"
            expect(page).to have_content related_second_review.user.username
            expect(page).to have_link "#{related_third_review.title}"
            expect(page).to have_content related_third_review.user.username
            expect(page).to have_link "#{related_forth_review.title}"
            expect(page).to have_content related_forth_review.user.username
            expect(page).to have_link "#{related_fifth_review.title}"
            expect(page).to have_content related_fifth_review.user.username
            expect(page).not_to have_link "#{related_sixth_review.title}"
          end
        end

        it '最近見た投稿が7つまでであること' do
          log_in_as(second_user.email, second_user.password)
          visit '/reviews/1'
          visit '/reviews/2'
          visit '/reviews/3'
          visit '/reviews/4'
          visit '/reviews/5'
          visit '/reviews/6'
          visit '/reviews/7'
          visit '/reviews/8'
          within('#recent_reviews') do
            expect(page).to have_selector 'div', class: 'recent_review', count: 7
          end
        end
      end

      context "他人の投稿を閲覧する場合" do
        let!(:ruby_tag) { create(:tag, name: "ruby") }
        let!(:php_tag) { create(:tag, name: "php") }
        let!(:python_tag) { create(:tag, name: "python") }

        let!(:ruby_tag_relationship) { create(:tag_relationship, review_id: good_review.id, tag_id: ruby_tag.id) }
        let!(:php_tag_relationship) { create(:tag_relationship, review_id: good_review.id, tag_id: php_tag.id) }
        let!(:python_tag_relationship) { create(:tag_relationship, review_id: good_review.id, tag_id: python_tag.id) }

        let!(:ruby_tag_other_relationship) { create(:tag_relationship, review_id: normal_review.id, tag_id: ruby_tag.id) }
        let!(:php_tag_other_relationship) { create(:tag_relationship, review_id: normal_review.id, tag_id: php_tag.id) }

        let!(:related_first_review) { create(:good_review, title: "It is first good review", content: "It is first very good review") }
        let!(:related_second_review) { create(:good_review, title: "It is second good review", content: "It is second very good review") }
        let!(:related_third_review) { create(:good_review, title: "It is third good review", content: "It is third very good review") }
        let!(:related_forth_review) { create(:good_review, title: "It is forth good review", content: "It is forth very good review") }
        let!(:related_fifth_review) { create(:good_review, title: "It is fifth good review", content: "It is fifth very good review") }
        let!(:related_sixth_review) { create(:good_review, title: "It is sixth good review", content: "It is sixth very good review") }
        let!(:related_seventh_review) { create(:good_review, title: "It is seventh good review", content: "It is seventh very good review") }
        let!(:related_eighth_review) { create(:good_review, title: "It is eighth good review", content: "It is eighth very good review") }

        let!(:first_ruby_tag_relationship) { create(:tag_relationship, review_id: related_first_review.id, tag_id: ruby_tag.id) }
        let!(:second_php_tag_relationship) { create(:tag_relationship, review_id: related_second_review.id, tag_id: php_tag.id) }
        let!(:third_python_tag_relationship) { create(:tag_relationship, review_id: related_third_review.id, tag_id: python_tag.id) }
        let!(:forth_ruby_tag_relationship) { create(:tag_relationship, review_id: related_forth_review.id, tag_id: ruby_tag.id) }
        let!(:fifth_ruby_tag_relationship) { create(:tag_relationship, review_id: related_fifth_review.id, tag_id: php_tag.id) }
        let!(:sixth_ruby_tag_relationship) { create(:tag_relationship, review_id: related_sixth_review.id, tag_id: python_tag.id) }
        let!(:seventh_ruby_tag_relationship) { create(:tag_relationship, review_id: related_seventh_review.id, tag_id: ruby_tag.id) }

        it '編集・削除へのリンク・コンテンツがあること' do
          log_in_as(second_user.email, second_user.password)
          within('.notice') do
            expect(page).to have_content 'ログインしました'
          end
          visit '/reviews/2'
          expect(page).to have_content third_user.username
          expect(page).to have_content normal_review.title
          expect(page).to have_content normal_review.content
          expect(page).to have_content normal_review.rate.to_s
          expect(page).to have_content "20分前"
          expect(page).to have_link normal_review.link
          expect(page).not_to have_link '編集する'
          expect(page).not_to have_link '削除する'
        end

        it '関連した投稿の表示されること' do
          log_in_as(second_user.email, second_user.password)
          visit '/reviews/2'
          within('#related_reviews') do
            expect(page).not_to have_link "#{normal_review.title}"
            expect(page).to have_link "#{related_first_review.title}"
            expect(page).to have_content related_first_review.user.username
            expect(page).to have_link "#{related_second_review.title}"
            expect(page).to have_content related_second_review.user.username
            expect(page).to have_link "#{related_forth_review.title}"
            expect(page).to have_content related_forth_review.user.username
            expect(page).to have_link "#{related_fifth_review.title}"
            expect(page).to have_content related_fifth_review.user.username
            expect(page).to have_link "#{related_seventh_review.title}"
            expect(page).to have_content related_seventh_review.user.username
          end
        end
      end
    end
  end

  describe '#review_destroy' do
    let!(:user) { create(:user) }
    let!(:good_review) { build(:good_review) }

    context "showページから削除する場合" do
      it '削除できること' do
        log_in_as(user.email, user.password)
        within('.notice') do
          expect(page).to have_content 'ログインしました'
        end
        visit '/reviews/new'
        attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
        fill_in 'review_title', with: good_review.title
        fill_in 'review_link', with: good_review.link
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        click_button 'レビューを投稿する'
        expect(current_path).to eq userpage_path(user)
        visit '/reviews/1'
        click_link "削除する"
        expect(current_path).to eq userpage_path(user)
        within('.notice') do
          expect(page).to have_content '投稿を削除しました'
        end
        expect(page).not_to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
        expect(page).not_to have_link good_review.title
        expect(page).not_to have_content good_review.content
        expect(page).not_to have_content good_review.rate
        expect(page).not_to have_content "10分前"
        expect(page).not_to have_xpath "//a[@href='/reviews/1/edit']"
        expect(page).not_to have_link good_review.link
        expect(page).not_to have_xpath "//a[@href='/reviews/1/not_exist']"
      end
    end

    context "indexページから削除する場合" do
      it '削除できること' do
        log_in_as(user.email, user.password)
        within('.notice') do
          expect(page).to have_content 'ログインしました'
        end
        visit '/reviews/new'
        attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
        fill_in 'review_title', with: good_review.title
        fill_in 'review_link', with: good_review.link
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        click_button 'レビューを投稿する'
        expect(current_path).to eq userpage_path(user)
        visit '/all_reviews'
        click_link "削除する"
        expect(current_path).to eq all_reviews_path
        within('.notice') do
          expect(page).to have_content '投稿を削除しました'
        end
        expect(page).not_to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
        expect(page).not_to have_link good_review.title
        expect(page).not_to have_content good_review.content
        expect(page).not_to have_content good_review.rate
        expect(page).not_to have_content "10分前"
        expect(page).not_to have_link good_review.link
        expect(page).not_to have_xpath "//a[@href='/reviews/1/exist']"
      end
    end

    context "userpageページから削除する場合" do
      it '削除できること' do
        log_in_as(user.email, user.password)
        within('.notice') do
          expect(page).to have_content 'ログインしました'
        end
        visit '/reviews/new'
        attach_file('review[picture]', "#{Rails.root}/spec/factories/images/test_picture.jpg")
        fill_in 'review_title', with: good_review.title
        fill_in 'review_link', with: good_review.link
        fill_in 'review_rate', with: good_review.rate
        fill_in 'review_content', with: good_review.content
        click_button 'レビューを投稿する'
        expect(current_path).to eq userpage_path(user)
        click_link "削除する"
        expect(current_path).to eq userpage_path(user)
        within('.notice') do
          expect(page).to have_content '投稿を削除しました'
        end
        expect(page).not_to have_selector("img[src$='/uploads_test/review/picture/1/test_picture.jpg']")
        expect(page).not_to have_link good_review.title
        expect(page).not_to have_content good_review.content
        expect(page).not_to have_content good_review.rate
        expect(page).not_to have_content "10分前"
        expect(page).not_to have_xpath "//a[@href='/reviews/1/edit']"
        expect(page).not_to have_link good_review.link
        expect(page).not_to have_xpath "//a[@href='/reviews/1/exist']"
      end
    end
  end
end
