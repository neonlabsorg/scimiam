# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_12_08_081741) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accesses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "role_id", null: false
    t.text "justification"
    t.datetime "expires_at"
    t.string "approvals", default: [], array: true
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_accesses_on_role_id"
    t.index ["user_id", "role_id"], name: "index_accesses_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_accesses_on_user_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "scim_uid"
    t.text "name", null: false
    t.boolean "is_active", default: true
    t.integer "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "scim_uid"
    t.text "username", null: false
    t.text "displayname"
    t.text "first_name"
    t.text "last_name"
    t.text "work_email_address"
    t.boolean "is_active", default: true
  end

  add_foreign_key "accesses", "roles"
  add_foreign_key "accesses", "users"
end
