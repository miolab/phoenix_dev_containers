FROM elixir:1.11.3-slim

ENV MIX_HOME=/root/.mix \
  MIX_ENV=prod \
  SECRET_KEY_BASE=${SECRET_KEY_BASE} \
  DATABASE_URL=${DATABASE_URL}

COPY . /usr/src/app

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

RUN apt-get install -y nodejs npm
RUN npm install -g n
RUN n 14.15.4
RUN apt-get purge -y nodejs npm
RUN node -v && npm -v

RUN mix local.hex --force && \
  mix local.rebar --force
RUN mix archive.install hex phx_new 1.5.7 --force

RUN apt-get clean

CMD [ "mix", "phx.server", "--no-halt" ]
