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

    def pause(workflow_instance_id)
      workflow_instance_containers(workflow_instance_id).map(&:pause)
    end

    def unpause(workflow_instance_id)
      workflow_instance_containers(workflow_instance_id).map(&:unpause)
    end

    def terminate(workflow_instance_id)
      workflow_instance_containers(workflow_instance_id).map(&:kill)
      workflow_instance_containers(workflow_instance_id).map(&:delete)
    end

    private

    def workflow_instance_containers(workflow_instance_id)
      filters =  { label: ["wfi_#{workflow_instance_id}"] }.to_json
      Docker::Container.all(all: 1, filters: filters)
    end
  end
end
