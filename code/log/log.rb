require 'pg'
require 'pry'
require 'active_record_migrations'
require 'hutch'

db_config = YAML::load(File.open('./db/config.yml'))
ActiveRecord::Base.establish_connection(db_config['development'])

class Event < ActiveRecord::Base
end
