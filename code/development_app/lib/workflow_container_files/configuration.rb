module Workflow
  module Configuration
    extend self

    def main_workflow_id
      ENV['MAIN_WORKFLOW_ID']
    end

    def workflow_id
      ENV['WORKFLOW_ID']
    end

    def workflow_instance_id
      ENV['WORKFLOW_INSTANCE_ID']
    end

    def process_definition
      ENV['PROCESS_DEFINITION_PATH'] || '/workflow/process_definition.json'
    end

    def image_repository
      ENV['IMAGE_REPOSITORY'] || 'localhost:5000'
    end

    def network
      ENV['NETWORK'] || "net_#{main_workflow_id}"
    end

    def gem_data_container
      ENV['GEM_DATA_CONTAINER'] || 'gem_data'
    end

    def workflow_relevant_data_container
      ENV['DATA_CONTAINER'] || "data_#{workflow_instance_id}"
    end

    def workdir
      ENV['WORKDIR'] || '/workflow'
    end

    def input_schema
      ENV['INPUT_SCHEMA'] || "#{workdir}/input.schema.json"
    end

    def output_schema
      ENV['OUTPUT_SCHEMA'] || "#{workdir}/output.schema.json"
    end

    def input_data
      ENV['INPUT_DATA'] || "#{workdir}/input.data.json"
    end

    def output_data
      ENV['OUTPUT_DATA'] || "#{workdir}/output/output.data.json"
    end
  end
end
