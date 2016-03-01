class UserConsumer
  include Hutch::Consumer
  consume 'wfms.user.destroyed'

  def process(message)
    worklist_items = WorklistItems.where(user_id: message[:user_id]).destroy_all
  end
end