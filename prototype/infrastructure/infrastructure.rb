require 'active_support/all'
require 'docker-api'
require 'hutch'

Hutch::Config.tap do |c|
  c.set :mq_host,     'wfms_mom_1'
  c.set :mq_api_host, 'wfms_mom_1'
  c.set :mq_exchange, 'wfms'
end

begin
  Hutch.connect
rescue
  sleep 5
  retry
end

Dir.glob(File.join('./', '{models,lib,consumers}', '**', '*.rb'), &method(:require))
extra_process = fork { EnvironmentManager.watch_for_new_nodes }
Process.detach extra_process
