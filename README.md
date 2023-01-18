# TechBookHub（テックブックハブ）
### **https://www.techbookhub.net**

## サービス概要

**"技術をシェアする。想いをシェアする"**

技術書の比較検索・シェア
のできるエンジニアが集まる
技術読書レビューサービス

### サービスを作った思い
技術書を買おうとする際に、Rakuten・Amazon・Yahoo!などのECサイト上で、調べることは、
エンジニアならやったことのある人が多いと思います。それぞれのプラットフォームを行き来して、
本の紹介文や口コミや価格を比較するのは非常に手間だと私は思いました。そこで、一つのページにそれらの
情報を表示することができればなと思い、このTechbookhubを作りました。また、そこで
自分にあった技術書を見つけやすくするために、発見した技術書に関する情報を投稿・シェアできるようにしました。

<br>

## 機能一覧

### ネット比較検索関連
- サジェスト補完機能(Rakuten API)
- 書籍比較検索機能(Rakuten API, Yahoo! API, Google API, Amazonスクレイピング )
- 頻出ワードによる検索(Rakuten API, Yahoo! API, Google API, Amazonスクレイピング )
###### 検索結果が表示されるまでに時間がかかります。そのためムービーを用意しましたので、ご視聴いただけると幸いです.
https://user-images.githubusercontent.com/68845212/213187938-2a80361e-f75c-4a0a-b413-b93372b567ba.mov

### ユーザー関連
- 登録機能
- 編集機能
- 削除機能
- ログイン・ログアウト機能
- ゲストログイン機能
- ユーザー情報表示機能  …etc

### 投稿関連
- 一覧機能
- ユーザー投稿一覧機能
- 詳細表示機能
- 削除機能
- 編集機能
- 投稿機能(画像可)
- 評価機能
- コメント機能(Ajax)
- コメント返信機能(Ajax)
- レコメンド機能(Ajax)
- いいね機能(Ajax)
- フォロー・アンフォロー機能(Ajax)
- いいねランキング機能
- PV数表示機能
- PVランキング機能
- 通報機能(Ajax, 自動削除)
- 通知機能(いいね, コメント, コメント返信, レコメンド, フォロー, DM, 通報)
- タグ付機能
- 関連表示機能
- 履歴表示機能
- 検索機能(Ajax, アプリ内検索)
- タグ検索機能(Ajax)
- ページネーション機能

### その他
- 知り合いかも？機能(知り合い＝フォローしているユーザーがフォローしているユーザーの表示)
- 友達を探そう機能(全く自分と関連のないユーザーの表示)
- DM機能(Ajax)

### ER図
![名称未設定 drawio](https://user-images.githubusercontent.com/68845212/169689694-2b9c2ebd-453d-497d-b2a6-1389fe5a35a3.svg)

## 使用技術
### バックエンド
- Ruby 2.6.3
- Rails 6.0.3
- Nginx
- Rubocop（コード解析ツール）
- Rspec (model: 136, request: 253, system: 258, 計647項目)

### フロントエンド
- JQuery
- Bootstrap
- Webpack

### インフラ
- Docker/Docker-compose
- AWS (IAM,EC2,VPC,RDS,Route53,ALB,ACM,S3)
- Terraform (インフラのコード管理)
- CircleCI(CI/CD)

### インフラ構成図
![aws](https://user-images.githubusercontent.com/68845212/169702579-4c04649e-a351-4b06-86e1-587a04e65157.svg)

## 問題・反省点
- Googleアカウントでのホストログインができていない(リンクはハリボテ)
- 全体的にコードが汚い
- ECSでデプロイができなかった
- 例外処理がスカスカである
