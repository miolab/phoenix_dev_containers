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
  ```

- 生成されたファイルの中身を書き換える

  app/my_app/config/dev.exs

  ```elixir
  # Configure your database
  config :my_app, MyApp.Repo,
    username: "postgres",  # <-- update
    password: "password",  # <-- update
    database: "testdb",    # <-- update
    hostname: "db",        # <-- update
  ```

  - `.env` で設定した環境変数に書き換える

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

  - `docker-compose logs` 叩いて、ログ中にエラーぽいのが出てないか確認しておく

###

---

## 参考

- [公式 / 言語ガイド: Elixir](https://circleci.com/docs/ja/2.0/language-elixir/)

  - [GitHub (CircleCI-Public / circleci-demo-elixir-phoenix)](https://github.com/CircleCI-Public/circleci-demo-elixir-phoenix/blob/master/.circleci/config.yml)

- Docker

  - [Docker Official Image / Elixir image](https://hub.docker.com/_/elixir)

  - [Docker Official Image / Postgres image](https://hub.docker.com/_/postgres)

  - [Dockerfile のベストプラクティス](https://docs.docker.jp/engine/articles/dockerfile_best-practice.html)
