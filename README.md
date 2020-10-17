# CircleCI and Elixir

[![miolab](https://circleci.com/gh/miolab/circleci_elixir.svg?style=svg)](https://github.com/miolab/circleci_elixir)

**Elixir** の **Docker** 開発環境を構築し、**CircleCI** と連携します

---

## :star: [WIP] 使い方

## :star: [WIP] ディレクトリ構成

## :star: 実行環境

- 基本開発環境

  |                | バージョン |
  | :------------- | :--------- |
  | Mac            |            |
  | Docker         | 19.03.13   |
  | Docker-compose | 1.27.4     |

- Docker container image バージョン

  - Elixir

    ```
    $ docker-compose run app elixir --version
    Creating circleci_elixir_app_run ... done
    Erlang/OTP 22 [erts-10.7.2.3] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

    Elixir 1.10.4 (compiled with Erlang/OTP 22)
    ```

  - PostgreSQL

    ```
    $ docker-compose run postgres psql --version
    Creating circleci_elixir_postgres_run ... done
    psql (PostgreSQL) 12.4
    ```

---

### 参考

- [公式 / 言語ガイド: Elixir](https://circleci.com/docs/ja/2.0/language-elixir/)

  - [GitHub (CircleCI-Public / circleci-demo-elixir-phoenix)](https://github.com/CircleCI-Public/circleci-demo-elixir-phoenix/blob/master/.circleci/config.yml)

- Docker

  - [Docker Official Image / Elixir image](https://hub.docker.com/_/elixir)

  - [Docker Official Image / Postgres image](https://hub.docker.com/_/postgres)

  - [Dockerfile のベストプラクティス](https://docs.docker.jp/engine/articles/dockerfile_best-practice.html)
