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

ActiveRecord::Schema.define(version: 20160122104817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "activities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "activity_type"
    t.uuid     "process_definition_id"
    t.jsonb    "input_schema"
    t.jsonb    "output_schema"
    t.jsonb    "activity_configuration"
    t.jsonb    "representation"
    t.uuid     "subworkflow_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "assignments", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "activity_id"
    t.uuid     "assignable_id"
    t.string   "assignable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "control_flows", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "process_definition_id"
    t.uuid     "successor_id"
    t.uuid     "predecessor_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "process_definitions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "workflow_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
    t.jsonb    "server_configuration"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "servers_workflows", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid "server_id"
    t.uuid "workflow_id"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.uuid     "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflows", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.uuid     "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
