module Workflow::Configuration
  def workdir
    ENV['WORKDIR']
  end

  def input_schema
    ENV['INPUT_SCHEMA'] || 'input.schema.json'
  end

  def output_schema
    ENV['OUTPUT_SCHEMA'] || 'output.schema.json'
  end

  def input_mapping
    ENV['INPUT_MAPPING'] || 'input.mapping.json'
  end

  def output_mapping
    ENV['OUTPUT_MAPPING'] || 'output.mapping.json'
  end

  def input_dir
    ENV['INPUT_DIR'] || "#{workdir}/input/"
  end

  def output_dir
    ENV['OUTPUT_DIR'] || "#{workdir}/output/"
  end

  def input_data
    ENV['INPUT_DATA'] || "#{input_dir}/input.data.json"
  end

  def output_data
    ENV['OUTPUT_DATA'] || "#{output_dir}/output/output.data.json"
  end
end
