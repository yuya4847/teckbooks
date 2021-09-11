RSpec.describe "Reviews", type: :request do
  describe "GETメソッドのhomeアクションについて" do
    let!(:user) { create(:user, profile: "aaaaaaa", sex: 0) }
    let!(:second_user) { create(:second_user, profile: "bbbbbbb", sex: 1) }
    let!(:third_user) { create(:third_user) }
    let!(:relationship) { create(:relationship) }
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

    describe "#edit" do
      context "ログインしている場合" do
        context "レビューが存在する場合" do
          context "レビューを投稿したのがログインしているユーザーの場合" do
            before do
              login_as(user)
              get edit_review_path(good_review)
            end

            it '正常なレスポンスが返ってくること' do
              expect(response).to be_successful
            end

            it '200レスポンスが返ってくること' do
              expect(response).to have_http_status(200)
            end
          end

          context "レビューを投稿したのがログインしているユーザーでないの場合" do
            before do
              login_as(user)
              get edit_review_path(normal_review)
            end

            it '302レスポンスが返ってくること' do
              expect(response).to have_http_status(302)
              expect(response).to redirect_to root_path
            end
          end
        end

        context "レビューが存在しない場合" do
          before do
            login_as(user)
            get edit_review_path(100)
          end

          it '302レスポンスが返ってくること' do
            expect(response).to have_http_status(302)
            expect(response).to redirect_to root_path
          end
        end
      end

      context "未ログインの場合" do
        it 'ログインページにリダイレクトされること' do
          get edit_review_path(good_review)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe "#all_reviews" do
      context "ログインしている場合" do
        context "いいねされている投稿がない場合" do
          let!(:unfollow_user) { create(:unfollow_user) }
          before do
            login_as(user)
            get all_reviews_path
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
            expect(response.body).to include "10分前"
            expect(response.body).to include normal_review.title
            expect(response.body).to include normal_review.link
            expect(response.body).to include normal_review.content
            expect(response.body).to include normal_review.rate.to_s
            expect(response.body).to include "20分前"
          end

          it 'フォローできるユーザーが正しく表示されること' do
            expect(response.body).to include unfollow_user.username
          end
        end

        context "いいねされている投稿がある場合" do
          let!(:bad_review) { create(:bad_review) }
          let!(:user_like_1review) { create(:like, user_id: user.id, review_id: good_review.id) }
          let!(:second_user_like_1review) { create(:like, user_id: second_user.id, review_id: good_review.id) }
          let!(:third_user_like_1review) { create(:like, user_id: third_user.id, review_id: good_review.id) }
          let!(:user_like_2review) { create(:like, user_id: user.id, review_id: normal_review.id) }
          let!(:second_user_like_2review) { create(:like, user_id: second_user.id, review_id: normal_review.id) }
          let!(:user_like_3review) { create(:like, user_id: user.id, review_id: bad_review.id) }

          it 'いいねランキングが正しく表示されること' do
            login_as(user)
            get all_reviews_path
            expect(response.body).to include good_review.likes.count.to_s
            expect(response.body).to include good_review.title
            expect(response.body).to include good_review.user.username
            expect(response.body).to include normal_review.likes.count.to_s
            expect(response.body).to include normal_review.title
            expect(response.body).to include normal_review.user.username
            expect(response.body).to include bad_review.likes.count.to_s
            expect(response.body).to include bad_review.title
            expect(response.body).to include bad_review.user.username
          end
        end
      end

      context "未ログインの場合" do
        it 'ログインページにリダイレクトされること' do
          get all_reviews_path
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe "#show" do
      context "ログインしている場合" do
        context "レビューが存在する場合" do
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

          it 'ユーザーと投稿が正しく表示されていること' do
            expect(response.body).to include user.username
            expect(response.body).to include good_review.title
            expect(response.body).to include good_review.link
            expect(response.body).to include good_review.content
            expect(response.body).to include good_review.rate.to_s
            expect(response.body).to include "10分前"
          end
        end

        context "レビューが存在しない場合" do
          before do
            login_as(user)
            get review_path(100)
          end

          it '302レスポンスが返ってくること' do
            expect(response).to have_http_status(302)
            expect(response).to redirect_to root_path
          end
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
            expect(response).to redirect_to userpage_path(user)
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

    describe "#update" do
      context "ログインしている場合" do
        context "レビューを投稿したのがログインしているユーザーの場合" do
          before do
            login_as(user)
          end

          context "値が適切な場合" do
            it '302レスポンスが返ってくること' do
              patch review_path(good_review), params: { review: attributes_for(:good_review, content: "Im hungry") }
              expect(response).to have_http_status(302)
            end

            it 'ユーザー詳細ページにリダイレクトされること' do
              patch review_path(good_review), params: { review: attributes_for(:good_review, content: "Im hungry") }
              expect(response).to redirect_to userpage_path(user)
            end

            it '投稿が更新されること' do
              expect do
                patch review_path(good_review), params: { review: attributes_for(:good_review, content: "Im hungry") }
              end.to change { Review.find(good_review.id).content }.from(good_review.content).to('Im hungry')
            end
          end

          context "値が不正場合" do
            it '更新されないこと' do
              expect do
                patch review_path(good_review), params: { review: attributes_for(:good_review, content: nil) }
              end.to_not change { Review.find(good_review.id).content }
            end

            it '再度編集ページが表示されること' do
              patch review_path(good_review), params: { review: attributes_for(:good_review, content: nil) }
              expect(response).to render_template(:edit)
            end
          end
        end

        context "レビューを投稿したのがログインしているユーザーでないの場合" do
          before do
            login_as(user)
            patch review_path(normal_review), params: { review: attributes_for(:normal_review, content: "Im hungry") }
          end

          it '302レスポンスが返ってくること' do
            expect(response).to have_http_status(302)
          end

          it 'トップページにリダイレクトされること' do
            expect(response).to redirect_to root_path
          end
        end
      end

      context "未ログインの場合" do
        it 'ログインページにリダイレクトされること' do
          patch review_path(good_review), params: { review: attributes_for(:good_review, content: "Im hungry") }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe "#review_destroy" do
      context "ログインしている場合" do
        context "管理者権限を持ったユーザーが削除する場合" do
          before do
            login_as(user)
          end

          context "レビューを削除したときに元のページが存在する場合" do
            it '302レスポンスが返ってくること' do
              delete review_destroy_path(good_review, "exist")
              expect(response).to have_http_status(302)
            end

            it 'ユーザー詳細ページにリダイレクトされないこと' do
              delete review_destroy_path(good_review, "exist")
              expect(response).to_not redirect_to userpage_path(user)
            end

            it 'レビューが一件減ること' do
              expect do
                delete review_destroy_path(good_review, "exist")
              end.to change(Review, :count).by(-1)
            end
          end

          context "レビューを削除したときに元のページが存在しない場合" do
            it '302レスポンスが返ってくること' do
              delete review_destroy_path(good_review, "not_exist")
              expect(response).to have_http_status(302)
            end

            it 'ユーザー詳細ページにリダイレクトされること' do
              delete review_destroy_path(good_review, "not_exist")
              expect(response).to redirect_to userpage_path(user)
            end

            it 'レビューが一件減ること' do
              expect do
                delete review_destroy_path(good_review, "not_exist")
              end.to change(Review, :count).by(-1)
            end
          end
        end

        context "ユーザーが自分の投稿を削除する場合" do
          before do
            login_as(second_user)
          end

          context "レビューを削除したときに元のページが存在する場合" do
            it '302レスポンスが返ってくること' do
              delete review_destroy_path(normal_review, "exist")
              expect(response).to have_http_status(302)
            end

            it 'ユーザー詳細ページにリダイレクトされないこと' do
              delete review_destroy_path(normal_review, "exist")
              expect(response).to_not redirect_to userpage_path(user)
            end

            it 'レビューが一件減ること' do
              expect do
                delete review_destroy_path(normal_review, "exist")
              end.to change(Review, :count).by(-1)
            end
          end

          context "レビューを削除したときに元のページが存在しない場合" do
            it '302レスポンスが返ってくること' do
              delete review_destroy_path(normal_review, "not_exist")
              expect(response).to have_http_status(302)
            end

            it 'ユーザー詳細ページにリダイレクトされること' do
              delete review_destroy_path(normal_review, "not_exist")
              expect(response).to redirect_to userpage_path(second_user)
            end

            it 'レビューが一件減ること' do
              expect do
                delete review_destroy_path(normal_review, "not_exist")
              end.to change(Review, :count).by(-1)
            end
          end
        end

        context "ユーザーが他人の投稿を削除する場合" do
          before do
            login_as(third_user)
          end

          context "レビューを削除したときに元のページが存在する場合" do
            it '302レスポンスが返ってくること' do
              delete review_destroy_path(normal_review, "exist")
              expect(response).to have_http_status(302)
            end

            it 'トップページにリダイレクトされること' do
              delete review_destroy_path(normal_review, "exist")
              expect(response).to redirect_to root_path
            end

            it 'レビューが削除されないこと' do
              expect do
                delete review_destroy_path(normal_review, "exist")
              end.to_not change(Review, :count)
            end
          end

          context "レビューを削除したときに元のページが存在しない場合" do
            it '302レスポンスが返ってくること' do
              delete review_destroy_path(normal_review, "not_exist")
              expect(response).to have_http_status(302)
            end

            it 'トップページにリダイレクトされること' do
              delete review_destroy_path(normal_review, "not_exist")
              expect(response).to redirect_to root_path
            end

            it 'レビューが削除されないこと' do
              expect do
                delete review_destroy_path(normal_review, "not_exist")
              end.to_not change(Review, :count)
            end
          end
        end
      end

      context "未ログインの場合" do
        it 'ログインページにリダイレクトされること' do
          delete review_destroy_path(good_review, "exist")
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
