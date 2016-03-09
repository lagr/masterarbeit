require 'pg'
require 'pry'
require 'active_model_serializers'
require 'active_record_migrations'
require 'docker-api'
require 'hutch'

db_config = YAML::load(File.open('./db/config.yml'))
ActiveRecord::Base.establish_connection(db_config['development'])

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

Dir.glob(File.join('./', '{models,lib,consumers,serializers}', '**', '*.rb'), &method(:require))

