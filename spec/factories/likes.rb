FactoryBot.define do
  factory :like, class: Like do
    user_id { User.first.id }
    review_id { Review.first.id }
  end
end
