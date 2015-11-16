FROM ruby:2.2

# Postgres dev
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >>/etc/apt/sources.list.d/pgdg.list && \
    curl -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-server-dev-9.4

# Git
RUN apt-get -y install git

# Bundler
RUN gem install --no-document bundler --pre
