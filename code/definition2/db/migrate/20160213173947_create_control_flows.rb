class CreateControlFlows < ActiveRecord::Migration
  def change
    create_table :control_flows, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.uuid :process_definition_id
      t.uuid :successor_id
      t.uuid :predecessor_id

      t.timestamps null: false
    end
  end
end
