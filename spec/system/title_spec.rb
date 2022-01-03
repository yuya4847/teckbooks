require 'rails_helper'
RSpec.describe "タイトルが適切に表示されていること", type: :system do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }
  let!(:good_review) { create(:good_review) }
  let!(:room) { create(:room) }
  let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
  let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }

  describe 'ホームページのタイトルが表示される' do
    it 'ホームページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/'
      expect(page).to have_title "TechBookHub"
    end
  end

  describe '通知ページのタイトルが表示される' do
    it '通知ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/notifications'
      expect(page).to have_title "通知 / TechBookHub"
    end
  end

  describe '検索ページのタイトルが表示される' do
    it '検索ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/reviews'
      expect(page).to have_title "検索 / TechBookHub"
    end
  end

  describe '投稿編集ページのタイトルが表示される' do
    it '投稿編集ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/reviews/1/edit'
      expect(page).to have_title "投稿編集 / TechBookHub"
    end
  end

  describe '投稿作成ページのタイトルが表示される' do
    it '投稿作成ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/reviews/new'
      expect(page).to have_title "投稿作成 / TechBookHub"
    end
  end

  describe '全ての投稿ページのタイトルが表示される' do
    it '全ての投稿ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      expect(page).to have_title "全ての投稿 / TechBookHub"
    end
  end

  describe 'プロフィールページのタイトルが動的に表示される' do
    it 'ログインしているユーザーのプロフィールページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/1'
      expect(page).to have_title "#{user.username} / TechBookHub"
    end

    it '他のユーザーのプロフィールページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/2'
      expect(page).to have_title "#{second_user.username} / TechBookHub"
    end
  end

  describe 'following・followersページのタイトルが表示される' do
    it 'followingページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/1/following'
      expect(page).to have_title "Following / TechBookHub"
    end

    it 'followersページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/1/followers'
      expect(page).to have_title "Followers / TechBookHub"
    end
  end

  describe '投稿詳細ページのタイトルが表示される' do
    it '投稿詳細ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/reviews/1'
      expect(page).to have_title "投稿詳細 / TechBookHub"
    end
  end

  describe 'DMページのタイトルが表示される' do
    it 'DMページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/rooms/1'
      expect(page).to have_title "DM / TechBookHub"
    end
  end

  describe 'サインアップページのタイトルが表示される' do
    it 'サインアップページのタイトルが表示されること' do
      visit '/users/sign_up'
      expect(page).to have_title "サインアップ / TechBookHub"
    end
  end

  describe 'ログインページのタイトルが表示される' do
    it 'ログインページのタイトルが表示されること' do
      visit '/users/sign_in'
      expect(page).to have_title "ログイン / TechBookHub"
    end
  end

  describe 'プロフィール編集ページのタイトルが表示される' do
    it 'プロフィール編集ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/users/edit'
      expect(page).to have_title "プロフィール編集 / TechBookHub"
    end
  end

  describe 'パスワード再設定ページのタイトルが表示される' do
    it 'パスワード再設定ページのタイトルが表示されること' do
      visit '/users/password/new'
      expect(page).to have_title "パスワード再設定 / TechBookHub"
    end
  end

  describe 'アカウント有効化ページのタイトルが表示される' do
    it 'アカウント有効化ページのタイトルが表示されること' do
      visit '/users/confirmation/new.user'
      expect(page).to have_title "アカウント有効化 / TechBookHub"
    end
  end
end
