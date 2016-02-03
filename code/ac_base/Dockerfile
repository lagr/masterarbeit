# Base image
FROM ruby:2.2

# Shared files
RUN apt-get update && apt-get install -y git \
	&& wget -qO- https://get.docker.com/ | sh \
 	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /wfms
WORKDIR /wfms
ADD ["Gemfile", "Gemfile.lock", "/wfms/"]
RUN bundle install

# Activity files
RUN mkdir /activity
WORKDIR /activity
ENTRYPOINT ruby run.rb
ADD . /activity
