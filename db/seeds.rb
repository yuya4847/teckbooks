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
  username: "サンプルユーザー",
  email: "example@samp.com",
  profile: "サンプルユーザー。よろしくお願いします！！",
  sex: 1,
  password: "sample-yu-443",
  password_confirmation: "sample-yu-443",
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

User.create!(
  username: "ケンタッキー",
  email: "kentaki2@aaaa.com",
  profile: "ケンタッキー。よろしくお願いします！！",
  sex: 0,
  password: "passwordkenta",
  password_confirmation: "passwordkenta",
  confirmed_at: Time.now
)

User.create!(
  username: "あざらし",
  email: "azarashi2@aaaa.com",
  profile: "あざらしです。よろしくお願いします！！",
  sex: 0,
  password: "passwordazarashi",
  password_confirmation: "passwordazarashi",
  confirmed_at: Time.now
)

User.create!(
  username: "くまモン",
  email: "kumamon2@aaaa.com",
  profile: "くまモンです。よろしくお願いします！！",
  sex: 0,
  password: "passwordkumamon",
  password_confirmation: "passwordkumamon",
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

Review.create!(
  title: "パーフェクトRuby on Rails",
  content: "しっかりとした Rails の基礎知識や、最新のプラクティスが詰まった良書でした。実務で触った色んな断片をこの本を通じて繋ぎ合わせてしっかりとした知識として定着させたり、最新のRailsプラクティスのキャッチアップなどに有用かと思います",
  rate: 3,
  link: "https://railstutorial.jp/",
  user_id: 4,
)

Review.create!(
  title: "PHPフレームワークLaravel入門",
  content: "Laravelをある程度使っており、まとまって参考になる資料が欲しいと思い購入しました。
内容的に一通りさらってはいますが、基本的に公式ドキュメント+ インターネットで調べれば出てくるレベルのものばかりでした。",
  rate: 2,
  link: "https://laraveltutorial.jp/",
  user_id: 5,
)

Review.create!(
  title: "Docker/Kubernetes 実践コンテナ開発入門",
  content: "Dockerを見よう見まねで使ってきましたが、基礎からしっかり学ぼうと購入してみました。
必要な箇所には図で説明されており、非常にわかりやすいのが第一印象です。",
  rate: 4,
  link: "https://dockertutorial.jp/",
  user_id: 6,
)

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

# tech_items.each_with_index do |tech_item, i|
#   Tag.create!(
#     name: "#{tech_item}",
#   )
#
#   Review.create!(
#     title: "#{tech_item}チュートリアル",
#     content: "ほかの方も書かれていますがまず無料プログラミング学習サイトで一通りRuby on Rails をやったうえでさらに、チュートリアルもやり一連の流れを知っておいてからでないと難しすぎると思います。
# 私も実際一冊目として読み始めたのですが理解が追い付かず先にチュートリアルをやりました。
# 内容はとても細かく知らないといけないことを説明してくれていますが、0からスタートした人にはちょっとイメージがわかず眠気が襲ってくる可能性が高いです。",
#     rate: 3,
#     link: "https://#{tech_item}tutorial.jp/",
#     user_id: 1,
#   )
#
#   Review.create!(
#     title: "#{tech_item}入門",
#     content: "この著者の本を何冊か購入してますが、やはりブレないですね、素晴らしいです。
# まったくのRails初心者にはかなりハードル高く、導入編ですでにつまづきそうになるレベルです。
# 私がその初心者でした（笑）
# まずは「ドットインストール」や「プロゲート」、「Ruby on Rails チュートリアル」などに取り組んでみて、
# Ruby on Railsの概要と簡単なアプリをとりあえず一通り完成させてから、
# 基礎知識の補強にこの本を読むととてもためになると思います。",
#     rate: 3,
#     link: "https://#{tech_item}start.jp/",
#     user_id: 1,
#   )
#
#   Review.create!(
#     title: "基礎からの#{tech_item}",
#     content: "Railsやっている人でこの本持っていない人は、いないともいます。
# 初学者でも持っておくべき、バイブル的な本です。
# 説明も大変わかりやすいです。",
#     rate: 3,
#     link: "https://#{tech_item}basic.jp/",
#     user_id: 1,
#   )
#
#   Review.create!(
#     title: "パーフェクト#{tech_item}",
#     content: "#{tech_item}の使い方が一通り網羅されていた。",
#     rate: 3,
#     link: "https://perfect#{tech_item}.jp/",
#     user_id: 1,
#   )
#
#   Review.create!(
#     title: "#{tech_item}実践ガイド",
#     content: "#{tech_item}を仕事で使えるようになりそう！！",
#     rate: 3,
#     link: "https://#{tech_item}guide.jp/",
#     user_id: 1,
#   )
# end
#
# 14.times do |i|
#   5.times do |n|
#     TagRelationship.create!(
#       review_id: (n + 1) + (5 * i),
#       tag_id: i + 1,
#     )
#   end
# end
