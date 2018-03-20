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

ActiveRecord::Schema.define(version: 20161031115547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batch_feedbacks", force: :cascade do |t|
    t.date     "feedback_date"
    t.integer  "overall_impression"
    t.integer  "appearance"
    t.integer  "quantity_impression"
    t.integer  "piece_size"
    t.integer  "spiciness"
    t.integer  "saltiness"
    t.integer  "fibrousness"
    t.integer  "chewiness"
    t.integer  "thickness"
    t.integer  "coloration"
    t.integer  "flavor_quality"
    t.integer  "flavor_strength"
    t.integer  "aroma_quality"
    t.integer  "aroma_strength"
    t.boolean  "sellable"
    t.integer  "batch_id"
    t.integer  "user_id"
    t.string   "notes",               limit: 3000
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["batch_id"], name: "index_batch_feedbacks_on_batch_id", using: :btree
    t.index ["user_id"], name: "index_batch_feedbacks_on_user_id", using: :btree
  end

  create_table "batch_logs", force: :cascade do |t|
    t.integer  "batch_id"
    t.string   "action"
    t.integer  "approved_by_id"
    t.datetime "approved_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["approved_by_id"], name: "index_batch_logs_on_approved_by_id", using: :btree
    t.index ["batch_id"], name: "index_batch_logs_on_batch_id", using: :btree
  end

  create_table "batches", force: :cascade do |t|
    t.date     "production_date"
    t.integer  "manager_on_duty_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "slug"
    t.integer  "primary_ingredient_shipment_id"
    t.float    "net_weight_sellable"
    t.float    "net_weight_seconds"
    t.float    "fresh_primary_ingredient_loss"
    t.integer  "recipe_id"
    t.float    "gross_fresh_primary_ingredient"
    t.integer  "pouches_produced"
    t.string   "flavor_notes"
    t.string   "workflow_state"
    t.string   "rejection_reason",       limit: 2000
    t.string   "cancellation_reason",    limit: 2000
    t.integer  "shipment_id"
    t.integer  "amount_of_primary_ingredient"
    t.integer  "cartons_packed"
    t.float    "harvest_thick"
    t.float    "harvest_thin"
    t.float    "harvest_good"
    t.float    "harvest_scraps"
    t.float    "unusable_thin_product"
    t.float    "unusable_thick_product"
    t.float    "unusable_other_product"
    t.index ["manager_on_duty_id"], name: "index_batches_on_manager_on_duty_id", using: :btree
    t.index ["primary_ingredient_shipment_id"], name: "index_batches_on_primary_ingredient_shipment_id", using: :btree
    t.index ["production_date"], name: "index_batches_on_production_date", using: :btree
    t.index ["recipe_id"], name: "index_batches_on_recipe_id", using: :btree
    t.index ["shipment_id"], name: "index_batches_on_shipment_id", using: :btree
    t.index ["slug"], name: "index_batches_on_slug", using: :btree
    t.index ["workflow_state"], name: "index_batches_on_workflow_state", using: :btree
  end

  create_table "configurations", force: :cascade do |t|
    t.integer  "default_tumbler_program_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["default_tumbler_program_id"], name: "index_configurations_on_default_tumbler_program_id", using: :btree
  end

  create_table "dashboard_projects", force: :cascade do |t|
    t.string   "name"
    t.datetime "project_modified_at"
    t.datetime "status_updated_at"
    t.string   "status_updated_by"
    t.string   "status_color"
    t.date     "due_date"
    t.string   "project_id"
    t.string   "current_status"
    t.string   "color"
    t.string   "notes"
    t.boolean  "archived"
    t.boolean  "display_in_dashboard", default: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "dashboard_tasks", force: :cascade do |t|
    t.string   "assignee"
    t.boolean  "completed"
    t.datetime "completed_at"
    t.datetime "task_created_at"
    t.datetime "due_at"
    t.datetime "due_on"
    t.string   "task_id"
    t.string   "name"
    t.string   "notes"
    t.datetime "task_modified_at"
    t.integer  "dashboard_project_id"
    t.integer  "sort_key"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["dashboard_project_id"], name: "index_dashboard_tasks_on_dashboard_project_id", using: :btree
  end

  create_table "deployments", force: :cascade do |t|
    t.datetime "deployed_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deployed_at"], name: "index_deployments_on_deployed_at", using: :btree
  end

  create_table "flavors", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "slug"
    t.integer  "default_recipe_id"
    t.index ["default_recipe_id"], name: "index_flavors_on_default_recipe_id", using: :btree
    t.index ["slug"], name: "index_flavors_on_slug", using: :btree
  end

  create_table "fulfillment_warehouses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gcal_events", force: :cascade do |t|
    t.integer  "batch_id"
    t.string   "event_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "google_calendar_id"
    t.index ["batch_id"], name: "index_gcal_events_on_batch_id", using: :btree
    t.index ["google_calendar_id"], name: "index_gcal_events_on_google_calendar_id", using: :btree
  end

  create_table "google_calendars", force: :cascade do |t|
    t.string   "name"
    t.string   "calendar_id"
    t.string   "title"
    t.string   "time_zone"
    t.string   "description"
    t.string   "location"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "google_calendars_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "google_calendar_id"
    t.index ["google_calendar_id"], name: "index_google_calendars_users_on_google_calendar_id", using: :btree
    t.index ["user_id"], name: "index_google_calendars_users_on_user_id", using: :btree
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.string   "instructions"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "issues", force: :cascade do |t|
    t.integer  "batch_id"
    t.string   "problem"
    t.string   "steps_to_correct"
    t.string   "workflow_state"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["batch_id"], name: "index_issues_on_batch_id", using: :btree
    t.index ["workflow_state"], name: "index_issues_on_workflow_state", using: :btree
  end

  create_table "manual_change_logs", force: :cascade do |t|
    t.string   "document_type"
    t.integer  "document_id"
    t.string   "body"
    t.string   "notes"
    t.string   "version"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["user_id"], name: "index_manual_change_logs_on_user_id", using: :btree
  end

  create_table "manual_process_flows", force: :cascade do |t|
    t.string   "title"
    t.string   "version"
    t.string   "document_id"
    t.integer  "author_id"
    t.string   "category"
    t.string   "product"
    t.string   "workflow_state"
    t.text     "body"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "layout"
    t.float    "aspect_ratio"
    t.string   "slug"
    t.integer  "process_id"
    t.index ["slug"], name: "index_manual_process_flows_on_slug", using: :btree
  end

  create_table "manual_standard_operating_procedures", force: :cascade do |t|
    t.string   "title"
    t.string   "version"
    t.string   "document_id"
    t.integer  "author_id"
    t.string   "workflow_state"
    t.text     "body"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "slug"
    t.integer  "process_id"
    t.index ["slug"], name: "index_manual_standard_operating_procedures_on_slug", using: :btree
  end

  create_table "primary_ingredient_shipments", force: :cascade do |t|
    t.datetime "received_at"
    t.integer  "primary_ingredient_supplier_id"
    t.float    "amount_in_kg"
    t.string   "notes",              limit: 5000
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "amount_of_primary_ingredient"
    t.index ["primary_ingredient_supplier_id"], name: "index_primary_ingredient_shipments_on_primary_ingredient_supplier_id", using: :btree
  end

  create_table "primary_ingredient_suppliers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "notes"
    t.integer  "noteworthy_id"
    t.string   "noteworthy_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "text"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "include_table_of_contents"
  end

  create_table "photos", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_photos_on_owner_id_and_owner_type", using: :btree
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string   "po_number"
    t.date     "due_date"
    t.integer  "boxes_flavor1"
    t.integer  "boxes_flavor3"
    t.integer  "boxes_flavor2"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "workflow_state"
    t.text     "comments"
    t.integer  "fulfillment_warehouse_id"
    t.string   "manufacturing_purchase_order_file_name"
    t.string   "manufacturing_purchase_order_content_type"
    t.integer  "manufacturing_purchase_order_file_size"
    t.datetime "manufacturing_purchase_order_updated_at"
    t.index ["fulfillment_warehouse_id"], name: "index_purchase_orders_on_fulfillment_warehouse_id", using: :btree
    t.index ["workflow_state"], name: "index_purchase_orders_on_workflow_state", using: :btree
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.float    "parts_per_hundred"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.float    "grams_per_kilo_primary_ingredient"
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id", using: :btree
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id", using: :btree
  end

  create_table "recipes", force: :cascade do |t|
    t.integer  "flavor_id"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.string   "description"
    t.integer  "sort_key"
    t.index ["flavor_id", "sort_key"], name: "index_recipes_on_flavor_id_and_sort_key", using: :btree
    t.index ["flavor_id"], name: "index_recipes_on_flavor_id", using: :btree
    t.index ["slug"], name: "index_recipes_on_slug", using: :btree
  end

  create_table "shipments", force: :cascade do |t|
    t.date     "ships_on"
    t.string   "workflow_state"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "ship_by_air"
    t.string   "house_airway_bill"
    t.string   "master_airway_bill"
    t.string   "carrier"
    t.datetime "shipped_at"
    t.text     "notes"
    t.string   "commercial_invoice_file_name"
    t.string   "commercial_invoice_content_type"
    t.integer  "commercial_invoice_file_size"
    t.datetime "commercial_invoice_updated_at"
    t.string   "packing_list_file_name"
    t.string   "packing_list_content_type"
    t.integer  "packing_list_file_size"
    t.datetime "packing_list_updated_at"
    t.integer  "boxes_packed_flavor1"
    t.integer  "boxes_packed_flavor3"
    t.integer  "boxes_packed_flavor2"
    t.date     "shipped_on"
    t.integer  "purchase_order_id"
    t.integer  "boxes_ordered_flavor1"
    t.integer  "boxes_ordered_flavor3"
    t.integer  "boxes_ordered_flavor2"
    t.index ["purchase_order_id"], name: "index_shipments_on_purchase_order_id", using: :btree
    t.index ["workflow_state"], name: "index_shipments_on_workflow_state", using: :btree
  end

  create_table "skus", force: :cascade do |t|
    t.string   "title"
    t.integer  "flavor_id"
    t.float    "net_weight"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "composed_quantity"
    t.integer  "composed_of_id"
    t.string   "upc_filename"
    t.index ["composed_of_id"], name: "index_skus_on_composed_of_id", using: :btree
    t.index ["flavor_id"], name: "index_skus_on_flavor_id", using: :btree
  end

  create_table "tumbler_programs", force: :cascade do |t|
    t.integer  "running_time"
    t.integer  "idle_time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                         default: "",   null: false
    t.string   "encrypted_password",            default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.boolean  "receive_worksheets"
    t.integer  "role"
    t.boolean  "receive_issue_mailings"
    t.boolean  "receive_confirmation_mailings", default: true
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "weather_readings", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "city"
    t.datetime "taken_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.float    "temperature_scalar"
    t.string   "temperature_units",  limit: 50
    t.float    "humidity_scalar"
    t.string   "humidity_units",     limit: 50
    t.float    "pressure_scalar"
    t.string   "pressure_units",     limit: 50
    t.integer  "batch_id"
    t.index ["batch_id"], name: "index_weather_readings_on_batch_id", using: :btree
  end

  add_foreign_key "batch_feedbacks", "batches"
  add_foreign_key "batch_feedbacks", "users"
  add_foreign_key "batch_logs", "batches"
  add_foreign_key "batch_logs", "users", column: "approved_by_id"
  add_foreign_key "batches", "primary_ingredient_shipments"
  add_foreign_key "batches", "recipes"
  add_foreign_key "batches", "shipments"
  add_foreign_key "dashboard_tasks", "dashboard_projects"
  add_foreign_key "flavors", "recipes", column: "default_recipe_id"
  add_foreign_key "gcal_events", "batches"
  add_foreign_key "gcal_events", "google_calendars"
  add_foreign_key "google_calendars_users", "google_calendars"
  add_foreign_key "google_calendars_users", "users"
  add_foreign_key "issues", "batches"
  add_foreign_key "manual_change_logs", "users"
  add_foreign_key "manual_process_flows", "users", column: "author_id"
  add_foreign_key "manual_standard_operating_procedures", "users", column: "author_id"
  add_foreign_key "primary_ingredient_shipments", "primary_ingredient_suppliers"
  add_foreign_key "notes", "users"
  add_foreign_key "purchase_orders", "fulfillment_warehouses"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "flavors"
  add_foreign_key "shipments", "purchase_orders"
  add_foreign_key "skus", "flavors"
  add_foreign_key "skus", "skus", column: "composed_of_id"
  add_foreign_key "weather_readings", "batches"
end
