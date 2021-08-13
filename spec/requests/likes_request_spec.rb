RSpec.describe "Likes", type: :request do
  let!(:user) { create(:user) }
  let!(:good_review) { create(:good_review) }
  let!(:like) { build(:like) }

  before do
    login_as(user)
  end

  describe "#create" do
    it 'likeのリクエストが成功する' do
      post likes_path, params: { review_id: good_review.id }
      expect(response).to have_http_status(302)
    end

    it 'likeが1件増える' do
      expect do
        post likes_path, params: { review_id: good_review.id }
      end.to change(Like, :count).by(1)
    end
  end

  describe "#destroy" do
    it 'unlikeのリクエストが成功する' do
      like.save
      delete like_path(like.id)
      expect(response).to have_http_status(302)
    end

    it 'likeが1件減る' do
      like.save
      expect do
        delete like_path(like.id)
      end.to change(Like, :count).by(-1)
    end
  end

  describe "#create(ajax)" do
    it 'likeのリクエストが成功する' do
      post likes_path, params: { review_id: good_review.id }, xhr: true
      expect(response).to have_http_status(200)
    end

    it 'likeが1件増える' do
      expect do
        post likes_path, params: { review_id: good_review.id }, xhr: true
      end.to change(Like, :count).by(1)
    end
  end

  describe "#destroy(ajax)" do
    it 'unlikeのリクエストが成功する' do
      like.save
      delete like_path(like.id), xhr: true
      expect(response).to have_http_status(200)
    end

    it 'likeが1件減る' do
      like.save
      expect do
        delete like_path(like.id), xhr: true
      end.to change(Like, :count).by(-1)
    end
  end
end
