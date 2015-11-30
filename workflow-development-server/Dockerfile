FROM ruby:2.2

RUN mkdir /app

RUN apt-get update && \
    apt-get install -y \
    git \
  && rm -rf /var/lib/apt/lists/*

RUN gem install --no-document bundler --pre

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock/ /app/Gemfile.lock

RUN bundle install
ADD . /app
