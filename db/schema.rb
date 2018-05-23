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

ActiveRecord::Schema.define(version: 2018_05_23_010509) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "myo_files", force: :cascade do |t|
    t.integer "trac_visit_id"
    t.string "file", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "myo_participants", force: :cascade do |t|
    t.integer "participant_id"
    t.integer "tracms_myo_id"
    t.string "name", limit: 255
    t.date "scheduled_date"
    t.date "exam_date"
    t.boolean "myo_visit"
    t.boolean "redcap_intake_q"
    t.boolean "redcap_ms_info"
    t.boolean "redcap_whodas"
    t.boolean "redcap_health_intake"
    t.string "mrn", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "dob", limit: 255
    t.string "email", limit: 255
    t.string "sex", limit: 255
    t.string "case_or_control", limit: 255
    t.string "onset", limit: 255
    t.string "disease_type", limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "author", limit: 255
    t.text "project_description"
    t.text "data_description"
    t.text "data_frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "biological_description"
    t.boolean "approved", default: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "resource_id"
    t.string "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "sysadmins", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "title", limit: 255
  end

  create_table "trac_visits", force: :cascade do |t|
    t.integer "myo_participant_id"
    t.date "visit_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "physician_edss"
    t.decimal "goodin_edss"
    t.integer "goodin_sfs"
    t.integer "goodin_ai"
    t.integer "goodin_nrs"
    t.integer "goodin_mds"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", limit: 255, null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.text "object_changes", limit: 1073741823
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

end
