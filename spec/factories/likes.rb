FactoryBot.define do
  factory :like, class: Like do
    user_id { User.first.id }
    review_id { Review.first.id }
  end

  factory :is_like, class: Like do
    user_id {  }
    review_id {  }
  end
end
