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

ActiveRecord::Schema.define(version: 20150306162723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "citext"

  create_table "attachments", force: :cascade do |t|
    t.string   "name"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.integer  "story_id"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
  end

  add_index "attachments", ["attachable_id"], name: "index_attachments_on_attachable_id", using: :btree
  add_index "attachments", ["owner_id"], name: "index_attachments_on_owner_id", using: :btree
  add_index "attachments", ["story_id"], name: "index_attachments_on_story_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["owner_id"], name: "index_comments_on_owner_id", using: :btree

  create_table "metadata", force: :cascade do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id", using: :btree
  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree

  create_table "projects_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  create_table "stories", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories", ["project_id"], name: "index_stories_on_project_id", using: :btree
  add_index "stories", ["slug"], name: "index_stories_on_slug", unique: true, using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "label"
    t.integer  "story_id"
    t.integer  "assigned_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.boolean  "completed",    default: false, null: false
    t.datetime "completed_on"
    t.integer  "completed_by"
  end

  add_index "tasks", ["assigned_to"], name: "index_tasks_on_assigned_to", using: :btree
  add_index "tasks", ["owner_id"], name: "index_tasks_on_owner_id", using: :btree
  add_index "tasks", ["story_id"], name: "index_tasks_on_story_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.citext   "username",                                null: false
    t.citext   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,      null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "role",                   default: "user", null: false
    t.integer  "invited_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
