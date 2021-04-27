RSpec.describe "Reviews", type: :request do
  describe "GETメソッドのhomeアクションについて" do
    let!(:user) { create(:user, profile: "aaaaaaa", sex: 0) }
    let!(:second_user) { create(:second_user, profile: "bbbbbbb", sex: 1) }
    let!(:good_review) { create(:good_review) }
    let!(:normal_review) { create(:normal_review) }
    let!(:recent_review) { build(:recent_review) }

    describe "#new" do
      context "ログインしている場合" do
        before do
          login_as(user)
          get new_review_path
        end

        it '正常なレスポンスが返ってくること' do
          expect(response).to be_successful
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end
      end

      context "未ログインの場合" do
        it 'ログインページにリダイレクトされること' do
          get new_review_path
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe "#index" do
      context "ログインしている場合" do
        before do
          login_as(user)
          get reviews_path
        end

        it '正常なレスポンスが返ってくること' do
          expect(response).to be_successful
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '正しいレビューが全て投稿されている' do
          expect(response.body).to include good_review.title
          expect(response.body).to include good_review.link
          expect(response.body).to include good_review.content
          expect(response.body).to include good_review.rate.to_s
          expect(response.body).to include normal_review.title
          expect(response.body).to include normal_review.link
          expect(response.body).to include normal_review.content
          expect(response.body).to include normal_review.rate.to_s
        end
      end

      context "未ログインの場合" do
        it 'ログインページにリダイレクトされること' do
          get reviews_path
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe "#show" do
      context "ログインしている場合" do
        before do
          login_as(user)
          get review_path good_review.id
        end

        it '正常なレスポンスが返ってくること' do
          expect(response).to be_successful
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '正しいレビューが全て投稿されている' do
          expect(response.body).to include good_review.title
          expect(response.body).to include good_review.link
          expect(response.body).to include good_review.content
          expect(response.body).to include good_review.rate.to_s
        end
      end

      context "未ログインの場合" do
        it 'ログインページにリダイレクトされること' do
          get review_path good_review.id
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe "#create" do
      context "ログインしている場合" do
        context "値が保存可能な場合" do
          before do
            login_as(user)
          end

          it '302レスポンスが返ってくること' do
            post reviews_path, params: { review: attributes_for(:recent_review) }
            expect(response).to have_http_status(302)
          end

          it 'レビューが登録されること' do
            expect do
              post reviews_path, params: { review: attributes_for(:recent_review) }
            end.to change(Review, :count).by(1)
          end

          it 'リダイレクトすること' do
            post reviews_path, params: { review: attributes_for(:recent_review) }
            expect(response).to redirect_to root_path
          end
        end

        context "値が保存不可能な場合" do
          before do
            login_as(user)
          end

          it '200レスポンスが返ってくること' do
            post reviews_path, params: { review: attributes_for(:recent_review, content: nil) }
            expect(response).to have_http_status(200)
          end

          it 'レビューが登録されないこと' do
            expect do
              post reviews_path, params: { review: attributes_for(:recent_review, content: nil) }
            end.not_to change(Review, :count)
          end

          it '投稿ページにリダイレクトすること' do
            post reviews_path, params: { review: attributes_for(:recent_review, content: nil) }
            expect(response.body).to include "投稿"
          end
        end
      end

      context "未ログインの場合" do
        it 'ログインページにリダイレクトされること' do
          post reviews_path, params: { review: attributes_for(:recent_review) }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
