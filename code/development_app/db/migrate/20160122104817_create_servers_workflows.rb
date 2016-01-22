class CreateServersWorkflows < ActiveRecord::Migration
  def change
    create_table :servers_workflows, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.uuid :server_id
      t.uuid :workflow_id
    end
  end
end
