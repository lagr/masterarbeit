# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "execution_environment", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.string   "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflows", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflow_versions", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.uuid     "workflow_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "control_flows", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.uuid     "workflow_version_id"
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

  create_table "workflow_bundles_workflow_versions" do |t|
    t.uuid     "workflow_version_id"
    t.uuid     "workflow_bundle_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "workflow_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "element_id"
    t.string   "element_type"
    t.uuid     "workflow_version_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "workflow_element_representations", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.uuid     "workflow_element_id"
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "activity_mappings", id: :uuid, default: "uuid_generate_v4()" do |t|
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

end
