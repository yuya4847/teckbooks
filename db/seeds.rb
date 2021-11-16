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

40.times do |n|
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
third_user  = users.third
following = users[2..4]
followers = users[5..7]

following.each { |followed| user.follow(followed) }
followers.each { |followed| third_user.follow(followed) }

tech_items = [
  "ruby",
  "rails",
  "php",
  "python",
  "go",
  "java",
  "javascript",
  "typescript",
  "aws",
  "docker",
  "linux",
  "sql",
  "vue",
  "react"
]

tech_items.each_with_index do |tech_item, i|
  Tag.create!(
    name: "#{tech_item}",
  )

  Review.create!(
    title: "#{tech_item}チュートリアル",
    content: "#{tech_item}は興味深い内容でした。",
    rate: 3,
    link: "https://#{tech_item}tutorial.jp/",
    user_id: 1,
  )

  Review.create!(
    title: "#{tech_item}入門",
    content: "#{tech_item}は基礎的な内容から詳しく解説されていました。",
    rate: 3,
    link: "https://#{tech_item}start.jp/",
    user_id: 1,
  )

  Review.create!(
    title: "基礎からの#{tech_item}",
    content: "#{tech_item}は基礎的な内容が網羅されていたよかったです。",
    rate: 3,
    link: "https://#{tech_item}basic.jp/",
    user_id: 1,
  )

  Review.create!(
    title: "パーフェクト#{tech_item}",
    content: "#{tech_item}の使い方が一通り網羅されていた。",
    rate: 3,
    link: "https://perfect#{tech_item}.jp/",
    user_id: 1,
  )

  Review.create!(
    title: "#{tech_item}実践ガイド",
    content: "#{tech_item}を仕事で使えるようになりそう！！",
    rate: 3,
    link: "https://#{tech_item}guide.jp/",
    user_id: 1,
  )
end

14.times do |i|
  5.times do |n|
    TagRelationship.create!(
      review_id: (n + 1) + (5 * i),
      tag_id: i + 1,
    )
  end
end
