RSpec.describe "Userpage", type: :request do
  describe "GETメソッドのshowアクションについて" do
    let!(:user) { create(:user, profile: "aaaaaaa", sex: 0) }
    let!(:second_user) { create(:second_user) }
    let!(:great_review) { create(:great_review) }
    let!(:normal_review) { create(:normal_review) }

    describe "showページを表示する" do
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
        expect(response.body).to include user.email
        expect(response.body).to include user.profile
        expect(response.body).to include "男"
        expect(response.body).to include great_review.title
        expect(response.body).to include great_review.content
        expect(response.body).to include great_review.rate.to_s
      end
    end
  end
end
