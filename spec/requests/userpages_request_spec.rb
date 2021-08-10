RSpec.describe "Userpage", type: :request do
  let!(:user) { create(:user, profile: "aaaaaaa", sex: 0) }
  let!(:second_user) { create(:second_user, profile: "bbbbbbb") }
  let!(:great_review) { create(:great_review) }
  let!(:relationship) { create(:relationship) }

  describe "#show" do
    context "ログインしている場合" do
      context "ユーザーが存在する場合" do
        before do
          login_as(user)
          get userpage_path user.id
        end

        it '正常なレスポンスが返ってくること' do
          expect(response).to be_successful
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '正しいプロフィールや投稿を取得すること' do
          expect(response.body).to include user.username
          expect(response.body).to include user.profile
          expect(response.body).to include user.email
          expect(response.body).to include "男"
          expect(response.body).to include great_review.title
          expect(response.body).to include great_review.content
          expect(response.body).to include great_review.rate.to_s
        end
      end

      context "ユーザーが存在しない場合" do
        before do
          login_as(user)
          get userpage_path(302)
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        get userpage_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#avatar_destroy" do
    context "ログインしている場合" do
      context "ログインしているユーザーであるの場合" do
        before do
          login_as(user)
        end

        it '302レスポンスが返ってくること' do
          delete userpage_path user.id
          expect(response).to have_http_status(302)
        end

        it 'プロフィールページにリダイレクトすること' do
          delete userpage_path user.id
          expect(response).to redirect_to userpage_path
        end
      end

      context "ログインしていないユーザー場合" do
        before do
          login_as(user)
        end

        it '302レスポンスが返ってくること' do
          delete userpage_path second_user.id
          expect(response).to have_http_status(302)
        end

        it 'ルートページにリダイレクトすること' do
          delete userpage_path second_user.id
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        delete userpage_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#following" do
    context "ログインしている場合" do
      context "ユーザーが存在する場合" do
        before do
          login_as(user)
          get following_user_path user.id
        end

        it '正常なレスポンスが返ってくること' do
          expect(response).to be_successful
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '正しいプロフィールとフォローしているユーザーを表示すること' do
          expect(response.body).to include user.username
          expect(response.body).to include user.profile
          expect(response.body).to include user.email
          expect(response.body).to include "男"
          expect(response.body).to include "Following"
          expect(response.body).to include second_user.username
        end
      end

      context "ユーザーが存在しない場合" do
        before do
          login_as(user)
          get following_user_path 100
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        get following_user_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#followers" do
    context "ログインしている場合" do
      context "ユーザーが存在する場合" do
        before do
          login_as(second_user)
          get followers_user_path second_user.id
        end

        it '正常なレスポンスが返ってくること' do
          expect(response).to be_successful
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '正しいプロフィールとフォローしているユーザーを表示すること' do
          expect(response.body).to include second_user.username
          expect(response.body).to include second_user.profile
          expect(response.body).to include second_user.email
          expect(response.body).to include "男"
          expect(response.body).to include "Followers"
          expect(response.body).to include user.username
        end
      end

      context "ユーザーが存在しない場合" do
        before do
          login_as(second_user)
          get followers_user_path 100
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        get followers_user_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
