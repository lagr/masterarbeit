FROM docker:1.9-dind

ADD ./test/Gemfile /app/  
ADD ./test/Gemfile.lock /app/

RUN apk --update add --virtual \ 
    build-dependencies \
    build-base \
    git \
    ruby \
    ruby-irb \
    ruby-json \
    ruby-rake \
    ruby-bigdecimal \
    ruby-io-console \
    libstdc++ \
    libffi-dev \
    tzdata \
    postgresql-client \
    nodejs \
    ruby-nokogiri \
    ruby-dev \
    openssl-dev \  
    postgresql-dev \
    libc-dev \
    linux-headers && \
    gem install --no-document bundler && \
    cd /app ; bundle install --without development test && \
    apk del build-dependencies

ADD ./test /app  
RUN chown -R nobody:nogroup /app  
USER nobody

ENV RAILS_ENV production  
WORKDIR /app
 
#CMD ["bundle", "exec", "rails", "s"]
CMD []
