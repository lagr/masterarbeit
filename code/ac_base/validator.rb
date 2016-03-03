require 'json-schema'
require 'fileutils'

module Activity
  class Validator
    attr_accessor :schema, :data

    def initialize(schema:, data:)
      @schema, @data = schema, data
    end

    def validate
      validation_result = validate_with_schema
      raise "Invalid data: #{validation_result.join('\n')}" unless validation_result.empty?
    end

    private

    def validate_with_schema
      return JSON::Validator.validate(schema, "{}") unless File.exist?(data)
      JSON::Validator.fully_validate(schema, data)
    end
  end
end
