FROM ruby:2.2-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install gcc make ruby-dev g++

RUN gem install riemann-dash thin

EXPOSE 4567

WORKDIR /app

COPY config.rb /app/config.rb

ENTRYPOINT ["riemann-dash"]

