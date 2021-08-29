class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review
  belongs_to :parent,  class_name: "Comment", optional: true
  has_many   :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  validates :user_id, presence: true
  validates :review_id, presence: true
  validates :content, presence: { message: 'を入力してください' }
  validates :content, length: { maximum: 50 }
  default_scope -> { order(created_at: :desc) }
end
