class AddWorkflowVersions < ActiveRecord::Migration
  def change
    create_table :workflow_versions, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :name
      t.uuid :workflow_id
      t.timestamps null: false
    end
  end
end
