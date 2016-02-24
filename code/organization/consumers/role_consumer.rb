class RoleConsumer
  include Hutch::Consumer
  consume 'wfms.role.#'

  def process(message)
    subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
    case action

    when :index
      Hutch.publish "wfms.role.indexed", roles: Role.all.as_json

    when :show
      Hutch.publish "wfms.role.showed", role: Role.find(message[:id]).as_json

    when :create
      role = Role.create(message['role'])
      Hutch.publish "wfms.role.created", role: role.as_json

    when :update
      role = Role.find(message['id'])
      role.update_attributes(message['role'])
      Hutch.publish "wfms.role.updated", role: role.as_json

    when :destroy
      Role.find(message['id']).destroy
      Hutch.publish "wfms.role.destroyed"
    end
  end
end
