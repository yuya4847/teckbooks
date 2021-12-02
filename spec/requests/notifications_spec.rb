RSpec.describe "Notifications", type: :request do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }
  let!(:third_user) { create(:third_user) }
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
        get recommend_user_display_path, params: { recommend_user_datas: "2,3", review_id: good_review.id }, xhr: true
      end.to change(Notification, :count).by(2)
    end
  end

  describe "response_comment#create" do
    it 'notificationが1件増える' do
      comment.save
      expect do
        post response_comments_path(good_review.id, comment.id), params: { comment: { content: "通知のためのレスポンスコメント" } }, xhr: true
      end.to change(Notification, :count).by(1)
    end
  end

  describe "comment#create" do
    it 'notificationが1件増える' do
      expect do
        post review_comments_path(good_review), params: { comment: { content: comment.content } }, xhr: true
      end.to change(Notification, :count).by(1)
    end
  end

  describe "likes#create" do
    context '初めての通知の時' do
      it 'notificationが1件増える' do
        expect do
          post likes_path, params: { review_id: good_review.id }
        end.to change(Notification, :count).by(1)
      end
    end

    context 'すでに通知がある時' do
      it 'notificationが増えない' do
        notification.action = "like"
        notification.review_id = good_review.id
        notification.save
        expect do
          post likes_path, params: { review_id: good_review.id }
        end.to change(Notification, :count).by(0)
      end
    end
  end

  describe "relationships#create" do
    context '初めての通知の時' do
      it 'notificationが1件増える' do
        expect do
          post relationships_path, params: { followed_id: second_user.id }
        end.to change(Notification, :count).by(1)
      end
    end

    context 'すでに通知がある時' do
      it 'notificationが増えない' do
        notification.action = "follow"
        notification.save
        expect do
          post relationships_path, params: { followed_id: second_user.id }
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
