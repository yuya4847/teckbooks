require 'rails_helper'
RSpec.describe "Registrations", type: :system do
  describe 'フォローできること' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:relationship) { create(:relationship) }
    let!(:followed_relationship) { create(:followed_relationship) }

    it 'プロフィールページからフォローとアンフォローがAjaxでできること', js: true do
      log_in_as(user.email, user.password)
      visit '/userpages/2'
      expect(page).to have_content '1 followers'
      click_button 'Unfollow'
      expect(page).to have_content '0 followers'
      click_button 'Follow'
      expect(page).to have_content '1 followers'
    end

    it 'followingが反映されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/1'
      expect(page).to have_content '1 following'
      click_link '1 following'
      expect(current_path).to eq following_user_path(user)
      expect(page).to have_content second_user.username
      visit '/userpages/2'
      click_button 'Unfollow'
      visit '/userpages/1'
      expect(page).to have_content '0 following'
      click_link '0 following'
      expect(page).not_to have_content second_user.username
    end

    it 'followersが反映されること' do
      log_in_as(second_user.email, second_user.password)
      visit '/userpages/1'
      expect(page).to have_content '1 followers'
      click_link '1 followers'
      expect(current_path).to eq followers_user_path(user)
      expect(page).to have_content second_user.username
      visit '/userpages/1'
      click_button 'Unfollow'
      expect(page).to have_content '0 followers'
      click_link '0 followers'
      expect(page).not_to have_content second_user.username
    end
  end

  describe 'following一覧が閲覧できること' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:relationship) { build(:relationship) }
    let!(:second_relationship) { create(:second_relationship) }
    let!(:third_relationship) { create(:third_relationship) }
    let!(:followed_relationship) { create(:followed_relationship) }

    it 'following一覧ページが正しく表示されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/1/following'
      expect(page).to have_content "Following"
      expect(page).to have_content user.username
      expect(page).to have_content user.profile
      expect(page).to have_content "男"
      expect(page).to have_link "アバターを変更する"
      expect(page).to have_link "プロフィール変更"
      expect(page).to have_link '1 following'
      expect(page).to have_link '2 followers'
      expect(page).to have_no_content second_user.username
      expect(page).to have_content third_user.username
      visit '/userpages/2'
      click_button 'Follow'
      visit '/userpages/1/following'
      expect(page).to have_link '2 following'
      expect(page).to have_link '2 followers'
      expect(page).to have_content second_user.username
      expect(page).to have_content third_user.username
    end
  end

  describe 'follower一覧が閲覧できること' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:relationship) { create(:relationship) }
    let!(:second_relationship) { create(:second_relationship) }
    let!(:third_relationship) { create(:third_relationship) }
    let!(:followed_relationship) { build(:followed_relationship) }

    it 'followers一覧ページが正しく表示されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/1/followers'
      expect(page).to have_content "Followers"
      expect(page).to have_content user.username
      expect(page).to have_content user.profile
      expect(page).to have_content "男"
      expect(page).to have_link "アバターを変更する"
      expect(page).to have_link "プロフィール変更"
      expect(page).to have_link '2 following'
      expect(page).to have_link '1 followers'
      expect(page).to have_no_content second_user.username
      expect(page).to have_content third_user.username
      click_link "ログアウト"
      log_in_as(second_user.email, second_user.password)
      visit '/userpages/1'
      click_button 'Follow'
      visit '/userpages/1/following'
      expect(page).to have_link '2 following'
      expect(page).to have_link '2 followers'
      expect(page).to have_content second_user.username
      expect(page).to have_content third_user.username
    end
  end

  describe '投稿一覧ページからフォローできること' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:relationship) { create(:relationship) }

    it '投稿一覧ページからフォローとアンフォローがAjaxでできること', js: true do
      log_in_as(user.email, user.password)
      visit '/reviews'
      expect(page).to have_selector 'form', class: "follow_class"
      within(".follow_class#{third_user.id}") do
        click_button 'Follow'
      end
      expect(page).to have_no_selector 'form', class: "follow_class"
      expect(page).to have_selector 'form', class: "unfollow_class"
      within(".follow_class#{third_user.id}") do
        click_button 'Unfollow'
      end
      expect(page).to have_no_selector 'form', class: "unfollow_class"
      expect(page).to have_selector 'form', class: "follow_class"
    end

    it '投稿一覧ページからのフォローがfollowingとfollowersに反映されること' do
      log_in_as(user.email, user.password)
      visit "/userpages/#{user.id}"
      expect(page).to have_link '1 following'
      visit "/userpages/#{third_user.id}"
      expect(page).to have_link '0 followers'
      visit '/reviews'
      within(".follow_class#{third_user.id}") do
        click_button 'Follow'
      end
      visit "/userpages/#{user.id}"
      expect(page).to have_link '2 following'
      visit "/userpages/#{third_user.id}"
      expect(page).to have_link '1 followers'
    end
  end
end
