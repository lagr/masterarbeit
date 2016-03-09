class UserConsumer
  include Hutch::Consumer
  consume 'wfms.user.#'

  def process(message)
    subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
    case action

    when :index
      Hutch.publish "wfms.user.indexed", users: User.all.as_json

    when :show
      Hutch.publish "wfms.user.showed", user: User.find(message[:id]).as_json

    when :create
      user = User.create(message['user'])
      Hutch.publish "wfms.user.created", user: user.as_json

    when :update
      user = User.find(message['id'])
      user.update_attributes(message['user'])
      Hutch.publish "wfms.user.updated", user: user.as_json

    when :destroy
      User.find(message['id']).destroy
      Hutch.publish "wfms.user.destroyed"
    end
  end
end
