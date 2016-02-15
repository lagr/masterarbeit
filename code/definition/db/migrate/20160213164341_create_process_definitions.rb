class CreateProcessDefinitions < ActiveRecord::Migration
  def change
    create_table :process_definitions do |t|
      t.uuid :workflow_id

      t.timestamps null: false
    end
  end
end
