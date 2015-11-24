FROM ruby:2.2

RUN mkdir /app

RUN apt-get update && \
    apt-get install -y \
    git \
  && rm -rf /var/lib/apt/lists/*

ADD Gemfile /app/Gemfile
ADD Gemfile.lock/ /app/Gemfile.lock

RUN gem install --no-document bundler --pre

WORKDIR /app
RUN bundle install

ADD . /app
