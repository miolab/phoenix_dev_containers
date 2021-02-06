# Phoenix Dev experiment containers

[![miolab](https://circleci.com/gh/miolab/phoenix_dev_containers.svg?style=svg)](https://github.com/miolab/phoenix_dev_containers)

Elixir 製 Web フレームワーク **Phoenix** の **Docker** 開発環境を構築します

---

## 実行環境（バージョン）・初期ディレクトリ構成

- Elixir

  ```
  $ docker-compose run --rm app elixir --version
  Elixir 1.11.3 (compiled with Erlang/OTP 23)
  ```

- Phoenix

  ```
  $ docker-compose run --rm app mix archive
  * hex-0.21.1
  * phx_new-1.5.7
  ```

- Node & npm

  ```
  $ docker-compose run --rm app bash -c "node --version && npm --version"
  v14.15.4
  6.14.10
  ```

- PostgreSQL

  ```
  $ docker-compose run --rm db psql --version
  psql (PostgreSQL) 12.4
  ```

### **初期ディレクトリ構成**

```bash
$ tree -L 2 -a
.
├── .circleci
│   └── config.yml
├── .env.sample
├── README.md
├── app
│   └── Dockerfile
├── db
│   └── Dockerfile
└── docker-compose.yml
```

---

## 使い方

### **ビルド 〜 Phoenix コンテナ立ち上げ**

- プロジェクト準備

  ```bash
  $ git clone https://github.com/miolab/phoenix_dev_containers.git

  $ rm -rf app/

  $ curl https://raw.githubusercontent.com/miolab/phoenix_dev_containers/master/app/Dockerfile >> app/Dockerfile

  $ cp .env.sample .env
  ```

  上記コマンドで、あらかじめ入っている `app/` は削除しておいてください

- ビルド〜プロジェクト作成

  ```bash
  $ docker-compose build

      .
      .
  ```

  ```bash
  $ docker-compose run --rm app mix phx.new . --app my_app

      .
      .
    (途中に出てくる `Fetch and install dependencies? [Yn]` は、`Y` で進める)

      .
      .
  We are almost there! The following steps are missing:

      $ cd app

  Then configure your database in config/dev.exs and run:

      $ mix ecto.create

  Start your Phoenix app with:

      $ mix phx.server

  You can also run your app inside IEx (Interactive Elixir) as:

      $ iex -S mix phx.server

  ```

- 生成されたファイルの中身を書き換える

  `app/config/dev.exs`

  ```elixir
  # Configure your database
  config :my_app, MyApp.Repo,
    username: "postgres",  # <-- update
    password: "password",  # <-- update
    database: "testdb",    # <-- update
    hostname: "db",        # <-- update
  ```

  - `.env` で設定してある環境変数をつかう

- コンテナ起動

  ```bash
  $ docker-compose up -d
  ```

  ```bash
  $ docker-compose ps

            Name                       Command            State           Ports
  ---------------------------------------------------------------------------------------
  phoenix_dev_containers_app   sh -c mix phx.server        Up      0.0.0.0:4000->4000/tcp
  _1                           --no-halt
  phoenix_dev_containers_db_   docker-entrypoint.sh        Up      0.0.0.0:5432->5432/tcp
  1                            postgres
  ```

- データベース作成

  ```bash
  $ docker-compose exec app mix ecto.create

  The database for MyApp.Repo has been created
  ```

- コンテナを再起動

  ```bash
  $ docker-compose restart app
  ```

- ブラウザ確認

  [`localhost:4000`](http://localhost:4000)

    <img width="687" alt="phx_init_page" src="https://user-images.githubusercontent.com/33124627/100324924-3c566300-300b-11eb-9f84-e5ff80c11a07.png">

  - `docker-compose logs` 叩いて、ログ中にエラーぽいのが出てないか念のため確認しておく

---

### **新規ページを追加してみる**（任意）

- 現在のルーティングを確認

  ```bash
  $ docker-compose exec app mix phx.routes

  Creating phoenix_dev_containers_app_run ... done
            page_path  GET  /                          MyAppWeb.PageController :index
  live_dashboard_path  GET  /dashboard                 Phoenix.LiveView.Plug :home
  live_dashboard_path  GET  /dashboard/:page           Phoenix.LiveView.Plug :page
  live_dashboard_path  GET  /dashboard/:node/:page     Phoenix.LiveView.Plug :page
            websocket  WS   /live/websocket            Phoenix.LiveView.Socket
            longpoll  GET  /live/longpoll              Phoenix.LiveView.Socket
            longpoll  POST  /live/longpoll             Phoenix.LiveView.Socket
            websocket  WS   /socket/websocket          MyAppWeb.UserSocket
  ```

以下の手順で、新規ページ `/aboutme` を追加します

- ルーティング設定（アップデート）

  `app/lib/my_app_web/router.ex`

  ```elixir
  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/aboutme", AboutmeController, :index    # --> add
  end
  ```

- コントローラー追加（新規作成）

  `app/lib/my_app_web/controllers/aboutme_controller.ex`

  ```elixir
  defmodule MyAppWeb.AboutmeController do
    use MyAppWeb, :controller

    def index(conn, _params) do
      render(conn, "index.html")
    end
  end
  ```

- ビュー追加（新規作成）

  `app/lib/my_app_web/views/aboutme_view.ex`

  ```elixir
  defmodule MyAppWeb.AboutmeView do
    use MyAppWeb, :view
  end
  ```

- テンプレート追加（新規作成）

  `app/lib/my_app_web/templates/aboutme/index.html.eex`

  ```html
  <section class="phx-hero">
    <h1>オレオレコンテナをぜひ見てくれ</h1>
  </section>
  <section class="row">
    <p>
      メリークリスマス！ 2020！<br />
      プレゼンテッド・バイ im（あいえむ）
    </p>
  </section>
  ```

- コンテナを再起動して、ルーティングを確認

  ```bash
  $ docker-compose restart app
  ```

  ```bash
  $ docker-compose exec app mix phx.routes

  Creating phoenix_dev_containers_app_run ... done
            page_path  GET     /                          MyAppWeb.PageController :index
        aboutme_path  GET     /aboutme                    MyAppWeb.AboutmeController :index
  live_dashboard_path  GET     /dashboard                 Phoenix.LiveView.Plug :home
  live_dashboard_path  GET     /dashboard/:page           Phoenix.LiveView.Plug :page
  live_dashboard_path  GET     /dashboard/:node/:page     Phoenix.LiveView.Plug :page
            websocket  WS      /live/websocket            Phoenix.LiveView.Socket
            longpoll  GET     /live/longpoll              Phoenix.LiveView.Socket
            longpoll  POST    /live/longpoll              Phoenix.LiveView.Socket
            websocket  WS      /socket/websocket          MyAppWeb.UserSocket
  ```

  - `aboutme_path GET /aboutme MyAppWeb.AboutmeController :index` が追加できたことを確認しました

  - ブラウザ確認 [`localhost:4000/aboutme`](http://localhost:4000/aboutme)

    <img src="https://user-images.githubusercontent.com/33124627/99958502-d2507a80-2dcc-11eb-8ba3-b89612fb1f60.png" width="455px">

---

### **CRUD 設定**

- ざっと設計

  | 実装要件   |                                     |
  | :--------- | :---------------------------------- |
  | Context 名 | Accounts                            |
  | スキーマ名 | User                                |
  | テーブル名 | users                               |
  | カラムと型 | name:string email:string bio:string |

- WebUI を作成

  上記設計にしたがって、生成コマンド `mix phx.gen.html` を実行します

  ```bash
  $ docker-compose exec app bash -c "mix phx.gen.html Accounts User users name:string email:string bio:string"

  * creating lib/my_app_web/controllers/user_controller.ex
  * creating lib/my_app_web/templates/user/edit.html.eex
  * creating lib/my_app_web/templates/user/form.html.eex
  * creating lib/my_app_web/templates/user/index.html.eex
  * creating lib/my_app_web/templates/user/new.html.eex
  * creating lib/my_app_web/templates/user/show.html.eex
  * creating lib/my_app_web/views/user_view.ex
  * creating test/my_app_web/controllers/user_controller_test.exs
  * creating lib/my_app/accounts/user.ex
  * creating priv/repo/migrations/20210206060235_create_users.exs
  * creating lib/my_app/accounts.ex
  * injecting lib/my_app/accounts.ex
  * creating test/my_app/accounts_test.exs
  * injecting test/my_app/accounts_test.exs

  Add the resource to your browser scope in lib/my_app_web/router.ex:

      resources "/users", UserController


  Remember to update your repository by running migrations:

      $ mix ecto.migrate
  ```

- ルーティング設定（アップデート）

  - 上記の結果表示にある

    ```bash
    Add the resource to your browser scope in lib/my_app_web/router.ex:

        resources "/users", UserController
    ```

    にしたがい、ルーティング設定を行います

  `app/lib/my_app_web/router.ex`

  ```elixir
  scope "/", MyAppWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    resources "/users", UserController    # --> add
    get("/aboutme", AboutmeController, :index)
  end
  ```

- マイグレーション実行

  ```bash
  $ docker-compose exec app mix ecto.migrate

  06:08:17.081 [info]  == Running 20210206060235 MyApp.Repo.Migrations.CreateUsers.change/0 forward

  06:08:17.173 [info]  create table users

  06:08:17.300 [info]  == Migrated 20210206060235 in 0.0s

  ```

  マイグレーションを実行したら、コンテナを再起動しておきます

  ```bash
  $ docker-compose restart app
  ```

  ブラウザ確認

  - [`localhost:4000/users/new`](http://localhost:4000/users/new)

    <img width="455px" alt="webui1" src="https://user-images.githubusercontent.com/33124627/100085123-00968e80-2e8f-11eb-9d2a-63a9f0ca14d6.png">

    <img width="455px" alt="webui2" src="https://user-images.githubusercontent.com/33124627/100085143-07250600-2e8f-11eb-8bab-376015a398d6.png">

    CRUD ページを作成できていることを確認できました

### **テスト**

- テスト側の DB 接続情報設定（アップデート）

  `app/config/test.exs`

  ```bash
  config :my_app, MyApp.Repo,
    username: "postgres",    # --> update
    password: "password",    # --> update
    database: "my_app_test#{System.get_env("MIX_TEST_PARTITION")}",
    hostname: "db",    # --> update
    pool: Ecto.Adapters.SQL.Sandbox
  ```

- テスト実行

  ```bash
  $ docker-compose exec app bash -c "MIX_ENV=test mix test"

    .
    .
  Finished in 0.9 seconds
  19 tests, 0 failures
  ```

  All Green でパスしていることを確認できました

### **mix format**

コードをフォーマットします

- フォーマットされているかチェック （`mix format --check-formatted`）

  ```bash
  $ docker-compose exec app bash -c "mix format --check-formatted"
  Creating phoenix_dev_containers_app_run ... done
  ** (Mix) mix format failed due to --check-formatted.
  The following files are not formatted:

    * test/my_app/accounts_test.exs
    * test/my_app_web/controllers/user_controller_test.exs
    * priv/repo/migrations/20210206060235_create_users.exs
  ```

  フォーマットされていない場合は、上記のように警告表示されます

- フォーマットをかける （`mix format`）

  ```terminal
  $ docker-compose exec app mix format
  Creating phoenix_dev_containers_app_run ... done
  ```

- 結果確認

  ```terminal
  $ docker-compose exec app bash -c "mix format --check-formatted"
  Creating phoenix_dev_containers_app_run ... done
  ```

  ぶじにフォーマットされました

---

## 参考

- [Elixir](https://elixir-lang.org/)

  - [Documentation](https://elixir-lang.org/docs.html)

- [Phoenix](https://www.phoenixframework.org/)

- Docker

  - [Docker Official Image / Elixir image](https://hub.docker.com/_/elixir)

  - [Docker Official Image / Postgres image](https://hub.docker.com/_/postgres)

  - [Dockerfile のベストプラクティス](https://docs.docker.jp/engine/articles/dockerfile_best-practice.html)

- CircleCI

  - [公式 / 言語ガイド: Elixir](https://circleci.com/docs/ja/2.0/language-elixir/)

  - [GitHub (CircleCI-Public / circleci-demo-elixir-phoenix)](https://github.com/CircleCI-Public/circleci-demo-elixir-phoenix/blob/master/.circleci/config.yml)

  - [Linux Machine Executor Images - October (Q4) Update](https://discuss.circleci.com/t/linux-machine-executor-images-october-q4-update/37847)

    - [日本語版](https://circleci.com/docs/ja/2.0/executor-types/#machine-%E3%81%AE%E4%BD%BF%E7%94%A8)
