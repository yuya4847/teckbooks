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
  link: "https://railstutorial.jp/ss",
  user_id: 1,
)

Review.create!(
  title: "パーフェクトruby on rails",
  content: "もこもこは、Rails 5からプログラミングの勉強をはじめ、
            この本はまだ自分には難しいと思った。",
  rate: 5,
  link: "https://www.amazon.co.jp/%E3%83%91%E3%83%BC%E3%83%95%E3%82%A7%E3%82%AF%E3%83%88-Ruby-Rails-%E3%81%99%E3%81%8C%E3%82%8F%E3%82%89-%E3%81%BE%E3%81%95%E3%81%AE%E3%82%8A/dp/4774165166",
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
