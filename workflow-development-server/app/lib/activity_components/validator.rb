require 'rubygems'
require 'json-schema'
require 'fileutils'

module Activity
  class Validator
    attr_accessor :schema, :data 

    def initialize(schema:, data:)
      @schema, @data = schema, data
    end

    def validate
      raise 'Invalid data' unless validate_with_schema
    end

    private

    def validate_with_schema
      return false unless File.exist?(data)
      JSON::Validator.validate(schema, data)
    end
  end
end
