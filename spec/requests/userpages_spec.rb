RSpec.describe "Userpage", type: :request do
  let!(:user) { create(:user, profile: "aaaaaaa", sex: 0, avatar: fixture_file_upload("spec/fixtures/img/avatar/avatar.png", "avatar/png")) }
  let!(:second_user) { create(:second_user) }
  let!(:great_review) { create(:great_review) }

  describe "#show" do
    context "ログインしている場合" do
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

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        get userpage_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#avatar_destroy" do
    context "ログインしている場合" do
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

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        delete userpage_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
