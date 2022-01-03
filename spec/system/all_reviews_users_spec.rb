require 'rails_helper'
RSpec.describe "Reviews_users", type: :system do
  describe 'all_reviews「友達を探そう！」が正しく表示される' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:relationship) { create(:relationship, follower_id: user.id, followed_id: second_user.id) }

    it '「友達を探そう！」の要素検証をすること' do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      within("#unknown_users") do
        expect(page).to have_selector 'span', text: "#{third_user.username}"
      end
    end

    it '「友達を探そう！」でフォローできること' do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      within("#unknown_users") do
        expect(page).to have_selector 'span', text: "#{third_user.username}"
        click_button 'Follow'
      end
      visit '/userpages/3'
      expect(page).to have_selector 'a', text: "1 followers"
    end
  end

  describe 'all_reviews「知り合いかも？」が正しく表示される' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:forth_user) { create(:unconfirmed_user) }
    let!(:first_relationship) { create(:relationship, follower_id: user.id, followed_id: second_user.id) }
    let!(:second_relationship) { create(:relationship, follower_id: second_user.id, followed_id: third_user.id) }
    let!(:third_relationship) { create(:relationship, follower_id: user.id, followed_id: third_user.id) }
    let!(:forth_relationship) { create(:relationship, follower_id: third_user.id, followed_id: forth_user.id) }

    it '「知り合いかも？」の要素検証をすること' do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      within("#may_friend_users") do
        expect(page).to have_no_selector 'span', text: "#{third_user.username}"
        expect(page).to have_selector 'span', text: "#{forth_user.username}"
      end
    end

    it '「知り合いかも？」でフォローできること' do
      log_in_as(user.email, user.password)
      visit '/all_reviews'
      within("#may_friend_users") do
        click_button 'Follow'
      end
      visit '/userpages/4'
      expect(page).to have_selector 'a', text: "2 followers"
    end
  end
end
