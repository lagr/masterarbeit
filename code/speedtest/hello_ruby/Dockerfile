FROM ruby:2.2

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN chmod +x /app/hello.rb
ENTRYPOINT ruby /app/hello.rb
