FROM ruby:2.2

RUN wget -qO- https://get.docker.com/ | sh
COPY ["process_definition.rb", "activity_instance.rb", "mapper.rb", "run.rb", "process_instance.rb", "validator.rb", "logger.rb", "configuration.rb", "docker.rb", "/workflow/"]
RUN chmod +x /workflow/run.rb

CMD []
