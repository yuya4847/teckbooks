class Recommend < ApplicationRecord
  belongs_to :recommend_user, class_name: "User"
  belongs_to :recommended_user, class_name: "User"
  validates :recommend_user_id, presence: true
  validates :recommended_user_id, presence: true
  validates :review_id, presence: true
end
