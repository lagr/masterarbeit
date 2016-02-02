require 'uri'

module Workflow
  class Logger
    def initialize
      #@config = Workflow::Configuration
      #@connection = Excon.new(@config.execution_server_url)
    end

    def event(subject, data)
      # @connection.post(
      #   path: '/api/v1/workflow_management/events',
      #   body: URI.encode_www_form(
      #     subject_id: subject[:id],
      #     subject_type: subject[:type],
      #     data: data.to_json
      #   )
      # )
    end
  end
end
