User.create!(
  username: "もこもこ",
  email: "aaauser1@yyyy.com",
  profile: "もこもこです。よろしくお願いします！！",
  sex: 1,
  password: "password1",
  password_confirmation: "password1",
  confirmed_at: Time.now,
  admin: true
)

User.create!(
  username: "ぐるぐる",
  email: "bbbuser2@aaaa.com",
  profile: "ぐるぐるです。よろしくお願いします！！",
  sex: 0,
  password: "password2",
  password_confirmation: "password2",
  confirmed_at: Time.now
)

20.times do |n|
  name  = "加藤純一#{n+3}"
  email = "cccuser#{n+3}@aaaa.com"
  password = "password"
  User.create!(username:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               confirmed_at: Time.now
  )
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..6]
followers = users[3..8]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

Review.create!(
  title: "Railsチュートリアル",
  content: "もこもこは、Rails 5からプログラミングの勉強をはじめ、
            何年か前に改定前の本をよんだ。",
  rate: 3,
  link: "https://railstutorial.jp/ss",
  user_id: 1,
)

Review.create!(
  title: "パーフェクトruby on rails",
  content: "もこもこは、Rails 5からプログラミングの勉強をはじめ、
            この本はまだ自分には難しいと思った。",
  rate: 5,
  link: "https://www.amazon.co.jp/%E3%83%91E1%AE%E3%82%8A/dp/4774165166",
  user_id: 1,
)

Review.create!(
  title: "Railsガイド",
  content: "もこもこは、railsで勉強する楽しさがわかった.",
  rate: 1,
  link: "https://railsguides.jp/",
  user_id: 1,
)

Review.create!(
  title: "Railsガイド",
  content: "ぐるぐるは、Rails 5からプログラミングの勉強をはじめ、
            何年か前に改定前の本をよんだ。",
  rate: 4,
  user_id: 2,
)
