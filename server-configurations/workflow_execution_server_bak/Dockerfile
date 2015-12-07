FROM jpetazzo/dind

##############################  Install Ruby  ##############################
ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.3
ENV RUBY_DOWNLOAD_SHA256 df795f2f99860745a416092a4004b016ccf77e8b82dec956b120f18bdc71edce
ENV RUBYGEMS_VERSION 2.5.0

# skip installing gem documentation
RUN echo 'install: --no-document\nupdate: --no-document' >> "$HOME/.gemrc"

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y curl git htop man unzip wget autoconf && \
  apt-get install -y bison libgdbm-dev ruby && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir -p /usr/src/ruby && \
  curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" && \
  echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - && \
  tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 && \
  rm ruby.tar.gz && \
  cd /usr/src/ruby && \
  autoconf && \
  ./configure --disable-install-doc && \
  make -j"$(nproc)" && \
  make install && \
  apt-get purge -y --auto-remove bison libgdbm-dev ruby && \
  gem update --system $RUBYGEMS_VERSION && \
  rm -r /usr/src/ruby

ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

ENV BUNDLER_VERSION 1.10.6

RUN gem install bundler --version "$BUNDLER_VERSION" \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

############################## Install Postgres ##############################
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >>/etc/apt/sources.list.d/pgdg.list && \
    curl -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-server-dev-9.4

