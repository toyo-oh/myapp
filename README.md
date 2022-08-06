## MonsterCoffee
#### このサイトは個人の作品であり、営利目的ではありません！

#### ◆概要  
***  
MonsterCoffeeはコーヒー周りの商品を販売するECサイトです。
https://monstercf.net/

#### ◆機能一覧  
***  
###### ＜user＞  
- ユーザー新規登録 / アカウントアクティベート / ログイン
- ユーザー情報変更 （メール変更 / パスワードリセット）
- 住所登録 / 住所編集　
- ホームページ / 商品詳細ページ
- 商品購入（カートに入れる / カード決済 ）
- 注文履歴（注文一覧表示 / 注文の詳細確認 / 注文キャンセル / 配送状況確認）
- 商品検索
- 商品レビュー
- お気に入り（お気に入りリストに追加・解除）
- メール通知（新規登録 / パスワードリセット / 新規注文 / 注文キャンセル / 出荷の場合）
- 日次バッチ（注文ステータス自動更新）  

###### ＜admin＞
- 在庫管理（商品登録 / 商品情報編集 / 期間限定セール登録）
- 注文管理（販売履歴表示 / 注文の詳細確認 / 注文キャンセル / 出荷 / 出品を終了）

#### ◆使用技術
***  
- フロントエンド
    - Vue.js / Nuxt.js / Vuetify / nuxt-auth / nuxt-axios / nuxt-dotenv / nuxt-toast / vue-stripe / eslint / prettier / jest
- バックエンド
    - Ruby / Rails / MySQL / carrierwave / stripe / jwt / dotenv-rails / hashid-rails / fog-aws / whenever/ rspec-rails / rubocop
- インフラ
    - AWS (ECS / ECR / EC2 / RDS / VPC / ALB / ACM / Route53 / S3 / IAM)
- CI/CD
    - CircleCI
- IDE
    - VSCode
- バージョン管理
    - Git / GitHub
- 開発環境
    - Docker / Docker Compose

#### ◆ER図  
***  
![er dragram.png](https://s2.loli.net/2022/08/03/PsdnzNhatOvMcGQ.png)

#### ◆インフラ図  
***  
![aws_infra_dragram.jpg](https://s2.loli.net/2022/08/03/5hFKWkIN14OYxTt.jpg)

#### ◆操作方法＆画面キャプチャー  
***  
###### ＜user＞  
- ユーザー新規登録
  セットアップ → アカウントアクティベート → ログイン
  ![1_setup.gif](https://s2.loli.net/2022/08/06/bHF4auAznDUoV3J.gif)

- 商品購入
  商品を探す → 商品の詳細確認 → カートに入れる → 住所登録 → カード決済 → 注文完了
  part1
  ![2_buy_all_1.gif](https://s2.loli.net/2022/08/06/XzJuPLhgGBOdx5R.gif)
  part2
 ![2_buy_all_2 copy.gif](https://s2.loli.net/2022/08/06/WCbUfvNLMJhYj8V.gif)

- 配送状況確認
注文一覧表示 → 注文の詳細確認 → 配送状況確認
![3_track.gif](https://s2.loli.net/2022/08/06/MbPADwxoZ96Ws8O.gif)

- 商品レビュー
注文一覧表示 → 注文の詳細確認 → 商品レビュー
  ![4_review.gif](https://s2.loli.net/2022/08/06/gGlz3MUx7oNKmZA.gif)
  
###### ＜admin＞
- 商品登録
商品一覧表示 → 新規商品登録 → 商品の詳細情報入力 → 出品完了
![admin_product_1.gif](https://s2.loli.net/2022/08/06/pBjH2Y4WKX6vhTi.gif)

- 商品出荷
注文一覧表示 → 注文の詳細確認 → 伝票番号入力 → 出荷完了
![admin_order_2.gif](https://s2.loli.net/2022/08/06/n3PsCxOwGmRFpZS.gif)
