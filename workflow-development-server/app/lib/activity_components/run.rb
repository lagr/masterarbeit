require 'rubygems'
require_relative 'validate'
require_relative 'map'
require_relative 'activity'

WORKFLOW_RELEVANT_DATA = "/app/tmp/#{ENV['WORKFLOW_RELEVANT_DATA_DIR']}"
INPUT_SCHEMA  = 'input.schema.json'
OUTPUT_SCHEMA = 'output.schema.json'
INPUT_MAPPING  = 'input.mapping.json'
OUTPUT_MAPPING = 'output.mapping.json'
INPUT_DIR = "#{WORKFLOW_RELEVANT_DATA}/input/"
OUTPUT_DIR = "#{WORKFLOW_RELEVANT_DATA}/output/"
INPUT_DATA  = "#{INPUT_DIR}/input.data.json"
OUTPUT_DATA = "#{OUTPUT_DIR}/output/output.data.json"

Validator.new(schema: DEFAULT_INPUT_SCHEMA, data: DEFAULT_INPUT_DATA).validate
# Mapper.new(DEFAULT_INPUT_MAPPING, DEFAULT_INPUT_DATA).map

Activity.new(INPUT_DIR, OUTPUT_DIR, nil).run

# Mapper.new(DEFAULT_OUTPUT_MAPPING, DEFAULT_OUTPUT_DATA).map
Validator.new(schema: DEFAULT_OUTPUT_SCHEMA, data: DEFAULT_OUTPUT_DATA).validate

raise StandardError, 'TEST'
