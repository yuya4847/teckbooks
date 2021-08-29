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

    describe "#create(ajax)" do
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
        post response_comments_path(good_review.id, comment.id), params: { comment: { content: response_comment.content } }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'commentが1件増えること' do
        expect do
          post response_comments_path(good_review.id, comment.id), params: { comment: { content: response_comment.content } }, xhr: true
        end.to change(Comment, :count).by(1)
      end
    end

    describe "#response_destroy(ajax)" do
      it '返信comment削除のリクエストが成功すること' do
        response_comment.save
        delete response_comment_path(response_comment.id), xhr: true
        expect(response).to have_http_status(200)
      end

      it 'commentが1件減ること' do
        response_comment.save
        expect do
          delete response_comment_path(response_comment.id), xhr: true
        end.to change(Comment, :count).by(-1)
      end
    end

    describe "#cancel_response(ajax)" do
      it '返信commentキャンセルのリクエストが成功すること' do
        post cancel_response_path(comment.id), xhr: true
        expect(response).to have_http_status(200)
      end
    end

    describe "#cancel_comment(ajax)" do
      it 'commentキャンセルのリクエストが成功すること' do
        post cancel_comment_path, xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end
end
