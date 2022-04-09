RSpec.describe "Comments", type: :request do

  describe "#コメント機能のrequestが動作する" do
    let!(:user) { create(:user) }
    let!(:good_review) { create(:good_review) }
    let!(:comment) { build(:comment) }

    before do
      login_as(user)
    end

    describe "#create(ajax)" do
      it 'comment投稿のリクエストが成功すること' do
        post review_comments_path(good_review), params: { comment: { content: comment.content } }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'commentが1件増えること' do
        expect do
          post review_comments_path(good_review), params: { comment: { content: comment.content } }, xhr: true
        end.to change(Comment, :count).by(1)
      end
    end

    describe "#destroy(ajax)" do
      it 'comment削除のリクエストが成功すること' do
        comment.save
        delete review_comment_path(good_review.id, comment.id), xhr: true
        expect(response).to have_http_status(200)
      end

      it 'commentが1件減ること' do
        comment.save
        expect do
          delete review_comment_path(good_review.id, comment.id), xhr: true
        end.to change(Comment, :count).by(-1)
      end
    end
  end

  describe "#コメント返信機能のrequestが動作する" do
    let!(:user) { create(:user) }
    let!(:good_review) { create(:good_review) }
    let!(:comment) { create(:comment) }
    let!(:response_comment) { build(:comment, content: "It is nice comment", user_id: user.id, review_id: good_review.id, parent_id: comment.id) }

    before do
      login_as(user)
    end

    describe "#response_create(ajax)" do
      it '返信comment投稿のリクエストが成功すること' do
        post response_comment_create_path, params: { comment: { content: "It is nice comment" } , review_id: good_review.id, user_id: user.id, parent_id: comment.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'commentが1件増えること' do
        expect do
          post response_comment_create_path, params: { comment: { content: "It is nice comment" } , review_id: good_review.id, user_id: user.id, parent_id: comment.id }, xhr: true
        end.to change(Comment, :count).by(1)
      end
    end

    describe "#response_destroy(ajax)" do
      it '返信comment削除のリクエストが成功すること' do
        response_comment.save
        post response_comment_destroy_path, params: { comment_id: response_comment.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'commentが1件減ること' do
        response_comment.save
        expect do
          post response_comment_destroy_path, params: { comment_id: response_comment.id }, xhr: true
        end.to change(Comment, :count).by(-1)
      end
    end
  end
end
