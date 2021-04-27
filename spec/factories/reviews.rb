FactoryBot.define do
  factory :recent_review, class: Review do
    title { "it is bad" }
    content { "it is very bad" }
    link { "https://www.youtube.com/" }
    rate { 1 }
    created_at { Time.zone.now }
    user_id { User.first.id }
  end

  factory :good_review, class: Review do
    title { "it is good" }
    content { "it is very good" }
    link { "https://qiita.com/" }
    rate { 2 }
    created_at { 10.minutes.ago }
    user_id { User.first.id }
  end

  factory :great_review, class: Review do
    title { "it is great" }
    content { "it is very great" }
    link { "https://www.amazon.co.jp/" }
    rate { 3 }
    created_at { 20.minutes.ago }
    user_id { User.first.id }
  end

  factory :normal_review, class: Review do
    title { "it is normal" }
    content { "it is very normal" }
    link { "https://www.yahoo.co.jp/" }
    rate { 3 }
    created_at { 20.minutes.ago }
    user_id { User.second.id }
  end
end
