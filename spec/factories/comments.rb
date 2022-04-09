FactoryBot.define do
  factory :comment do
    content { "I think it is my review" }
    user_id { User.first.id }
    review_id { Review.first.id }
    parent_id {}
  end
end
