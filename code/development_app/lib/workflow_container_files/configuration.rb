module Workflow
  module Configuration
    extend self

    def main_workflow_id
      ENV['MAIN_WORKFLOW_ID']
    end

    def workflow_id
      ENV['WORKFLOW_ID']
    end

    def image_registry
      ENV['IMAGE_REGISTRY'] || 'localhost:5000'
    end

    def network
      ENV['NETWORK'] || "net_#{main_workflow_id}"
    end

    def gem_data_container
      ENV['GEM_DATA_CONTAINER'] || 'workflowexecutionserver_gem_data_1'
    end

    def execution_server_url
      "http://#{execution_server_name}.#{network}:#{execution_server_port}"
    end

    def execution_server_name
      "workflowexecutionserver_web_1"
    end

    def execution_server_port
      ENV['EXECUTION_SERVER_PORT'] || '3001'
    end

    def api_version
      ENV['EXECUTION_SERVER_API_VERSION'] || 'v1'
    end

    def execution_server_api_url
      "http://#{execution_server_name}.#{network}:#{execution_server_port}/api/#{api_version}"
    end

    def workflow_relevant_data_container
      ENV['DATA_CONTAINER']
    end

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
end
