FROM ruby:2.2

RUN mkdir /app

RUN apt-get update && \
    apt-get install -y \
    git \
 && rm -rf /var/lib/apt/lists/*

RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

RUN gem install --no-document bundler --pre

WORKDIR /app
ADD ["Gemfile", "Gemfile.lock", "/app/"]
RUN bundle install
ADD . /app
