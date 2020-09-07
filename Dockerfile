FROM elixir:1.10.4-alpine

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
