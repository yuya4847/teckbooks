RSpec.describe "Notifications", type: :request do

  describe "#index" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:room) { create(:room) }
    let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
    let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }
    let!(:message) { create(:message, user_id: user.id, room_id: room.id, content: "こんにちは") }
    let!(:dm_message_notification) { create(:notification,
      visitor_id: user.id,
      visited_id: second_user.id,
      dm_message_id: message.id,
      action: "dm",
      checked: false,
    )}

    before do
      login_as(second_user)
    end

    it '200レスポンスが返ってくること' do
      get notifications_path
      expect(response).to have_http_status(200)
    end

    it '正常なレスポンスが返ってくること' do
      get notifications_path
      expect(response).to be_successful
    end

    it '通知一覧ページを閲覧すると閲覧済になる' do
      expect do
        get notifications_path
      end.to change { Notification.first.checked }.from(false).to(true)
    end

    it '通知一覧ページで通知が表示される' do
      get notifications_path
      expect(response.body).to include user.username
      expect(response.body).to include message.content
    end
  end

  describe "#all_destroy" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:room) { create(:room) }
    let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
    let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }
    let!(:message) { create(:message, user_id: user.id, room_id: room.id, content: "こんにちは") }
    let!(:dm_message_notification) { create(:notification,
      visitor_id: user.id,
      visited_id: second_user.id,
      dm_message_id: message.id,
      action: "dm",
      checked: false,
    )}
    let!(:follow_notification) { create(:notification,
      visitor_id: user.id,
      visited_id: second_user.id,
      action: "follow",
      checked: false,
    )}

    before do
      login_as(second_user)
    end

    it '200レスポンスが返ってくること' do
      delete notifications_destory_path
      expect(response).to have_http_status(200)
    end

    it '正常なレスポンスが返ってくること' do
      delete notifications_destory_path
      expect(response).to be_successful
    end

    it '全ての通知が削除されること' do
      expect do
        delete notifications_destory_path
      end.to change { Notification.count }.from(2).to(0)
    end

    it '通知一覧ページで通知が表示が変更される' do
      get notifications_path
      expect(response.body).to include user.username
      expect(response.body).to include message.content
      delete notifications_destory_path
      expect(response.body).not_to include user.username
      expect(response.body).not_to include message.content
    end
  end

  describe "#destroy" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:room) { create(:room) }
    let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
    let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }
    let!(:message) { create(:message, user_id: user.id, room_id: room.id, content: "こんにちは") }
    let!(:dm_message_notification) { create(:notification,
      visitor_id: user.id,
      visited_id: second_user.id,
      dm_message_id: message.id,
      action: "dm",
      checked: false,
    )}
    let!(:follow_notification) { create(:notification,
      visitor_id: user.id,
      visited_id: second_user.id,
      action: "follow",
      checked: false,
    )}

    before do
      login_as(second_user)
    end

    it '200レスポンスが返ってくること' do
      delete notification_path(dm_message_notification.id)
      expect(response).to have_http_status(200)
    end

    it '正常なレスポンスが返ってくること' do
      delete notification_path(dm_message_notification.id)
      expect(response).to be_successful
    end

    it '全ての通知が削除されること' do
      expect do
        delete notification_path(dm_message_notification.id)
      end.to change { Notification.count }.from(2).to(1)
    end

    it '通知一覧ページで通知が表示が変更される' do
      get notifications_path
      expect(response.body).to include message.content
      delete notification_path(dm_message_notification.id)
      expect(response.body).not_to include message.content
    end
  end

  describe "それぞれのアクション時に通知が生成されること" do
    let!(:user) { create(:user, id: 1) }
    let!(:second_user) { create(:second_user, id: 2) }
    let!(:third_user) { create(:third_user, id: 3) }
    let!(:good_review) { create(:good_review, user_id: second_user.id) }
    let!(:comment) { build(:comment, user_id: user.id, content: "通知のためのコメント") }
    let!(:room) { create(:room) }
    let!(:first_entry) { create(:entry, user_id: user.id, room_id: room.id) }
    let!(:second_entry) { create(:entry, user_id: second_user.id, room_id: room.id) }
    let!(:message) { build(:message, content: "おはようございます！", room_id: room.id, user_id: user.id) }
    let!(:notification) { build(:notification,
      visitor_id: user.id,
      visited_id: second_user.id,
      checked: true,
    )}

    before do
      login_as(user)
    end

    describe "message#create" do
      it 'notificationが1件増える' do
        expect do
          post messages_path, params: { message: { user_id: user.id, content: "通知のためのメッセージ", room_id: room.id } }, xhr: true
        end.to change(Notification, :count).by(1)
      end
    end

    describe "recommend#create" do
      it 'notificationが2件増える' do
        expect do
          post recommend_user_display_path, params: { recommend_user_datas: "2,3", review_id: good_review.id }, xhr: true
        end.to change(Notification, :count).by(2)
      end
    end

    describe "comment#create" do
      it 'notificationが1件増える' do
        expect do
          post review_comments_path(good_review), params: { comment: { content: comment.content } }, xhr: true
        end.to change(Notification, :count).by(1)
      end
    end

    describe "response_comment#create" do
      it 'notificationが1件増える' do
        comment.save
        expect do
          post response_comment_create_path, params: { comment: { content: "It is nice comment" } , review_id: good_review.id, user_id: user.id, parent_id: comment.id }, xhr: true
        end.to change(Notification, :count).by(1)
      end
    end

    describe "likes#create" do
      context '初めての通知の時' do
        it 'notificationが1件増える' do
          expect do
            post like_from_showreview_path, params: { review_id: good_review.id }
          end.to change(Notification, :count).by(1)
        end
      end

      context 'すでに通知がある時' do
        it 'notificationが増えない' do
          notification.action = "like"
          notification.review_id = good_review.id
          notification.save
          expect do
            post like_from_showreview_path, params: { review_id: good_review.id }
          end.to change(Notification, :count).by(0)
        end
      end
    end

    describe "relationships#create" do
      context '初めての通知の時' do
        it 'notificationが1件増える' do
          expect do
            post follow_from_userpage_profile_path, params: { user_id: second_user.id }, xhr: true
          end.to change(Notification, :count).by(1)
        end
      end

      context 'すでに通知がある時' do
        it 'notificationが増えない' do
          notification.action = "follow"
          notification.save
          expect do
            post follow_from_userpage_profile_path, params: { user_id: second_user.id }, xhr: true
          end.to change(Notification, :count).by(0)
        end
      end
    end

    describe "reports#create" do
      context '初めての通知の時' do
        it 'notificationが1件増える' do
          expect do
            post reports_path, params: { review_id: good_review.id }, xhr: true
          end.to change(Notification, :count).by(1)
        end
      end

      context 'すでに通知がある時' do
        it 'notificationが増えない' do
          notification.action = "report"
          notification.review_id = good_review.id
          notification.save
          expect do
            post reports_path, params: { review_id: good_review.id }, xhr: true
          end.to change(Notification, :count).by(0)
        end
      end
    end
  end
end
