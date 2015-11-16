FROM docker:1.9-dind

############################## Install Ruby ##############################
RUN apt-get update && \
  apt-get install -y build-essential && \
  apt-get install -y curl git htop man unzip wget 

RUN wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
RUN tar -xzvf ruby-install-0.5.0.tar.gz
WORKDIR ruby-install-0.5.0
RUN make install

RUN ruby-install ruby 2.2.3 -- --disable-install-doc

# Add Ruby binaries to $PATH
ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin
RUN echo 'export PATH="$PATH:/opt/rubies/ruby-2.2.3/bin"' > /etc/profile.d/ruby.sh
RUN chmod a+x /etc/profile.d/ruby.sh
RUN echo '\nsource /etc/profile.d/ruby.sh' >> /etc/bash.bashrc

# Adjust user gem settings
RUN echo 'if (( $UID != 0 )); then\n\texport GEM_HOME="$HOME/.gems/2.2.3"\n\texport PATH="$PATH:$GEM_HOME/bin"\nfi' >> /etc/profile.d/ruby.sh

# Never install Ruby docs
RUN mkdir /opt/rubies/ruby-2.2.3/etc
RUN echo "gem: --no-document" > /opt/rubies/ruby-2.2.3/etc/gemrc

# Install global gems
RUN /bin/bash -l -c 'gem install bundler'

RUN gem install --no-document bundler --pre

############################## Install Postgres ##############################
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >>/etc/apt/sources.list.d/pgdg.list && \
    curl -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-server-dev-9.4

