FROM ruby:2.2

COPY ["run.rb", "validate.rb", "map.rb", "/activity/"]
RUN chmod +x /activity/run.rb

# copy activity later to utilize cached "base image",
# which was created by the above commands

COPY ["activity.rb", "/activity/"]

CMD ["ruby /activity/run.rb"]
