RSpec.describe "Homes", type: :request do
  describe "GETメソッドのhomeアクションについて" do

    describe "homeページを表示する" do
      before do
        get root_path
      end

      it '正常なレスポンスが返ってくること' do
        expect(response).to be_successful
      end

      it '200レスポンスが返ってくること' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
