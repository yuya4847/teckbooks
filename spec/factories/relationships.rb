FactoryBot.define do
  factory :relationship, class: Relationship do
    follower_id { User.first.id }
    followed_id { User.second.id }
  end

  factory :second_relationship, class: Relationship do
    follower_id { User.first.id }
    followed_id { User.third.id }
  end

  factory :third_relationship, class: Relationship do
    follower_id { User.third.id }
    followed_id { User.first.id }
  end

  factory :followed_relationship, class: Relationship do
    follower_id { User.second.id }
    followed_id { User.first.id }
  end
end
