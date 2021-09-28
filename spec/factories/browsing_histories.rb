FactoryBot.define do
  factory :browsing_history do
    user_id { User.first.id }
    review_id { Review.first.id }
  end
end
