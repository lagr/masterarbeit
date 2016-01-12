ActiveRecord::Schema.define(version: 20151106231005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "activity_data_mappings", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.uuid     "workflow_id"
    t.uuid     "activity_id"
    t.string   "activity_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "and_join_elements", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "and_split_elements", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assignments", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "role_id"
    t.uuid     "assignable_id"
    t.string   "assignable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "automatic_activities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configurations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.jsonb    "settings"
    t.boolean  "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "container_activities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.string   "linked_ports", default: [],              array: true
    t.text     "parameters",   default: [],              array: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "containerized_activities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "control_flows", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "process_definition_id"
    t.uuid     "successor_id"
    t.string   "successor_type"
    t.uuid     "predecessor_id"
    t.string   "predecessor_type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "data_schemas", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "data_schema_owner_id"
    t.string   "data_schema_owner_type"
    t.jsonb    "template",               default: {}, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "end_elements", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "execution_environment", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "manual_activities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "or_join_elements", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "or_split_elements", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "process_definitions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "workflow_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "activity_representations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.uuid     "activity_id"
    t.integer  "x",                  default: 0
    t.integer  "y",                  default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "activities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "process_definition_id"
    t.uuid     "element_id"
    t.string   "activity_type"
    t.jsonb    "input_schema"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "roles", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.uuid     "parent_role_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "servers", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "docker_port",                default: "2375"
    t.string   "execution_environment_port", default: "3001"
    t.string   "role"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "servers_workflow_bundles", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "server_id"
    t.uuid     "workflow_bundle_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "start_elements", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_workflow_activities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.uuid     "sub_workflow_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "triggers", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.uuid     "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflow_bundles", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflow_bundles_workflows", force: :cascade do |t|
    t.uuid     "workflow_id"
    t.uuid     "workflow_bundle_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "workflows", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
