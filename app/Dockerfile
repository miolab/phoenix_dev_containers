FROM elixir:1.11.2-slim

WORKDIR /usr/src/app

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

RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install npm@latest -g

RUN yes | mix local.hex
RUN mix local.rebar --force
RUN mix archive.install hex phx_new 1.5.7 --force

RUN apt-get clean

CMD [ "mix", "phx.server" ]
