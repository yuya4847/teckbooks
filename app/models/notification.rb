class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :visitor, class_name: "User"
  belongs_to :visited, class_name: "User"
  belongs_to :review, optional: true
  belongs_to :comment, optional: true
  belongs_to :rescomment, optional: true, primary_key: :id, foreign_key: :response_comment_id, class_name: "Comment"
  belongs_to :dm_message, class_name: "Message", optional: true
  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  ACTION_VALUES = ["like", "follow", "comment", "response_comment", "report", "dm", "recommend"]
  validates :action,  presence: true, inclusion: { in: ACTION_VALUES }
  validates :checked, inclusion: { in: [true, false] }
end
