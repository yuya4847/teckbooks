class Message < ApplicationRecord
  has_many :notifications, class_name: "Notification", primary_key: :id, foreign_key: :dm_message_id, dependent: :destroy
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :content, presence: true

  def create_notification_dm!(visitor_user, visited_user)
    visitor_user.active_notifications.create(
      visited_id: visited_user[0].id,
      dm_message_id: id,
      action: "dm"
    )
    unless visitor_user == visited_user
      visited_notification_count = Notification.where(["visited_id = ? and checked = ?", visited_user[0].id, false]).size
      if visited_notification_count == 300
        NotificationMailer.notification_new_storage(visited_user[0]).deliver_now
      end
    end
  end
end
