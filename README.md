# CircleCI and Elixir

[![miolab](https://circleci.com/gh/miolab/circleci_elixir.svg?style=svg)](https://github.com/miolab/circleci_elixir)

**Elixir** の **Docker** 開発環境を構築し、**CircleCI** と連携します

---

## :star: 実行環境

- 基本開発環境

  |                | バージョン |
  | :------------- | :--------- |
  | macOS          |            |
  | Docker         | 19.03.13   |
  | Docker-compose | 1.27.4     |

### Container Image バージョン

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

## :star: 初期ディレクトリ構成

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

## :star: [WIP] 使い方

---

### 参考

- [公式 / 言語ガイド: Elixir](https://circleci.com/docs/ja/2.0/language-elixir/)

  - [GitHub (CircleCI-Public / circleci-demo-elixir-phoenix)](https://github.com/CircleCI-Public/circleci-demo-elixir-phoenix/blob/master/.circleci/config.yml)

- Docker

  - [Docker Official Image / Elixir image](https://hub.docker.com/_/elixir)

  - [Docker Official Image / Postgres image](https://hub.docker.com/_/postgres)

  - [Dockerfile のベストプラクティス](https://docs.docker.jp/engine/articles/dockerfile_best-practice.html)
