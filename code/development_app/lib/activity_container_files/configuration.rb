module Activity
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

    def activity_id
      ENV['ACTIVITY_ID']
    end

    def activity_instance_id
      ENV['ACTIVITY_INSTANCE_ID']
    end

    def confdir
      ENV['CONFDIR'] || '/activity'
    end

    def network
      ENV['NETWORK'] || "net_#{workflow_instance_id}"
    end

    def workdir
      ENV['WORKDIR'] || "/workflow_relevant_data/#{activity_instance_id}"
    end

    def input_schema
      ENV['INPUT_SCHEMA'] || "#{confdir}/input.schema.json"
    end

    def output_schema
      ENV['OUTPUT_SCHEMA'] || "#{confdir}/output.schema.json"
    end

    def image_registry
      ENV['IMAGE_REGISTRY'] || '192.168.99.100:5000'
    end
  end
end
