RSpec.describe "Recommends", type: :request do
  describe "全投稿一覧ページからリコメンド機能のrequestが動作する" do
    describe "#recommend_open_modal" do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:third_user) { create(:third_user) }
      let!(:good_review) { create(:good_review) }
      let!(:second_recommend) { create(:recommend, recommend_user_id: user.id, recommended_user_id: second_user.id, review_id: good_review.id) }
      let!(:third_recommend) { create(:recommend, recommend_user_id: user.id, recommended_user_id: third_user.id, review_id: good_review.id) }

      before do
        login_as(user)
      end

      it 'リコメンドの表示リクエストが成功すること' do
        get recommend_open_path, params: { review_id: good_review.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it '正しいjsonデータが返されること' do
        get recommend_open_path, params: { review_id: good_review.id }, xhr: true
        expect(response.parsed_body['click_user_ids'].first).to eq(second_user.id)
        expect(response.parsed_body['click_user_ids'].second).to eq(third_user.id)
      end
    end

    describe "#recommend_open_modal" do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:third_user) { create(:third_user) }
      let!(:good_review) { create(:good_review) }
      let!(:second_recommend) { build(:recommend, recommend_user_id: user.id, recommended_user_id: second_user.id, review_id: good_review.id) }
      let!(:third_recommend) { build(:recommend, recommend_user_id: user.id, recommended_user_id: third_user.id, review_id: good_review.id) }

      before do
        login_as(user)
      end

      context "リコメンドしたユーザーがいない場合" do
        it 'リコメンド完了のリクエストが成功すること' do
          post recommend_user_display_path, params: { review_id: good_review.id, recommend_user_datas: "" }, xhr: true
          expect(response).to have_http_status(200)
        end

        it 'リコメンド済みを削除できること' do
          second_recommend.save
          third_recommend.save
          expect do
            post recommend_user_display_path(), params: { review_id: good_review.id, recommend_user_datas: "" }, xhr: true
          end.to change(Recommend, :count).by(-2)
        end
      end

      context "リコメンドしたユーザーがいる場合" do
        it 'リコメンド完了のリクエストが成功すること' do
          post recommend_user_display_path(), params: { review_id: good_review.id, recommend_user_datas: "#{second_user.id},#{third_user.id}" }, xhr: true
          expect(response).to have_http_status(200)
        end

        it '未リコメンドのユーザーをリコメンドできること' do
          expect do
            post recommend_user_display_path(), params: { review_id: good_review.id, recommend_user_datas: "#{second_user.id},#{third_user.id}" }, xhr: true
          end.to change(Recommend, :count).by(2)
        end

        it 'リコメンド済は削除され、未リコメンドはリコメンドされること' do
          second_recommend.save
          expect do
            post recommend_user_display_path(), params: { review_id: good_review.id, recommend_user_datas: "#{third_user.id}" }, xhr: true
          end.to change(Recommend, :count).by(0)
        end
      end
    end
  end

  describe "投稿詳細ページからリコメンド機能のrequestが動作する" do
    describe "#recommend_open_modal" do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:third_user) { create(:third_user) }
      let!(:good_review) { create(:good_review) }
      let!(:second_recommend) { create(:recommend, recommend_user_id: user.id, recommended_user_id: second_user.id, review_id: good_review.id) }
      let!(:third_recommend) { create(:recommend, recommend_user_id: user.id, recommended_user_id: third_user.id, review_id: good_review.id) }

      before do
        login_as(user)
      end

      it 'リコメンドの表示リクエストが成功すること' do
        get recommend_open_from_show_path, params: { review_id: good_review.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it '正しいjsonデータが返されること' do
        get recommend_open_from_show_path, params: { review_id: good_review.id }, xhr: true
        expect(response.parsed_body['click_user_ids'].first).to eq(second_user.id)
        expect(response.parsed_body['click_user_ids'].second).to eq(third_user.id)
      end
    end

    describe "#recommend_open_modal" do
      let!(:user) { create(:user) }
      let!(:second_user) { create(:second_user) }
      let!(:third_user) { create(:third_user) }
      let!(:good_review) { create(:good_review) }
      let!(:second_recommend) { build(:recommend, recommend_user_id: user.id, recommended_user_id: second_user.id, review_id: good_review.id) }
      let!(:third_recommend) { build(:recommend, recommend_user_id: user.id, recommended_user_id: third_user.id, review_id: good_review.id) }

      before do
        login_as(user)
      end

      context "リコメンドしたユーザーがいない場合" do
        it 'リコメンド完了のリクエストが成功すること' do
          post recommend_user_display_path, params: { review_id: good_review.id, recommend_user_datas: "" }, xhr: true
          expect(response).to have_http_status(200)
        end

        it 'リコメンド済みを削除できること' do
          second_recommend.save
          third_recommend.save
          expect do
            post recommend_user_display_path(), params: { review_id: good_review.id, recommend_user_datas: "" }, xhr: true
          end.to change(Recommend, :count).by(-2)
        end
      end

      context "リコメンドしたユーザーがいる場合" do
        it 'リコメンド完了のリクエストが成功すること' do
          post recommend_user_display_path(), params: { review_id: good_review.id, recommend_user_datas: "#{second_user.id},#{third_user.id}" }, xhr: true
          expect(response).to have_http_status(200)
        end

        it '未リコメンドのユーザーをリコメンドできること' do
          expect do
            post recommend_user_display_path(), params: { review_id: good_review.id, recommend_user_datas: "#{second_user.id},#{third_user.id}" }, xhr: true
          end.to change(Recommend, :count).by(2)
        end

        it 'リコメンド済は削除され、未リコメンドはリコメンドされること' do
          second_recommend.save
          expect do
            post recommend_user_display_path(), params: { review_id: good_review.id, recommend_user_datas: "#{third_user.id}" }, xhr: true
          end.to change(Recommend, :count).by(0)
        end
      end
    end
  end
end
