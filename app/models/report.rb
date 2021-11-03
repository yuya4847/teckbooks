class Report < ApplicationRecord
  validates :review_id, presence: true
  validates :user_id, presence: true
end
