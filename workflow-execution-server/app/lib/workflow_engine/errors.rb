module WorkflowEngine
  module Errors
    class WorkflowInstantiationError < StandardError; end
    class ProcessInstantiationError  < StandardError; end
    class ActivityInstantiationError < StandardError; end

    class WorkflowRelevantDataError < StandardError; end
  end
end
