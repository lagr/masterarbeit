require 'rubygems'
require_relative 'validate'
require_relative 'map'
require_relative 'activity'

DEFAULT_INPUT_SCHEMA  = 'input.schema.json'
DEFAULT_OUTPUT_SCHEMA = 'output.schema.json'
DEFAULT_INPUT_MAPPING  = 'input.mapping.json'
DEFAULT_OUTPUT_MAPPING = 'output.mapping.json'
DEFAULT_INPUT_DATA  = '../input/input.data.json'
DEFAULT_OUTPUT_DATA = '../output/output.data.json'

Validator.new(schema: DEFAULT_INPUT_SCHEMA, data: DEFAULT_INPUT_DATA).validate
# Mapper.new(DEFAULT_INPUT_MAPPING, DEFAULT_INPUT_DATA).map

Activity.new.run

# Mapper.new(DEFAULT_OUTPUT_MAPPING, DEFAULT_OUTPUT_DATA).map
Validator.new(schema: DEFAULT_OUTPUT_SCHEMA, data: DEFAULT_OUTPUT_DATA).validate

raise StandardError, 'TEST'
