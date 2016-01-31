module MessageService
  extend self

  def publish(subject, action, payload = {})
    Hutch.publish routing_key(subject, action), payload
  end

  private

  def routing_key(subject, action)
    return "" if subject.blank? || action.blank?
    "wfms.#{subject}.#{action}"
  end
end
