class CreateWorklistItems < ActiveRecord::Migration
  def change
    create_table :worklist_items, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.jsonb :config
      t.jsonb :data
      t.uuid :role_id
      t.uuid :activity_instance_id
      t.uuid :workflow_instance_id

      t.timestamps null: false
    end
  end
end
