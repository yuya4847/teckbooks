RSpec.describe "Follows", type: :request do
  describe "プロフィールページからフォロー・フォロー解除を行う" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:relationship) { build(:relationship) }

    before do
      login_as(user)
    end

    describe "#create" do
      it 'フォローのリクエストが成功する' do
        post follow_from_userpage_profile_path, params: { user_id: second_user.id }
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件増える' do
        expect do
          post follow_from_userpage_profile_path, params: { user_id: second_user.id }
        end.to change(Relationship, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post follow_from_userpage_profile_path, params: { user_id: second_user.id }
        expect(response.parsed_body['follow_user_id']).to eq(second_user.id)
        expect(response.parsed_body['followers_count']).to eq(Relationship.count)
      end
    end

    describe "#destroy" do
      it 'アンフォローのリクエストが成功する' do
        relationship.save
        post unfollow_from_userpage_profile_path, params: { user_id: second_user.id }
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件減る' do
        relationship.save
        expect do
          post unfollow_from_userpage_profile_path, params: { user_id: second_user.id }
        end.to change(Relationship, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        relationship.save
        post unfollow_from_userpage_profile_path, params: { user_id: second_user.id }
        expect(response.parsed_body['not_follow_user_id']).to eq(second_user.id)
        expect(response.parsed_body['followers_count']).to eq(Relationship.count)
      end
    end

    describe "#create(ajax)" do
      it 'フォローのリクエストが成功する' do
        post follow_from_userpage_profile_path, params: { user_id: second_user.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件増える' do
        expect do
          post follow_from_userpage_profile_path, params: { user_id: second_user.id }, xhr: true
        end.to change(Relationship, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post follow_from_userpage_profile_path, params: { user_id: second_user.id }, xhr: true
        expect(response.parsed_body['follow_user_id']).to eq(second_user.id)
        expect(response.parsed_body['followers_count']).to eq(Relationship.count)
      end
    end

    describe "#destroy(ajax)" do
      it 'アンフォローのリクエストが成功する' do
        relationship.save
        post unfollow_from_userpage_profile_path, params: { user_id: second_user.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件減る' do
        relationship.save
        expect do
          post unfollow_from_userpage_profile_path, params: { user_id: second_user.id }, xhr: true
        end.to change(Relationship, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        relationship.save
        post unfollow_from_userpage_profile_path, params: { user_id: second_user.id }, xhr: true
        expect(response.parsed_body['not_follow_user_id']).to eq(second_user.id)
        expect(response.parsed_body['followers_count']).to eq(Relationship.count)
      end
    end
  end

  describe "ユーザーの投稿一覧からページからフォロー・フォロー解除を行う" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:relationship) { build(:relationship) }

    before do
      login_as(user)
    end

    describe "#create" do
      it 'フォローのリクエストが成功する' do
        post follow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件増える' do
        expect do
          post follow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }
        end.to change(Relationship, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post follow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }
        expect(response.parsed_body['follow_user_id']).to eq(second_user.id)
        expect(response.parsed_body['followers_count']).to eq(Relationship.count)
      end
    end

    describe "#destroy" do
      it 'アンフォローのリクエストが成功する' do
        relationship.save
        post unfollow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件減る' do
        relationship.save
        expect do
          post unfollow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }
        end.to change(Relationship, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        relationship.save
        post unfollow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }
        expect(response.parsed_body['not_follow_user_id']).to eq(second_user.id)
        expect(response.parsed_body['followers_count']).to eq(Relationship.count)
      end
    end

    describe "#create(ajax)" do
      it 'フォローのリクエストが成功する' do
        post follow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件増える' do
        expect do
          post follow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }, xhr: true
        end.to change(Relationship, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post follow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }, xhr: true
        expect(response.parsed_body['follow_user_id']).to eq(second_user.id)
        expect(response.parsed_body['followers_count']).to eq(Relationship.count)
      end
    end

    describe "#destroy(ajax)" do
      it 'アンフォローのリクエストが成功する' do
        relationship.save
        post unfollow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件減る' do
        relationship.save
        expect do
          post unfollow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }, xhr: true
        end.to change(Relationship, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        relationship.save
        post unfollow_from_userpage_profile_reviews_path, params: { user_id: second_user.id }, xhr: true
        expect(response.parsed_body['not_follow_user_id']).to eq(second_user.id)
        expect(response.parsed_body['followers_count']).to eq(Relationship.count)
      end
    end
  end

  describe "全投稿一覧ページからフォロー・フォロー解除を行う" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:recent_review) { create(:recent_review) }
    let!(:relationship) { build(:relationship) }

    before do
      login_as(user)
    end

    describe "#create" do
      it 'フォローのリクエストが成功する' do
        post follow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件増える' do
        expect do
          post follow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }
        end.to change(Relationship, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post follow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }
        expect(response.parsed_body['follow_review_id']).to eq(recent_review.id)
        expect(response.parsed_body['follow_user_id']).to eq(second_user.id)
      end
    end

    describe "#destroy" do
      it 'アンフォローのリクエストが成功する' do
        relationship.save
        post unfollow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件減る' do
        relationship.save
        expect do
          post unfollow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }
        end.to change(Relationship, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        relationship.save
        post unfollow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }
        expect(response.parsed_body['not_follow_review_id']).to eq(recent_review.id)
        expect(response.parsed_body['not_follow_user_id']).to eq(second_user.id)
      end
    end

    describe "#create(ajax)" do
      it 'フォローのリクエストが成功する' do
        post follow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件増える' do
        expect do
          post follow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        end.to change(Relationship, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post follow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        expect(response.parsed_body['follow_review_id']).to eq(recent_review.id)
        expect(response.parsed_body['follow_user_id']).to eq(second_user.id)
      end
    end

    describe "#destroy(ajax)" do
      it 'アンフォローのリクエストが成功する' do
        relationship.save
        post unfollow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件減る' do
        relationship.save
        expect do
          post unfollow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        end.to change(Relationship, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        relationship.save
        post unfollow_from_allreviews_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        expect(response.parsed_body['not_follow_review_id']).to eq(recent_review.id)
        expect(response.parsed_body['not_follow_user_id']).to eq(second_user.id)
      end
    end
  end

  describe "投稿詳細ページからフォロー・フォロー解除を行う" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:recent_review) { create(:recent_review) }
    let!(:relationship) { build(:relationship) }

    before do
      login_as(user)
    end

    describe "#create" do
      it 'フォローのリクエストが成功する' do
        post follow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件増える' do
        expect do
          post follow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }
        end.to change(Relationship, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post follow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }
        expect(response.parsed_body['follow_review_id']).to eq(recent_review.id)
        expect(response.parsed_body['follow_user_id']).to eq(second_user.id)
      end
    end

    describe "#destroy" do
      it 'アンフォローのリクエストが成功する' do
        relationship.save
        post unfollow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件減る' do
        relationship.save
        expect do
          post unfollow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }
        end.to change(Relationship, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        relationship.save
        post unfollow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }
        expect(response.parsed_body['not_follow_review_id']).to eq(recent_review.id)
        expect(response.parsed_body['not_follow_user_id']).to eq(second_user.id)
      end
    end

    describe "#create(ajax)" do
      it 'フォローのリクエストが成功する' do
        post follow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件増える' do
        expect do
          post follow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        end.to change(Relationship, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post follow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        expect(response.parsed_body['follow_review_id']).to eq(recent_review.id)
        expect(response.parsed_body['follow_user_id']).to eq(second_user.id)
      end
    end

    describe "#destroy(ajax)" do
      it 'アンフォローのリクエストが成功する' do
        relationship.save
        post unfollow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'フォローが1件減る' do
        relationship.save
        expect do
          post unfollow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        end.to change(Relationship, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        relationship.save
        post unfollow_from_showreview_path, params: { review_id: recent_review.id , user_id: second_user.id }, xhr: true
        expect(response.parsed_body['not_follow_review_id']).to eq(recent_review.id)
        expect(response.parsed_body['not_follow_user_id']).to eq(second_user.id)
      end
    end
  end
end
