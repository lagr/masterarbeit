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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  #### Environment

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

  create_table "configurations", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.jsonb    "settings"
    t.boolean  "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  #### Instance Models

  create_table "workflow_instances", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "workflow_id"
    t.string   "instance_state"
    t.jsonb    "instance_data", null: false, default: '{}'
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "process_instances", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "process_definition_id"
    t.uuid     "workflow_instance_id"
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

  #### Workflow Components

  create_table "workflows", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "process_definitions", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "workflow_id"
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

  create_table "process_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "name"
    t.uuid     "process_definition_id"
    t.uuid     "element_id"
    t.string   "element_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "manual_activities", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "automatic_activities", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sub_workflow_activities", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.uuid     "sub_workflow_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "containerized_activities", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "container_activities", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "image"
    t.string   "linked_ports",array: true, default: []
    t.text     "parameters",  array: true, default: []
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "start_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "end_elements", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "triggers", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "events", id: :uuid, default: "uuid_generate_v4()" do |t|
    t.string   "type"
    t.uuid     "subject"
    t.jsonb    "data"
    t.datetime "created_at",  null: false
  end
end
