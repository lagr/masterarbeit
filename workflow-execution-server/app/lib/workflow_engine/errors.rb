module WorkflowEngine
  module Errors
    class WorkflowVersionInstantiationError < StandardError; end
    class ProcessInstantiationError  < StandardError; end
    class ActivityInstantiationError < StandardError; end
  end
end
