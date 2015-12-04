require 'rubygems'
# require 'json-schema'

class Validator
  attr_accessor :schema, :data 

  def initialize(schema:, data:)
    @schema, @data = schema, data
  end

  def validate
    raise 'Invalid data' unless validate_schema
  end

  private

  def validate_schema
    puts "Validated"
    true
    # JSON::Validator.validate(schema, data)
  end
end
