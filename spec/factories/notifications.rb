FactoryBot.define do
  factory :notification do
    visitor_id { }
    visited_id { }
    review_id { }
    comment_id { }
    response_comment_id { }
    dm_message_id { }
    action { }
    checked { }
  end
end
