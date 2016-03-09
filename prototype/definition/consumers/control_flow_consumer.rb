class ControlFlowConsumer
  include Hutch::Consumer
  consume 'wfms.control_flow.#'

  def process(message)
    subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
    case action

    when :index
      Hutch.publish "wfms.control_flow.indexed", control_flows: ControlFlow.all.as_json

    when :show
      Hutch.publish "wfms.control_flow.showed", control_flow: ControlFlow.find(message[:id]).as_json

    when :create
      control_flow = ControlFlow.create(message['control_flow'])
      Hutch.publish "wfms.control_flow.created", control_flow: control_flow.as_json

    when :update
      control_flow = ControlFlow.find(message['id'])
      control_flow.update_attributes(message['control_flow'])
      Hutch.publish "wfms.control_flow.updated", control_flow: control_flow.as_json

    when :destroy
      ControlFlow.find(message['id']).destroy
      Hutch.publish "wfms.control_flow.destroyed"
    end
  end
end
