FactoryBot.define do
  factory :message do
    user_id { User.first.id }
    room_id { Room.first.id }
    content { "こんにちは" }
  end
end
