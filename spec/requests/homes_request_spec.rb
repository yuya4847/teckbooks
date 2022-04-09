include ActionView::Helpers::DateHelper
RSpec.describe "Homes", type: :request do

  describe "#guest_sign_in" do
    let!(:sample_user) { create(:user, email: 'example@samp.com') }
    let!(:good_review) { create(:good_review) }

    before do
      get guest_sign_in_path(good_review.id)
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(302)
    end

    it '投稿詳細ページへリダイレクトされること' do
      expect(response).to redirect_to userpage_path(sample_user.id)
    end
  end

  describe "#guest_sign_in_review_show" do
    let!(:sample_user) { create(:user, email: 'example@samp.com') }
    let!(:good_review) { create(:good_review) }

    before do
      get guest_sign_in_review_show_path(good_review.id)
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(302)
    end

    it '投稿詳細ページへリダイレクトされること' do
      expect(response).to redirect_to review_path(good_review.id)
    end
  end

  describe "#home" do
    let!(:user) { create(:user) }
    let!(:good_review) { create(:good_review) }
    let!(:recent_review) { create(:recent_review) }
    let!(:great_review) { create(:great_review) }

    before do
      get root_path
    end

    it '正常なレスポンスが返ってくること' do
      expect(response).to be_successful
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end

    it 'サンプルの投稿が正しく表示されていること' do
      expect(response.body).to include good_review.title
      expect(response.body).to include good_review.content
      expect(response.body).to include "#{I18n.l(good_review.created_at)}"

      expect(response.body).to include recent_review.title
      expect(response.body).to include recent_review.content
      expect(response.body).to include "#{I18n.l(recent_review.created_at)}"

      expect(response.body).to include great_review.title
      expect(response.body).to include great_review.content
      expect(response.body).to include "#{I18n.l(great_review.created_at)}"
    end
  end

  describe "#terms" do
    before do
      get show_terms_path
    end

    it '正常なレスポンスが返ってくること' do
      expect(response).to be_successful
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end
  end

  describe "#privacy_policy" do
    before do
      get show_privacy_policy_path
    end

    it '正常なレスポンスが返ってくること' do
      expect(response).to be_successful
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end
  end
end
