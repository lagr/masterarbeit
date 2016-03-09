class ActivityConsumer
  include Hutch::Consumer
  consume 'wfms.activity.#'

  def process(message)
    subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
    case action

    when :index
      Hutch.publish "wfms.activity.indexed", activities: Activity.all.as_json

    when :show
      Hutch.publish "wfms.activity.showed", activity: Activity.find(message[:id]).as_json

    when :create
      activity = Activity.create(message['activity'])
      Hutch.publish "wfms.activity.created", activity: activity.as_json

    when :update
      activity = Activity.find(message['id'])
      activity.update_attributes(message['activity'])
      Hutch.publish "wfms.activity.updated", activity: activity.as_json

    when :destroy
      Activity.find(message['id']).destroy
      Hutch.publish "wfms.activity.destroyed"
    end
  end
end
