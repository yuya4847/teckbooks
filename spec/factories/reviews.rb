FactoryBot.define do
  factory :recent_review, class: Review do
    title { "it is bad" }
    content { "it is very bad" }
    rate { 1 }
    created_at { Time.zone.now }
    user_id { User.first.id }
  end

  factory :good_review, class: Review do
    title { "it is good" }
    content { "it is very good" }
    rate { 2 }
    created_at { 10.minutes.ago }
    user_id { User.first.id }
  end

  factory :great_review, class: Review do
    title { "it is great" }
    content { "it is very great" }
    rate { 3 }
    created_at { 20.minutes.ago }
    user_id { User.first.id }
  end
end
