RSpec.describe "Reports", type: :request do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }
  let!(:third_user) { create(:third_user) }
  let!(:unfollow_user) { create(:unfollow_user) }
  let!(:unconfirmed_user) { create(:unconfirmed_user) }

  let!(:good_review) { create(:good_review) }

  let!(:report) { build(:report, user_id: user.id, review_id: good_review.id) }
  let!(:second_report) { build(:report, user_id: second_user.id, review_id: good_review.id) }
  let!(:third_report) { build(:report, user_id: third_user.id, review_id: good_review.id) }
  let!(:forth_report) { build(:report, user_id: unfollow_user.id, review_id: good_review.id) }
  let!(:fifth_report) { build(:report, user_id: unconfirmed_user.id, review_id: good_review.id) }

  before do
    login_as(user)
  end

  describe "#create(ajax)" do
    context "通報する場合" do
      it '通報のリクエストが成功する' do
        post reports_path, params: { review_id: good_review.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'reportが1件増える' do
        expect do
          post reports_path, params: { review_id: good_review.id }, xhr: true
        end.to change(Report, :count).by(1)
      end

      it 'レビューは削除されない' do
        expect do
          post reports_path, params: { review_id: good_review.id }, xhr: true
        end.to change(Review, :count).by(0)
      end
    end

    context "通報して削除される場合" do
      it 'reportが削除される' do
        report.save
        second_report.save
        third_report.save
        forth_report.save
        fifth_report.save
        expect do
          post reports_path, params: { review_id: good_review.id }, xhr: true
          sleep 1
        end.to change(Report, :count).by(-5)
      end

      it 'レビューは削除される' do
        report.save
        second_report.save
        third_report.save
        forth_report.save
        fifth_report.save
        expect do
          post reports_path, params: { review_id: good_review.id }, xhr: true
        end.to change(Review, :count).by(-1)
      end
    end
  end
end
