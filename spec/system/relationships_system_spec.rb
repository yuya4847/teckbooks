require 'rails_helper'
RSpec.describe "Relationships", type: :system do
  describe 'フォローできること' do
    describe 'プロフィールページからフォロー機能を検証する' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:relationship) { build(:relationship) }

      it 'フォローできること', js: true do
        log_in_as(user.email, user.password)
        visit '/userpages/2'
        within(".mypage-follow-btn") do
          expect(page).to have_selector 'div', class: "mypage_follow_btn_ajax"
          expect(page).to have_content "follow"
        end
        within(".mypage-follow-btn") do
          find('.mypage_follow_btn_ajax').click
        end
        within(".mypage-follow-btn") do
          expect(page).to have_no_selector 'div', class: "mypage_follow_btn_ajax"
          expect(page).to have_selector 'span', class: "mypage_not_follow_btn_ajax"
          expect(page).to have_content "following"
        end
      end

      it 'アンフォローできること', js: true do
        relationship.save
        log_in_as(user.email, user.password)
        visit '/userpages/2'
        within(".mypage-follow-btn") do
          expect(page).to have_selector 'div', class: "mypage_not_follow_btn_ajax"
          expect(page).to have_content "following"
        end
        within(".mypage-follow-btn") do
          find('.mypage_not_follow_btn_ajax').click
        end
        within(".mypage-follow-btn") do
          expect(page).to have_no_selector 'div', class: "mypage_not_follow_btn_ajax"
          expect(page).to have_selector 'span', class: "mypage_follow_btn_ajax"
          expect(page).to have_content "follow"
        end
      end

      it 'followersが反映されること', js: true do
        log_in_as(user.email, user.password)
        visit '/userpages/2'
        within(".following-and-followers-links") do
          expect(page).to have_content '0 following'
          expect(page).to have_content '0 followers'
        end
        find('.mypage_follow_btn_ajax').click
        within(".following-and-followers-links") do
          expect(page).to have_content '0 following'
          expect(page).to have_content '1 followers'
        end
        find('#followers').click
        expect(current_path).to eq followers_user_path(second_user)
        within(".follow-index-links") do
          expect(page).to have_selector 'div', text: 'Followers'
          expect(page).to have_selector 'a', class: 'follow-index-other-link'
          expect(page).to have_content 'following'
        end
        within(".follow-index-users") do
          expect(page).to have_selector 'a', class: 'follow-index-user'
          expect(page).to have_content "#{user.username}"
        end
        find('.follow-index-user-1').click
        expect(current_path).to eq userpage_path(user)
        within(".following-and-followers-links") do
          expect(page).to have_content '1 following'
          expect(page).to have_content '0 followers'
        end
      end

      it 'followingが反映されること', js: true do
        log_in_as(user.email, user.password)
        visit '/userpages/2'
        within(".following-and-followers-links") do
          expect(page).to have_content '0 following'
          expect(page).to have_content '0 followers'
        end
        find('.mypage_follow_btn_ajax').click
        within(".following-and-followers-links") do
          expect(page).to have_content '0 following'
          expect(page).to have_content '1 followers'
        end
        visit '/userpages/1'
        within(".following-and-followers-links") do
          expect(page).to have_content '1 following'
          expect(page).to have_content '0 followers'
        end
        find('#following').click
        expect(current_path).to eq following_user_path(user)
        within(".follow-index-links") do
          expect(page).to have_selector 'div', text: 'Following'
          expect(page).to have_selector 'a', class: 'follow-index-other-link'
          expect(page).to have_content 'followers'
        end
        within(".follow-index-users") do
          expect(page).to have_selector 'a', class: 'follow-index-user'
          expect(page).to have_content "#{second_user.username}"
        end
        find('.follow-index-user-2').click
        expect(current_path).to eq userpage_path(second_user)
        within(".following-and-followers-links") do
          expect(page).to have_content '0 following'
          expect(page).to have_content '1 followers'
        end
      end
    end

    describe '全投稿一覧ページからフォロー機能を検証する' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:good_review) { create(:good_review, user_id: second_user.id) }
      let!(:relationship) { build(:relationship) }

      it 'フォローできること', js: true do
        log_in_as(user.email, user.password)
        visit '/all_reviews'
        within("#review_#{good_review.id}") do
          within(".follow-div-color") do
            expect(page).to have_selector 'div', class: "follow_btn_ajax"
            expect(page).to have_content "follow"
            find('.follow_btn_ajax').click
          end
        end
        within("#review_#{good_review.id}") do
          within(".follow-div-color") do
            expect(page).to have_no_selector 'div', class: "follow_btn_ajax"
            expect(page).to have_selector 'span', class: "not_follow_btn_ajax"
            expect(page).to have_content "following"
          end
        end
      end

      it 'アンフォローできること', js: true do
        relationship.save
        log_in_as(user.email, user.password)
        visit 'all_reviews'
        within("#review_#{good_review.id}") do
          within(".follow-div-color") do
            expect(page).to have_selector 'div', class: "not_follow_btn_ajax"
            expect(page).to have_content "following"
            find('.not_follow_btn_ajax').click
          end
        end
        within("#review_#{good_review.id}") do
          within(".follow-div-color") do
            expect(page).to have_no_selector 'div', class: "not_follow_btn_ajax"
            expect(page).to have_selector 'span', class: "follow_btn_ajax"
            expect(page).to have_content "follow"
          end
        end
      end
    end

    describe '投稿詳細ページからフォロー機能を検証する' do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:good_review) { create(:good_review, user_id: second_user.id) }
      let!(:relationship) { build(:relationship) }

      it 'フォローできること', js: true do
        log_in_as(user.email, user.password)
        visit '/reviews/1'
        within(".follow-div-color") do
          expect(page).to have_selector 'div', class: "follow_btn_ajax"
          expect(page).to have_content "follow"
          find('.follow_btn_ajax').click
        end
        within(".follow-div-color") do
          expect(page).to have_no_selector 'div', class: "follow_btn_ajax"
          expect(page).to have_selector 'span', class: "not_follow_btn_ajax"
          expect(page).to have_content "following"
        end
      end

      it 'アンフォローできること', js: true do
        relationship.save
        log_in_as(user.email, user.password)
        visit '/reviews/1'
        within(".follow-div-color") do
          expect(page).to have_selector 'div', class: "not_follow_btn_ajax"
          expect(page).to have_content "following"
          find('.not_follow_btn_ajax').click
        end
        within(".follow-div-color") do
          expect(page).to have_no_selector 'div', class: "not_follow_btn_ajax"
          expect(page).to have_selector 'span', class: "follow_btn_ajax"
          expect(page).to have_content "follow"
        end
      end
    end

    describe 'ユーザーの投稿一覧ページからフォロー機能を検証する' do
      describe '友達を見つけよう！からフォロー機能を検証する' do
        let!(:user) { create(:user) }
        let!(:second_user) { create(:second_user) }
        let!(:third_user) { create(:third_user) }
        let!(:relationship) { create(:relationship) }

        it 'フォローできること', js: true do
          log_in_as(user.email, user.password)
          visit '/userpages/profile_reviews/1'
          within("#unknown_users") do
            within("#follow-div#{third_user.id}") do
              expect(page).to have_selector 'div', class: "mypage_reviews_follow_btn_ajax"
              expect(page).to have_content "follow"
              find('.mypage_reviews_follow_btn_ajax').click
            end
          end
          within("#unknown_users") do
            within("#follow-div#{third_user.id}") do
              expect(page).to have_no_selector 'div', class: "mypage_reviews_follow_btn_ajax"
              expect(page).to have_selector 'span', class: "mypage_reviews_not_follow_btn_ajax"
              expect(page).to have_content "following"
            end
          end
        end

        it 'アンフォローできること', js: true do
          log_in_as(user.email, user.password)
          visit '/userpages/profile_reviews/1'
          within("#unknown_users") do
            within("#follow-div#{third_user.id}") do
              find('.mypage_reviews_follow_btn_ajax').click
              expect(page).to have_selector 'span', class: "mypage_reviews_not_follow_btn_ajax"
              expect(page).to have_content "following"
              find('.mypage_reviews_not_follow_btn_ajax').click
              expect(page).to have_selector 'span', class: "mypage_reviews_follow_btn_ajax"
              expect(page).to have_content "follow"
            end
          end
        end
      end

      describe '知り合いかも？からフォロー機能を検証する' do
        let!(:user) { create(:user) }
        let!(:second_user) { create(:second_user) }
        let!(:third_user) { create(:third_user) }
        let!(:relationship) { create(:relationship) }
        let!(:second_relationship) { create(:relationship, follower_id: second_user.id, followed_id: third_user.id) }

        it 'フォローできること', js: true do
          log_in_as(user.email, user.password)
          visit '/userpages/profile_reviews/1'
          within("#may_friend_users") do
            within("#follow-div#{third_user.id}") do
              expect(page).to have_selector 'div', class: "mypage_reviews_follow_btn_ajax"
              expect(page).to have_content "follow"
              find('.mypage_reviews_follow_btn_ajax').click
            end
          end
          within("#may_friend_users") do
            within("#follow-div#{third_user.id}") do
              expect(page).to have_no_selector 'div', class: "mypage_reviews_follow_btn_ajax"
              expect(page).to have_selector 'span', class: "mypage_reviews_not_follow_btn_ajax"
              expect(page).to have_content "following"
            end
          end
        end

        it 'フォローできること', js: true do
          log_in_as(user.email, user.password)
          visit '/userpages/profile_reviews/1'
          within("#may_friend_users") do
            within("#follow-div#{third_user.id}") do
              find('.mypage_reviews_follow_btn_ajax').click
              expect(page).to have_selector 'span', class: "mypage_reviews_not_follow_btn_ajax"
              expect(page).to have_content "following"
              find('.mypage_reviews_not_follow_btn_ajax').click
              expect(page).to have_selector 'span', class: "mypage_reviews_follow_btn_ajax"
              expect(page).to have_content "follow"
            end
          end
        end
      end

      describe '友達を見つけよう！にユーザーが存在しない場合の検証' do
        let!(:user) { create(:user) }

        it '友達を見つけよう！一覧が発見されないこと', js: true do
          log_in_as(user.email, user.password)
          visit '/userpages/profile_reviews/1'
          expect(page).to have_no_selector 'div', id: "unknown_users"
        end
      end

      describe '知り合いかも？にユーザーが存在しない場合の検証' do
        let!(:user) { create(:user) }

        it '知り合いかも？一覧が発見されないこと', js: true do
          log_in_as(user.email, user.password)
          visit '/userpages/profile_reviews/1'
          expect(page).to have_no_selector 'div', id: "may_friend_users"
        end
      end
    end
  end

  describe 'following一覧が閲覧できること' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:relationship) { create(:relationship) }
    let!(:second_relationship) { create(:relationship, follower_id: user.id, followed_id: third_user.id ) }

    it 'following一覧ページが正しく表示されること' do
      log_in_as(user.email, user.password)
      visit '/userpages/1/following'
      expect(current_path).to eq following_user_path(user)
      within(".follow-index-links") do
        expect(page).to have_selector 'div', text: 'Following'
        expect(page).to have_selector 'a', class: 'follow-index-other-link'
        expect(page).to have_content 'followers'
      end
      within(".follow-index-users") do
        within(".follow-index-user-#{second_user.id}") do
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_selector 'div', text: "#{second_user.username}"
        end
        within(".follow-index-user-#{third_user.id}") do
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_selector 'div', text: "#{third_user.username}"
        end
      end
    end
  end

  describe 'followers一覧が閲覧できること' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:relationship) { create(:relationship) }
    let!(:second_relationship) { create(:relationship, follower_id: user.id, followed_id: third_user.id ) }
    let!(:third_relationship) { create(:relationship, follower_id: second_user.id, followed_id: third_user.id ) }

    it 'followers一覧ページが正しく表示されること' do
      log_in_as(third_user.email, third_user.password)
      visit '/userpages/3/followers'
      expect(current_path).to eq followers_user_path(third_user)
      within(".follow-index-links") do
        expect(page).to have_selector 'div', text: 'Followers'
        expect(page).to have_selector 'a', class: 'follow-index-other-link'
        expect(page).to have_content 'following'
      end
      within(".follow-index-users") do
        within(".follow-index-user-#{user.id}") do
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_selector 'div', text: "#{user.username}"
        end
        within(".follow-index-user-#{second_user.id}") do
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_selector 'div', text: "#{second_user.username}"
        end
      end
    end
  end
end
