RSpec.describe "Rooms", type: :request do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }

  describe "#create" do
    context "ログインしている場合" do
      before do
        login_as(user)
      end

      it '302レスポンスが返ってくること' do
        post rooms_path, params: { entry: { user_id: second_user.id } }
        expect(response).to have_http_status(302)
      end

      it 'DMのルームが作成されること' do
        expect do
          post rooms_path, params: { entry: { user_id: second_user.id } }
        end.to change(Room, :count).by(1)
      end

      it 'エントリーが二つ作成されること' do
        expect do
          post rooms_path, params: { entry: { user_id: second_user.id } }
        end.to change(Entry, :count).by(2)
      end

      it 'リダイレクトすること' do
        post rooms_path, params: { entry: { user_id: second_user.id } }
        expect(response).to redirect_to room_path(Room.first)
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        post rooms_path, params: { entry: { user_id: second_user.id } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#destroy" do
    let!(:room) { create(:room) }
    let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
    let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }

    context "ログインしている場合" do
      before do
        login_as(user)
      end

      it '302レスポンスが返ってくること' do
        delete room_path(room)
        expect(response).to have_http_status(302)
      end

      it 'DMのルームが削除されること' do
        expect do
          delete room_path(room)
        end.to change(Room, :count).by(-1)
      end

      it 'リダイレクトすること' do
        delete room_path(room)
        expect(response).to redirect_to userpage_path(user)
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        delete room_path(room)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#show" do
    let!(:room) { create(:room) }
    let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
    let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }
    let!(:message) { create(:message, user_id: user.id, room_id: room.id) }

    context "ログインしている場合" do
      before do
        login_as(user)
      end

      context "roomが存在する場合" do
        it '200レスポンスが返ってくること' do
          get room_path(room)
          expect(response).to have_http_status(200)
        end

        it '正常なレスポンスが返ってくること' do
          get room_path(room)
          expect(response).to be_successful
        end

        it 'DMページが正しく表示されていること' do
          get room_path(room)
          expect(response.body).to include user.username
          expect(response.body).to include second_user.username
          expect(response.body).to include message.content
        end
      end

      context "roomが存在しない場合" do
        it '302レスポンスが返ってくること' do
          get room_path(2)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ルートページにリダイレクトされること' do
        get room_path(room)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
