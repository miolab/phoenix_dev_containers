FROM elixir:1.10.4-slim

WORKDIR /app

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y \
  build-essential \
  git \
  sudo

RUN mix local.hex --force

RUN mix local.rebar --force
