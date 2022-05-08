require 'rails_helper'
RSpec.describe "タイトルが適切に表示されていること", type: :system do
  let!(:user) { create(:user, id: 1) }
  let!(:second_user) { create(:second_user, id: 2) }
  let!(:recent_review) { create(:recent_review, id: 1) }
  let!(:good_review) { create(:good_review, id: 2) }
  let!(:great_review) { create(:great_review, id: 3) }
  let!(:room) { create(:room, id: 1) }
  let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id, id: 1) }
  let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id, id: 2) }

  describe 'そのページにおける適切なタイトルが表示されること' do
    it 'ホームページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/'
      expect(page).to have_title "TechBookHub"
    end

    it '利用規約ページのタイトルが表示されること' do
      visit '/homes/terms'
      expect(page).to have_title "利用規約 / TechBookHub"
    end

    it 'プライバシーポリシーページのタイトルが表示されること' do
      visit '/homes/privacy_policy'
      expect(page).to have_title "プライバシーポリシー / TechBookHub"
    end

    it '通知ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/notifications'
      expect(page).to have_title "通知 / TechBookHub"
    end

    it '検索ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/reviews'
      expect(page).to have_title "検索 / TechBookHub"
    end

    it '投稿編集ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/reviews/1/edit'
      expect(page).to have_title "投稿編集 / TechBookHub"
    end

    it '投稿作成ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/reviews/new'
      expect(page).to have_title "投稿作成 / TechBookHub"
    end

    it '全ての投稿ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      expect(page).to have_title "全ての投稿 / TechBookHub"
    end

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

    it 'ユーザーの投稿一覧ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/profile_reviews/1'
      expect(page).to have_title "#{user.username}の投稿一覧 / TechBookHub"
    end

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

    it '投稿詳細ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/reviews/1'
      expect(page).to have_title "投稿詳細 / TechBookHub"
    end

    it 'DMルーム一覧ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/dms'
      expect(page).to have_title "DM(一覧) / TechBookHub"
    end

    it 'DMルームページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/rooms/1'
      expect(page).to have_title "DM(#{second_user.username}) / TechBookHub"
    end

    it 'サインアップページのタイトルが表示されること' do
      visit '/users/sign_up'
      expect(page).to have_title "サインアップ / TechBookHub"
    end

    it 'ログインページのタイトルが表示されること' do
      visit '/users/sign_in'
      expect(page).to have_title "ログイン / TechBookHub"
    end

    it 'プロフィール編集ページのタイトルが表示されること' do
      log_in_as(user.email, user.password)
      visit '/users/edit'
      expect(page).to have_title "プロフィール編集 / TechBookHub"
    end

    it 'パスワード再設定ページのタイトルが表示されること' do
      visit '/users/password/new'
      expect(page).to have_title "パスワード再設定 / TechBookHub"
    end

    it 'アカウント有効化ページのタイトルが表示されること' do
      visit '/users/confirmation/new.user'
      expect(page).to have_title "アカウント有効化 / TechBookHub"
    end
  end
end
