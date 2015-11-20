FROM ruby:2.2

# Postgres prerequirements
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >>/etc/apt/sources.list.d/pgdg.list && \
    curl -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update && \
    apt-get install -y \
    postgresql-server-dev-9.4 \
    git \
  && rm -rf /var/lib/apt/lists/*

RUN gem install --no-document bundler --pre
