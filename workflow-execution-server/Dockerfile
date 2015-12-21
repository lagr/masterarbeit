FROM ruby:2.2

RUN mkdir /app

RUN apt-get update && \
    apt-get install -y \
    git \
 && rm -rf /var/lib/apt/lists/* \
 
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"
RUN wget -qO- https://get.docker.com/ | sh

WORKDIR /app
ADD . /app
RUN chmod +x /app/start
