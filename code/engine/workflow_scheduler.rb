module WorkflowEngine
  class WorkflowScheduler
    def initialize(engine)
      @engine = engine
      @workflow_instances = []
    end

    def instanciate(workflow_id)
      target_node = 'cloud-machine' #determine_target_node(workflow_id)
      @workflow_instances << WorkflowInstance.new(workflow_id, target_node)
    end
  end
end
