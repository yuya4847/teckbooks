RSpec.describe "Messages", type: :request do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }
  let!(:room) { create(:room) }
  let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
  let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }

  describe "#create" do
    context "ログインしている場合" do
      before do
        login_as(user)
      end

      it 'messageのリクエストが成功する' do
        post messages_path, params: { message: { user_id: user.id, content: "こんにちは", room_id: room.id } }, xhr: true
        expect(response).to have_http_status(200)
      end

      it 'messageが1件増える' do
        expect do
          post messages_path, params: { message: { user_id: user.id, content: "こんにちは", room_id: room.id } }, xhr: true
        end.to change(Message, :count).by(1)
      end

      it 'messageのリクエストが成功する' do
        post messages_path, params: { message: { user_id: user.id, content: "こんにちは", room_id: room.id } }, xhr: true
        expect(response.body).to include "こんにちは"
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        post messages_path, params: { message: { user_id: user.id, content: "こんにちは", room_id: room.id } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
