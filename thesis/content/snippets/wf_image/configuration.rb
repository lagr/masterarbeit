module Workflow
  module Configuration
    extend self

    def main_workflow_id
      ENV['MAIN_WORKFLOW_ID']
    end

    def main_workflow_instance_id
      ENV['MAIN_WORKFLOW_INSTANCE_ID']
    end

    def workflow_id
      ENV['WORKFLOW_ID']
    end

    def workflow_instance_id
      ENV['INSTANCE_ID']
    end

    def workflow_instance_container
      "wfi_#{workflow_instance_id}"
    end

    def process_definition
      ENV['PROCESS_DEFINITION_PATH'] || '/workflow/process_definition.json'
    end

    def image_registry
      ENV['IMAGE_REGISTRY'] || '192.168.99.100:5000'
    end

    def network
      ENV['NETWORK'] || "net_#{workflow_instance_id}"
    end

    def gem_data_container
      ENV['GEM_DATA_CONTAINER'] || 'gem_data'
    end

    def workflow_relevant_data_container
      ENV['DATA_CONTAINER'] || "data_#{workflow_instance_id}"
    end

    def confdir
      ENV['CONFDIR'] || '/workflow'
    end

    def workdir
      ENV['WORKDIR'] || "/workflow_relevant_data"
    end

    def input_schema
      ENV['INPUT_SCHEMA'] || "#{confdir}/input.schema.json"
    end

    def output_schema
      ENV['OUTPUT_SCHEMA'] || "#{confdir}/output.schema.json"
    end

    def input_data
      ENV['INPUT_DATA'] || "#{confdir}/input.data.json"
    end

    def output_data
      ENV['OUTPUT_DATA'] || "#{confdir}/output/output.data.json"
    end

    def keep_activity_containers?
      ENV['KEEP_ACTIVITY_CONTAINERS'] || true
    end
  end
end
