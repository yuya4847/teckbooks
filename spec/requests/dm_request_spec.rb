RSpec.describe "Dms", type: :request do
  describe "#show" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:room) { create(:room) }
    let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
    let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }
    let!(:message) { create(:message, user_id: user.id, room_id: room.id) }

    before do
      login_as(user)
    end

    it '200レスポンスが返ってくること' do
      get dm_show_path
      expect(response).to have_http_status(200)
    end

    it '正常なレスポンスが返ってくること' do
      get dm_show_path
      expect(response).to be_successful
    end

    it 'DMページが正しく表示されていること' do
      get dm_show_path
      expect(response.body).to include second_user.username
      expect(response.body).to include message.content
      expect(response.body).to include "#{time_ago_in_words(message.created_at).delete("約").delete("未満") }"
    end
  end
end
