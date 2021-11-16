FactoryBot.define do
  factory :recommend do
    recommend_user_id { User.first.id }
    recommended_user_id { User.second.id }
    review_id { Review.first.id }
  end
end
