# Phoenix Dev experiment containers

[![miolab](https://circleci.com/gh/miolab/circleci_elixir.svg?style=svg)](https://github.com/miolab/circleci_elixir)

**Phoenix (Elixir)** の **Docker** 開発環境を構築します

---

## :star: 実行環境

- 基本開発環境

  |                | バージョン |
  | :------------- | :--------- |
  | macOS          |            |
  | Docker         | 19.03.13   |
  | Docker-compose | 1.27.4     |

### __Container Image バージョン__

- Elixir

  ```
  $ docker-compose run --rm app elixir --version
  Creating circleci_elixir_app_run ... done
  Erlang/OTP 23 [erts-11.1.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

  Elixir 1.11.2 (compiled with Erlang/OTP 23)
  ```

- Phoenix

  ```
  $ docker-compose run --rm app mix archive
  Creating circleci_elixir_app_run ... done
  * hex-0.20.6
  * phx_new-1.5.6
  ```

- PostgreSQL

  ```
  $ docker-compose run --rm db psql --version
  Creating circleci_elixir_db_run ... done
  psql (PostgreSQL) 12.4
  ```

- Node & npm

  ```
  $ docker-compose run --rm app bash -c "node --version && npm --version"
  Creating circleci_elixir_app_run ... done
  v14.15.1
  6.14.8
  ```

### __初期ディレクトリ構成__

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

## :star: 使い方

### __ビルド 〜 Phoenix コンテナ立ち上げ__

- プロジェクト準備

  ```bash
  $ cp .env.sample .env
  ```

  ```bash
  $ docker-compose build
      .
      .
  ```

  ```bash
  $ docker-compose run --rm app mix phx.new my_app

      .
      .
    (途中に出てくる `Fetch and install dependencies? [Yn]` は、`Y` で進める)

      .
      .
  We are almost there! The following steps are missing:

      $ cd my_app

  Then configure your database in config/dev.exs and run:

      $ mix ecto.create

  Start your Phoenix app with:

      $ mix phx.server

  You can also run your app inside IEx (Interactive Elixir) as:

      $ iex -S mix phx.server

  ```

- 生成されたファイルの中身を書き換える

  `app/my_app/config/dev.exs`

  ```elixir
  # Configure your database
  config :my_app, MyApp.Repo,
    username: "postgres",  # <-- update
    password: "password",  # <-- update
    database: "testdb",    # <-- update
    hostname: "db",        # <-- update
  ```

  - `.env` で設定した環境変数をつかいます

- コンテナ起動

  ```bash
  $ docker-compose up -d
  ```

  ```bash
  $ docker-compose ps

          Name                       Command               State            Ports
  ----------------------------------------------------------------------------------------
  circleci_elixir_app_1   sh -c cd my_app/ && mix ph ...   Up      0.0.0.0:4000->4000/tcp
  circleci_elixir_db_1    docker-entrypoint.sh postgres    Up      0.0.0.0:15432->5432/tcp
  ```

  ```bash
  $ docker-compose run --rm app bash -c "cd my_app && mix ecto.create"
  ```

  ```bash
  $ docker-compose restart app
  ```

  - ブラウザ確認 [`localhost:4000`](localhost:4000)

  - `docker-compose logs` 叩いて、ログ中にエラーぽいのが出てないか念のため確認しておく

### __新規ページを追加する__

- 現在のルーティングを確認

  ```bash
  $ docker-compose run --rm app bash -c "cd my_app && mix phx.routes"

  Creating circleci_elixir_app_run ... done
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

  `app/my_app/lib/my_app_web/router.ex`

  ```elixir
  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/aboutme", AboutmeController, :index    # --> add
  end
  ```

- コントローラー追加（新規作成）

  `app/my_app/lib/my_app_web/controllers/aboutme_controller.ex`

  ```elixir
  defmodule MyAppWeb.AboutmeController do
    use MyAppWeb, :controller

    def index(conn, _params) do
      render(conn, "index.html")
    end
  end
  ```

- ビュー追加（新規作成）

  `app/my_app/lib/my_app_web/views/aboutme.ex`

  ```elixir
  defmodule MyAppWeb.AboutmeView do
    use MyAppWeb, :view
  end
  ```

- テンプレート追加（新規作成）

  `app/my_app/lib/my_app_web/templates/aboutme/index.html.eex`

  ```html
  <section class="phx-hero">
    <h1>オレオレコンテナをぜひ見てくれ</h1>
  </section>
  <section class="row">
    <p>メリークリスマス！ 2020！<br>
      プレゼンテッド・バイ im（あいえむ）</p>
  </section>
  ```

- コンテナを再起動して、ルーティングを確認

  ```bash
  $ docker-compose restart app
  ```

  ```bash
  $ docker-compose run --rm app bash -c "cd my_app && mix phx.routes"

  Creating circleci_elixir_app_run ... done
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

  - ブラウザ確認 [`localhost:4000/aboutme`](localhost:4000/aboutme)

    <img src="https://user-images.githubusercontent.com/33124627/99958502-d2507a80-2dcc-11eb-8ba3-b89612fb1f60.png" width="455px">

### __CRUD 設定__

---

## 参考

- [公式 / 言語ガイド: Elixir](https://circleci.com/docs/ja/2.0/language-elixir/)

  - [GitHub (CircleCI-Public / circleci-demo-elixir-phoenix)](https://github.com/CircleCI-Public/circleci-demo-elixir-phoenix/blob/master/.circleci/config.yml)

- Docker

  - [Docker Official Image / Elixir image](https://hub.docker.com/_/elixir)

  - [Docker Official Image / Postgres image](https://hub.docker.com/_/postgres)

  - [Dockerfile のベストプラクティス](https://docs.docker.jp/engine/articles/dockerfile_best-practice.html)
