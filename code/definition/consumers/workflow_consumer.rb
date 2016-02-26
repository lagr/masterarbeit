class WorkflowConsumer
  include Hutch::Consumer
  consume 'wfms.workflow.#'

  def process(message)
    subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
    case action

    when :index
      Hutch.publish "wfms.workflow.indexed", workflows: Workflow.all.as_json

    when :show
      workflow = Workflow.find(message[:id])
      Hutch.publish "wfms.workflow.showed", workflow: ActiveModel::SerializableResource.new(workflow, serializer: WorkflowFullSerializer, include: '**').serializable_hash

    when :create
      workflow = Workflow.create(message['workflow'])
      Hutch.publish "wfms.workflow.created", workflow: workflow

    when :update
      workflow = Workflow.find(message['id'])
      workflow.update_attributes(message['workflow'])
      Hutch.publish "wfms.workflow.updated", workflow: workflow.as_json

    when :destroy
      Workflow.find(message['id']).destroy
      Hutch.publish "wfms.workflow.destroyed"

    when :export
      Hutch.publish "wfms.workflow.exported", {}
      workflow = Workflow.find(message['id'])
      ImageManager.export_workflow(workflow)
    end
  end
end
