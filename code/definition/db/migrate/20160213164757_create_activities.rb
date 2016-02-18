class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.string :name
      t.string :activity_type
      t.uuid :process_definition_id
      t.uuid :subworkflow_id
      t.uuid :participant_role_id
      t.jsonb :input_schema
      t.jsonb :output_schema
      t.jsonb :activity_configuration
      t.jsonb :representation

      t.timestamps null: false
    end
  end
end
