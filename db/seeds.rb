User.create!(
  username: "もこもこ",
  email: "aaauser1@yyyy.com",
  profile: "もこもこです。よろしくお願いします！！",
  sex: 1,
  password: "password1",
  password_confirmation: "password1",
  confirmed_at: Time.now
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

Review.create!(
  title: "Railsチュートリアル",
  content: "もこもこは、Rails 5からプログラミングの勉強をはじめ、
            何年か前に改定前の本をよんだ。",
  rate: 3,
  user_id: 1,
)

Review.create!(
  title: "Railsパーフェクト",
  content: "もこもこは、Rails 5からプログラミングの勉強をはじめ、
            この本はまだ自分には難しいと思った。",
  rate: 5,
  user_id: 1,
)

Review.create!(
  title: "Railsクエスト",
  content: "もこもこは、railsで勉強する楽しさがわかった.",
  rate: 1,
  user_id: 1,
)

Review.create!(
  title: "Railsガイド",
  content: "ぐるぐるは、Rails 5からプログラミングの勉強をはじめ、
            何年か前に改定前の本をよんだ。",
  rate: 4,
  user_id: 2,
)
