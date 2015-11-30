ActiveRecord::Schema.define(version: 20151106231005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "users", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.uuid     "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.uuid     "parent_role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assignments", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "role_id"
    t.uuid     "assignable_id"
    t.string   "assignable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "execution_environment", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflows", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflow_versions", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.integer  "version", null: false, default: 0
    t.integer  "subversion", null: false, default: 0
    t.integer  "subsubversion", null: false, default: 0
    t.uuid     "workflow_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "process_definitions", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "workflow_version_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "control_flows", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "process_definition_id"
    t.uuid     "successor_id"
    t.string   "successor_type"
    t.uuid     "predecessor_id"
    t.string   "predecessor_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "workflow_bundles", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "workflow_bundles_versions" do |t|
    t.uuid     "workflow_version_id"
    t.uuid     "workflow_bundle_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "process_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "process_definition_id"
    t.uuid     "element_id"
    t.string   "element_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "process_element_representations", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.uuid     "process_element_id"
    t.integer  "x", default: 0
    t.integer  "y", default: 0
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "activity_data_mappings", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.uuid     "workflow_version_id"
    t.uuid     "activity_id"
    t.string   "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "manual_activities", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "automatic_activities", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "containerized_activities", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.string   "image"
    t.text     "parameters",  array: true, default: []
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "start_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "end_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "triggers", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end
  
  create_table "and_split_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "or_split_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end
  
  create_table "and_join_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "or_join_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "workflow_version_instances", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "workflow_version_id"
    t.string   "instance_state"
    t.jsonb    "instance_data", null: false, default: '{}'
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "process_instances", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "process_definition_id"
    t.uuid     "workflow_version_instance_id"
    t.string   "instance_state"
    t.jsonb    "instance_data", null: false, default: '{}'
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "activity_instances", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "process_instance_id"
    t.string   "instance_state"
    t.jsonb    "instance_data", null: false, default: '{}'
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "data_schemas", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "data_schema_owner_id"
    t.string   "data_schema_owner_type"
    t.jsonb    "template", null: false, default: '{}'
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "servers", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "docker_port", default: '2375'
    t.string   "role"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "worklist_items", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "worklist_id"
    t.uuid     "activity_instance_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "worklists", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
