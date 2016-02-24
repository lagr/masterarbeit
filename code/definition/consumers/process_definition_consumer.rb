class ProcessDefinitionConsumer
  include Hutch::Consumer
  consume 'wfms.process_definition.#'

  def process(message)
    subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
    case action

    when :index
      Hutch.publish "wfms.process_definition.indexed", process_definitions: ProcessDefinition.all.as_json

    when :show
      Hutch.publish "wfms.process_definition.showed", process_definition: ProcessDefinition.find(message[:id]).as_json

    when :create
      process_definition = ProcessDefinition.create(message['process_definition'])
      Hutch.publish "wfms.process_definition.created", process_definition: process_definition.as_json

    when :update
      process_definition = ProcessDefinition.find(message['id'])
      process_definition.update_attributes(message['process_definition'])
      Hutch.publish "wfms.process_definition.updated", process_definition: process_definition.as_json

    when :destroy
      ProcessDefinition.find(message['id']).destroy
      Hutch.publish "wfms.process_definition.destroyed"
    end
  end
end
