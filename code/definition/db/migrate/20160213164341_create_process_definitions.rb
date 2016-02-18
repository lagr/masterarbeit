class CreateProcessDefinitions < ActiveRecord::Migration
  def change
    create_table :process_definitions, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.uuid :workflow_id

      t.timestamps null: false
    end
  end
end
