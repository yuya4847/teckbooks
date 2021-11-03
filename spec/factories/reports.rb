FactoryBot.define do
  factory :report do
    user_id { User.first }
    review_id { Review.first }
  end
end
