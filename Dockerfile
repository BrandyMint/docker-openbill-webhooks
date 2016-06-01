FROM ubuntu:14.04
MAINTAINER admin@saymon21-root.pro
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
RUN \
  apt-get update && apt-get -y install wget && \
  wget -q https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb -O /tmp/erlang-solutions_1.0_all.deb && \
  dpkg -i /tmp/erlang-solutions_1.0_all.deb && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y git erlang elixir && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local
RUN git clone https://github.com/dapi/openbill-webhooks.git
WORKDIR /usr/local/openbill-webhooks
ENV MIX_ENV prod
RUN \
  cp config/dev_example.exs config/prod.exs && \
  mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get && \
  mix compile && mix release

# forward logs to Docker log collector
RUN mkdir /var/log/openbill-webhooks && \
    ln -sf /dev/stderr /var/log/openbill-webhooks/error.log && \
    ln -sf /dev/stdout /var/log/openbill-webhooks/info.log

ENV RELX_REPLACE_OS_VARS true

CMD ["rel/openbill_webhooks/bin/openbill_webhooks", "foreground"]
