require 'hutch'
require 'docker-api'

begin
  Docker::Event.stream do |event|
    Hutch.publish "wfms.docker.#{event.status}", event.as_json
  end
rescue
  retry
end
