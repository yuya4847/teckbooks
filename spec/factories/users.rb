FactoryBot.define do
  factory :user, class: User do
    username { "yuya" }
    email { "testyuya@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at            { Time.now }
  end

  factory :second_user, class: User do
    username { "yuta" }
    email { "aaayuta@example.com" }
    password { "yuta_password" }
    password_confirmation { "yuta_password" }
    confirmed_at            { Time.now }
  end

  factory :unconfirmed_user, class: User do
    username { "ken" }
    email { "testken@example.com" }
    password { "ken_password" }
    password_confirmation { "ken_password" }
  end
end
