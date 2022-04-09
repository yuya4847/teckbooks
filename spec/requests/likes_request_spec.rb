RSpec.describe "Likes", type: :request do
  describe "全投稿一覧ページからlike・like解除を行う" do
    let!(:user) { create(:user) }
    let!(:good_review) { create(:good_review) }
    let!(:like) { build(:like) }

    before do
      login_as(user)
    end

    describe "#create" do
      it 'likeのリクエストが成功する' do
        post like_from_allreviews_path, params: { review_id: good_review.id }
        expect(response).to have_http_status(200)
      end

      it 'likeが1件増える' do
        expect do
          post like_from_allreviews_path, params: { review_id: good_review.id }
        end.to change(Like, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post like_from_allreviews_path, params: { review_id: good_review.id }
        expect(response.parsed_body['like_review_id']).to eq(good_review.id)
      end
    end

    describe "#destroy" do
      it 'unlikeのリクエストが成功する' do
        like.save
        post not_like_from_allreviews_path, params: { id: like.id }
        expect(response).to have_http_status(200)
      end

      it 'likeが1件減る' do
        like.save
        expect do
          post not_like_from_allreviews_path, params: { id: like.id }
        end.to change(Like, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        like.save
        post not_like_from_allreviews_path, params: { id: like.id }
        expect(response.parsed_body['not_like_review_id']).to eq(good_review.id)
      end
    end

    describe "#create(ajax)" do
      it 'likeのリクエストが成功する' do
        post like_from_allreviews_path, params: { review_id: good_review.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'likeが1件増える' do
        expect do
          post like_from_allreviews_path, params: { review_id: good_review.id }, xhr: true
        end.to change(Like, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post like_from_allreviews_path, params: { review_id: good_review.id }, xhr: true
        expect(response.parsed_body['like_review_id']).to eq(good_review.id)
      end
    end

    describe "#destroy(ajax)" do
      it 'unlikeのリクエストが成功する' do
        like.save
        post not_like_from_allreviews_path, params: { id: like.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'likeが1件減る' do
        like.save
        expect do
          post not_like_from_allreviews_path, params: { id: like.id }, xhr: true
        end.to change(Like, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        like.save
        post not_like_from_allreviews_path, params: { id: like.id }, xhr: true
        expect(response.parsed_body['not_like_review_id']).to eq(good_review.id)
      end
    end
  end

  describe "投稿詳細ページからlike・like解除を行う" do
    let!(:user) { create(:user) }
    let!(:good_review) { create(:good_review) }
    let!(:like) { build(:like) }

    before do
      login_as(user)
    end

    describe "#create" do
      it 'likeのリクエストが成功する' do
        post like_from_showreview_path, params: { review_id: good_review.id }
        expect(response).to have_http_status(200)
      end

      it 'likeが1件増える' do
        expect do
          post like_from_showreview_path, params: { review_id: good_review.id }
        end.to change(Like, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post like_from_showreview_path, params: { review_id: good_review.id }
        expect(response.parsed_body['like_review_id']).to eq(good_review.id)
      end
    end

    describe "#destroy" do
      it 'unlikeのリクエストが成功する' do
        like.save
        post not_like_froms_showreview_path, params: { id: like.id }
        expect(response).to have_http_status(200)
      end

      it 'likeが1件減る' do
        like.save
        expect do
          post not_like_froms_showreview_path, params: { id: like.id }
        end.to change(Like, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        like.save
        post not_like_froms_showreview_path, params: { id: like.id }
        expect(response.parsed_body['not_like_review_id']).to eq(good_review.id)
      end
    end

    describe "#create(ajax)" do
      it 'likeのリクエストが成功する' do
        post like_from_showreview_path, params: { review_id: good_review.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'likeが1件増える' do
        expect do
          post like_from_showreview_path, params: { review_id: good_review.id }, xhr: true
        end.to change(Like, :count).by(1)
      end

      it '正しいjsonデータが返されること' do
        post like_from_showreview_path, params: { review_id: good_review.id }, xhr: true
        expect(response.parsed_body['like_review_id']).to eq(good_review.id)
      end
    end

    describe "#destroy(ajax)" do
      it 'unlikeのリクエストが成功する' do
        like.save
        post not_like_froms_showreview_path, params: { id: like.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'likeが1件減る' do
        like.save
        expect do
          post not_like_froms_showreview_path, params: { id: like.id }, xhr: true
        end.to change(Like, :count).by(-1)
      end

      it '正しいjsonデータが返されること' do
        like.save
        post not_like_froms_showreview_path, params: { id: like.id }, xhr: true
        expect(response.parsed_body['not_like_review_id']).to eq(good_review.id)
      end
    end
  end
end
