class AddColumnToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :response_comment_id, :integer
    add_column :notifications, :dm_message_id, :integer
  end
end
