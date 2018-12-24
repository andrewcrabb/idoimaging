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

ActiveRecord::Schema.define(version: 2018_12_21_052428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.integer "author_id"
    t.string "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "author_programs", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_author_programs_on_author_id"
    t.index ["program_id"], name: "index_author_programs_on_program_id"
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "name_last"
    t.string "name_first"
    t.string "institution"
    t.string "email"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "features", id: :serial, force: :cascade do |t|
    t.string "category"
    t.string "value"
    t.string "description"
    t.string "icon"
    t.string "tooltip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "search_level"
    t.string "icon_prefix"
    t.index ["category", "value"], name: "index_features_on_category_and_value", unique: true
    t.index ["category"], name: "index_features_on_category"
    t.index ["search_level"], name: "index_features_on_search_level"
    t.index ["value"], name: "index_features_on_value"
  end

  create_table "image_formats", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "search_level"
    t.index ["name"], name: "index_image_formats_on_name"
    t.index ["search_level"], name: "index_image_formats_on_search_level"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.text "image"
    t.integer "imageable_id"
    t.string "imageable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_type"
    t.index ["image_type"], name: "index_images_on_image_type"
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "program_components", id: :serial, force: :cascade do |t|
    t.integer "including_program_id"
    t.integer "included_program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind"
    t.index ["included_program_id"], name: "index_program_components_on_included_program_id"
    t.index ["including_program_id"], name: "index_program_components_on_including_program_id"
  end

  create_table "program_features", id: :serial, force: :cascade do |t|
    t.integer "weight"
    t.integer "program_id"
    t.integer "feature_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_program_features_on_feature_id"
    t.index ["program_id"], name: "index_program_features_on_program_id"
  end

  create_table "programs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "summary"
    t.text "description"
    t.date "add_date"
    t.date "remove_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remove_note"
    t.float "rating"
    t.integer "program_kind", default: 0
    t.index ["add_date"], name: "index_programs_on_add_date"
    t.index ["name"], name: "index_programs_on_name"
    t.index ["program_kind"], name: "index_programs_on_program_kind"
    t.index ["rating"], name: "index_programs_on_rating"
    t.index ["remove_date"], name: "index_programs_on_remove_date"
  end

  create_table "ratings", id: :serial, force: :cascade do |t|
    t.integer "rating"
    t.integer "program_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rating_type"
    t.index ["program_id"], name: "index_ratings_on_program_id"
    t.index ["rating_type"], name: "index_ratings_on_rating_type"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "read_program_image_formats", id: :serial, force: :cascade do |t|
    t.integer "weight"
    t.integer "program_id"
    t.integer "image_format_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_format_id"], name: "index_read_program_image_formats_on_image_format_id"
    t.index ["program_id"], name: "index_read_program_image_formats_on_program_id"
  end

  create_table "redirects", id: :serial, force: :cascade do |t|
    t.date "date"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_redirects_on_resource_id"
  end

  create_table "resource_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon"
    t.string "icon_prefix"
    t.index ["name"], name: "index_resource_types_on_name", unique: true
  end

  create_table "resources", id: :serial, force: :cascade do |t|
    t.string "url"
    t.string "description"
    t.date "last_seen"
    t.date "last_tested"
    t.string "identifier"
    t.integer "resourceful_id"
    t.string "resourceful_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resource_type_id"
    t.index ["resource_type_id"], name: "index_resources_on_resource_type_id"
    t.index ["resourceful_type", "resourceful_id"], name: "index_resources_on_resourceful_type_and_resourceful_id"
    t.index ["url"], name: "index_resources_on_url"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "version"
    t.date "date"
    t.string "note"
    t.string "rev_str"
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "published_on"
    t.date "last_seen"
    t.date "last_tested"
    t.index ["last_seen"], name: "index_versions_on_last_seen"
    t.index ["last_tested"], name: "index_versions_on_last_tested"
    t.index ["program_id"], name: "index_versions_on_program_id"
    t.index ["published_on"], name: "index_versions_on_published_on"
  end

  create_table "write_program_image_formats", id: :serial, force: :cascade do |t|
    t.integer "weight"
    t.integer "program_id"
    t.integer "image_format_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_format_id"], name: "index_write_program_image_formats_on_image_format_id"
    t.index ["program_id"], name: "index_write_program_image_formats_on_program_id"
  end

  add_foreign_key "author_programs", "authors"
  add_foreign_key "author_programs", "programs"
  add_foreign_key "program_features", "features"
  add_foreign_key "program_features", "programs"
  add_foreign_key "ratings", "programs"
  add_foreign_key "ratings", "users"
  add_foreign_key "read_program_image_formats", "image_formats"
  add_foreign_key "read_program_image_formats", "programs"
  add_foreign_key "redirects", "resources"
  add_foreign_key "resources", "resource_types"
  add_foreign_key "versions", "programs"
  add_foreign_key "write_program_image_formats", "image_formats"
  add_foreign_key "write_program_image_formats", "programs"
end
