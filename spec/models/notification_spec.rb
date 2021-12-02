require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }
  let!(:good_review) { create(:good_review) }
  let!(:comment) { create(:comment, review_id: good_review.id, user_id: user.id) }
  let!(:response_comment) { create(:comment, review_id: good_review.id, user_id: second_user.id, parent_id: comment.id) }
  let!(:room) { create(:room) }
  let!(:message) { create(:message, content: "おはようございます！", room_id: room.id, user_id: user.id) }
  let!(:notification) { build(:notification,
    visitor_id: user.id,
    visited_id: second_user.id,
  )}

  describe '#new' do
    describe '値が存在する' do
      it "visitor_id, visited_id, review_id, comment_id, response_comment_id, dm_message_id, action, checkedがある場合、有効であること" do
        notification.review_id = good_review.id
        notification.comment_id = comment.id
        notification.response_comment_id = response_comment.id
        notification.dm_message_id = message.id
        notification.action = "like"
        notification.checked = true
        notification.valid?
        expect(notification.valid?).to eq(true)
      end

      it "visitor_idがない場合、有効であること" do
        notification.visitor_id = nil
        notification.action = "like"
        notification.checked = true
        notification.valid?
        expect(notification.valid?).to eq(false)
      end

      it "visited_idがない場合、有効であること" do
        notification.visited_id = nil
        notification.action = "like"
        notification.checked = true
        notification.valid?
        expect(notification.valid?).to eq(false)
      end

      it "actionがない場合、有効であること" do
        notification.action = nil
        notification.checked = true
        notification.valid?
        expect(notification.valid?).to eq(false)
      end

      it "checkedがない場合、有効であること" do
        notification.action = "like"
        notification.checked = nil
        notification.valid?
        expect(notification.valid?).to eq(false)
      end
    end

    describe 'actionの検証をする' do
      context 'actionが有効な値の場合' do
        it "likeが有効であること" do
          notification.action = "like"
          notification.checked = true
          notification.valid?
          expect(notification.valid?).to eq(true)
        end

        it "followが有効であること" do
          notification.action = "follow"
          notification.checked = true
          notification.valid?
          expect(notification.valid?).to eq(true)
        end

        it "commentが有効であること" do
          notification.action = "comment"
          notification.checked = true
          notification.valid?
          expect(notification.valid?).to eq(true)
        end

        it "response_commentが有効であること" do
          notification.action = "response_comment"
          notification.checked = true
          notification.valid?
          expect(notification.valid?).to eq(true)
        end

        it "reportが有効であること" do
          notification.action = "report"
          notification.checked = true
          notification.valid?
          expect(notification.valid?).to eq(true)
        end

        it "dmが有効であること" do
          notification.action = "dm"
          notification.checked = true
          notification.valid?
          expect(notification.valid?).to eq(true)
        end

        it "recommendが有効であること" do
          notification.action = "recommend"
          notification.checked = true
          notification.valid?
          expect(notification.valid?).to eq(true)
        end
      end

      context 'actionが無効な値の場合' do
        it "無効であること" do
          notification.action = "none"
          notification.checked = true
          notification.valid?
          expect(notification.valid?).to eq(false)
        end
      end

      describe 'checkedが適切な値をとること' do
        it "tureが有効であること" do
          notification.checked = true
          notification.action = "like"
          notification.valid?
          expect(notification.valid?).to eq(true)
        end

        it "falseが有効であること" do
          notification.checked = false
          notification.action = "like"
          notification.valid?
          expect(notification.valid?).to eq(true)
        end
      end
    end
  end

  describe '#destroy' do
    it "削除できること" do
      notification.action = "like"
      notification.checked = true
      notification.save
      expect do
        notification.destroy
      end.to change(Notification, :count).by(-1)
    end

    it "visitor_idのユーザーの削除と同時に削除されること" do
      notification.action = "like"
      notification.checked = true
      notification.save
      expect do
        user.destroy
      end.to change(Notification, :count).by(-1)
    end

    it "visited_idのユーザーの削除と同時に削除されること" do
      notification.action = "like"
      notification.checked = true
      notification.save
      expect do
        second_user.destroy
      end.to change(Notification, :count).by(-1)
    end

    it "レビューの削除と同時に削除されること" do
      notification.action = "like"
      notification.checked = true
      notification.review_id = good_review.id
      notification.save
      expect do
        good_review.destroy
      end.to change(Notification, :count).by(-1)
    end

    it "コメントの削除と同時に削除されること" do
      notification.action = "comment"
      notification.checked = true
      notification.review_id = good_review.id
      notification.comment_id = comment.id
      notification.save
      expect do
        comment.destroy
      end.to change(Notification, :count).by(-1)
    end

    it "レスポンスコメントの削除と同時に削除されること" do
      notification.action = "response_comment"
      notification.checked = true
      notification.review_id = good_review.id
      notification.comment_id = comment.id
      notification.response_comment_id = response_comment.id
      notification.save
      expect do
        response_comment.destroy
      end.to change(Notification, :count).by(-1)
    end

    it "DMメッセージと同時に削除されること" do
      notification.dm_message_id = message.id
      notification.action = "dm"
      notification.checked = true
      notification.save
      expect do
        message.destroy
      end.to change(Notification, :count).by(-1)
    end
  end
end
