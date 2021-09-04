FactoryBot.define do
  factory :tag_relationship do
    review_id { Review.first.id }
    tag_id { Tag.first.id }
  end
end
