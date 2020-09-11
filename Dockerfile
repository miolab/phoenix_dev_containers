FROM elixir:1.10.4-slim

WORKDIR /app

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y \
  build-essential \
  curl \
  git \
  gzip \
  inotify-tools \
  ssh \
  sudo \
  tar

RUN mix local.hex --force
RUN mix local.rebar --force
RUN yes | mix archive.install hex phx_new 1.5.4

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN apt-get clean

CMD [ "mix", "phx.server" ]

LABEL com.circleci.preserve-entrypoint=true

ENTRYPOINT contacts
