module Worklist
  class WorklistItemConsumer
    include Hutch::Consumer
    consume 'wfms.worklist_item.#'

    def process(message)
      subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
      case action

      when :index
        worklist_items = WorklistItem.where(role_id: message[:role_id])
        Hutch.publish "wfms.worklist_item.indexed", worklist: worklist_items.as_json

      when :show
        worklist_item = WorklistItem.find(message[:id]).as_json
        Hutch.publish "wfms.worklist_item.showed", worklist_item: worklist_item.as_json

      when :create
        worklist_item = WorklistItem.create(message['worklist_item'])
        Hutch.publish "wfms.worklist_item.created", worklist_item: worklist_item.as_json

      when :update
        worklist_item = WorklistItem.find(message['id'])
        worklist_item.update_attributes(message['worklist_item'])
        Hutch.publish "wfms.worklist_item.updated", worklist_item: worklist_item.reload.as_json

      when :destroy
        worklist_item = WorklistItem.find(message['id']).destroy
        Hutch.publish "wfms.worklist_item.destroyed", worklist_item: worklist_item.as_json
      end
    end
  end
end
