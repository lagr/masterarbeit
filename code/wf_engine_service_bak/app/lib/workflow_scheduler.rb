module WorkflowScheduler
  extend self

  @connection = Bunny.new('mom_service_1')
  @connection.start
  @channel  = @connection.create_channel
  # topic exchange name can be any string
  wf_instances_exchange = channel.topic("workflowinstances", :auto_delete => true)

  @workflow_instances = []

  def run_workflow(workflow_id, input_data = {this: "is a test"})
    constraints = constraints(workflow_id)
    workflow_instance = WorkflowInstance.new(workflow_id, input_data, 'cloud-machine')
    @workflow_instances << workflow_instance
    begin
      workflow_instance.run
    end
  end

  private

  def create

  def constraints(workflow_id)
    ['constraints:node==cloud-machine']
    #["constraints:edu.proto.machine_env=external"]
    # if node given: node
    # else find by label
  end
end
