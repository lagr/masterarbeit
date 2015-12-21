require 'rubygems'
require 'json'
require 'fileutils'
require 'aasm'
require 'excon'

require_relative 'configuration'
require_relative 'validator'
require_relative 'mapper'
require_relative 'activity'
require_relative 'logger'

module Activity
  extend self

  def run
    config = Activity::Configuration
    logger = Activity::Logger.new
    Activity::Validator.new(schema: "#{config.workdir}/input.schema.json", data: "#{config.workdir}/input/input.data.json").validate
    # Mapper.new(DEFAULT_INPUT_MAPPING, DEFAULT_INPUT_DATA).map

    logger.event({ id: Activity::Configuration.activity_id, type: 'Activity' }, { info: "Running activity instance for #{Activity::Configuration.activity_id}" }))

    #Activity.new(INPUT_DIR, OUTPUT_DIR, nil).run
    puts "Activity         : #{Activity::Configuration.activity_id}"
    puts "Activity Instance: #{Activity::Configuration.activity_instance_id}"
    # Mapper.new(DEFAULT_OUTPUT_MAPPING, DEFAULT_OUTPUT_DATA).map
    #Validator.new(schema: DEFAULT_OUTPUT_SCHEMA, data: DEFAULT_OUTPUT_DATA).validate

    #raise StandardError, 'TEST'
  end
end

Activity.run
