include ActionView::Helpers::DateHelper
RSpec.describe "Api_search", type: :request do

  describe "ログイン後のトップページにおけるサジェストの動作確認" do
    let!(:user) { create(:user) }

    before do
      login_as(user)
      get homes_suggest_path, params: { suggest_content: "ruby" }
    end

    it 'フォローのリクエストが成功する' do
      expect(response).to have_http_status(200)
    end

    it '正しいjsonデータが返されること' do
      expect(response.parsed_body['suggest_books'][0]).to eq("プロを目指す人のためのRuby入門［改訂2版］　言語仕様からテスト駆動開発・デバッグ技法まで")
    end
  end

  describe "ログイン後のトップページにおける検索の動作確認" do
    let!(:user) { create(:user) }

    before do
      login_as(user)
      get homes_search_path, params: { search_content: "ruby" }
    end

    it 'フォローのリクエストが成功する' do
      expect(response).to have_http_status(200)
    end

    it '正しいjsonデータが返されること' do
      expect(response.parsed_body['content']).to include "プロを目指す人のためのRuby入門［改訂2版］　言語仕様からテスト駆動開発・デバッグ技法まで"
      expect(response.parsed_body['content']).to include "3278円"
      expect(response.parsed_body['content']).to include "2021年12月02日頃"
      expect(response.parsed_body['content']).to include "Ｒｕｂｙの基礎知識からプロの現場で必須のテクニックまで、丁寧に解説。Ｒａｉｌｓアプリの開発が「..."
    end
  end
end
