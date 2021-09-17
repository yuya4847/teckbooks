FactoryBot.define do
  factory :entry do
    user_id { User.first.id }
    room_id { Room.first.id }
  end
end
