FROM ubuntu:14.04
MAINTAINER admin@saymon21-root.pro
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
RUN \
  apt-get update && apt-get -y install wget apt-transport-https; \
	echo 'deb https://packages.erlang-solutions.com/ubuntu trusty contrib'| tee /etc/apt/sources.list.d/erlang.list; \
	wget https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc -O-| apt-key add -; \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y git esl-erlang=1:18.2 elixir=1.2.6-1 && \
  rm -rf /var/lib/apt/lists/*


ADD openbill-webhooks/ /usr/local/openbill-webhooks

WORKDIR /usr/local/openbill-webhooks
ENV MIX_ENV prod
RUN \
	git pull && \
  cp config/prod_example.exs config/prod.exs && \
  mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get && \
  mix compile

# forward logs to Docker log collector
RUN mkdir /var/log/openbill-webhooks && \
    ln -sf /dev/stderr /var/log/openbill-webhooks/error.log && \
    ln -sf /dev/stdout /var/log/openbill-webhooks/info.log

CMD ["iex", "-S", "mix"]
