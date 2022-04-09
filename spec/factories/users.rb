FactoryBot.define do
  factory :user, class: User do
    username { "yuya" }
    email { "testyuya@example.com" }
    profile { "よろしくお願いします。" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at            { Time.now }
    admin { true }
  end

  factory :second_user, class: User do
    username { "yuta" }
    email { "aaayuta@example.com" }
    password { "yuta_password" }
    password_confirmation { "yuta_password" }
    confirmed_at            { Time.now }
  end

  factory :third_user, class: User do
    username { "yuki" }
    email { "aaayuki@example.com" }
    password { "yuki_password" }
    password_confirmation { "yuki_password" }
    confirmed_at            { Time.now }
  end

  factory :forth_user, class: User do
    username { "yukiaa" }
    email { "aabyuki@example.com" }
    password { "yukiaa_password" }
    password_confirmation { "yukiaa_password" }
    confirmed_at            { Time.now }
  end

  factory :fifth_user, class: User do
    username { "yukibb" }
    email { "aacyuki@example.com" }
    password { "yukibb_password" }
    password_confirmation { "yukibb_password" }
    confirmed_at            { Time.now }
  end

  factory :sixth_user, class: User do
    username { "sixth_user" }
    email { "sixth@example.com" }
    password { "sixth_password" }
    password_confirmation { "sixth_password" }
    confirmed_at            { Time.now }
  end

  factory :seventh_user, class: User do
    username { "seventh_user" }
    email { "seventh@example.com" }
    password { "seventh_password" }
    password_confirmation { "seventh_password" }
    confirmed_at            { Time.now }
  end

  factory :eighth_user, class: User do
    username { "eighth_user" }
    email { "eighth@example.com" }
    password { "eighth_password" }
    password_confirmation { "eighth_password" }
    confirmed_at            { Time.now }
  end

  factory :ninth_user, class: User do
    username { "ninth_user" }
    email { "ninth@example.com" }
    password { "ninth_password" }
    password_confirmation { "ninth_password" }
    confirmed_at            { Time.now }
  end

  factory :unfollow_user, class: User do
    username { "yuji" }
    email { "aaayuji@example.com" }
    password { "yuji_password" }
    password_confirmation { "yuji_password" }
    confirmed_at            { Time.now }
  end

  factory :unconfirmed_user, class: User do
    username { "ken" }
    email { "testken@example.com" }
    password { "ken_password" }
    password_confirmation { "ken_password" }
  end
end
