module Worklist
  class RoleConsumer
    include Hutch::Consumer
    consume 'wfms.role.destroyed'

    def process(message)
      worklist_items = WorklistItem.where(role_id: message[:role_id]).destroy_all
    end
  end
end
