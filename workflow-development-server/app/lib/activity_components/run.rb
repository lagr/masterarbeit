require 'rubygems'
require_relative 'configuration'
require_relative 'validate'
require_relative 'map'
require_relative 'activity'

Validator.new(schema: DEFAULT_INPUT_SCHEMA, data: DEFAULT_INPUT_DATA).validate
# Mapper.new(DEFAULT_INPUT_MAPPING, DEFAULT_INPUT_DATA).map

Activity.new(INPUT_DIR, OUTPUT_DIR, nil).run

# Mapper.new(DEFAULT_OUTPUT_MAPPING, DEFAULT_OUTPUT_DATA).map
Validator.new(schema: DEFAULT_OUTPUT_SCHEMA, data: DEFAULT_OUTPUT_DATA).validate

raise StandardError, 'TEST'
