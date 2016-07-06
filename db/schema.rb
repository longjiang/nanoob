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

ActiveRecord::Schema.define(version: 20160703162010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.string   "bootsy_resource_type"
    t.integer  "bootsy_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_products", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_websites", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "platform",    null: false
    t.string   "url",         null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["business_id"], name: "index_business_websites_on_business_id", using: :btree
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name",                null: false
    t.integer  "business_product_id"
    t.integer  "language",            null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["business_product_id"], name: "index_businesses_on_business_product_id", using: :btree
  end

  create_table "dashboard_periods", force: :cascade do |t|
    t.string   "name"
    t.string   "starts_at"
    t.integer  "cycle"
    t.integer  "cycles_count"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "meta", force: :cascade do |t|
    t.string   "object_class"
    t.integer  "object_id"
    t.jsonb    "datas",        default: {}, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "partner_backlinks", force: :cascade do |t|
    t.integer  "partner_id"
    t.integer  "business_id"
    t.integer  "business_website_id"
    t.integer  "partner_request_id"
    t.integer  "user_id"
    t.string   "referrer"
    t.string   "anchor"
    t.string   "link"
    t.integer  "status"
    t.datetime "activated_at"
    t.datetime "deactivated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["business_id"], name: "index_partner_backlinks_on_business_id", using: :btree
    t.index ["business_website_id"], name: "index_partner_backlinks_on_business_website_id", using: :btree
    t.index ["partner_id"], name: "index_partner_backlinks_on_partner_id", using: :btree
    t.index ["partner_request_id"], name: "index_partner_backlinks_on_partner_request_id", using: :btree
    t.index ["user_id"], name: "index_partner_backlinks_on_user_id", using: :btree
  end

  create_table "partner_requests", force: :cascade do |t|
    t.integer  "partner_id"
    t.integer  "business_id"
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.integer  "channel"
    t.datetime "sent_at"
    t.integer  "state",            default: 0, null: false
    t.datetime "state_updated_at"
    t.integer  "state_updated_by"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["business_id"], name: "index_partner_requests_on_business_id", using: :btree
    t.index ["partner_id"], name: "index_partner_requests_on_partner_id", using: :btree
    t.index ["user_id"], name: "index_partner_requests_on_user_id", using: :btree
  end

  create_table "partners", force: :cascade do |t|
    t.string   "title"
    t.integer  "category"
    t.string   "url"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "webform_url"
    t.integer  "requests_count",  default: 0
    t.integer  "backlinks_count", default: 0
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["user_id"], name: "index_partners_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",               default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.jsonb    "preferences",            default: {}, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "business_websites", "businesses"
  add_foreign_key "businesses", "business_products"
  add_foreign_key "partner_backlinks", "business_websites"
  add_foreign_key "partner_backlinks", "businesses"
  add_foreign_key "partner_backlinks", "partner_requests"
  add_foreign_key "partner_backlinks", "partners"
  add_foreign_key "partner_backlinks", "users"
  add_foreign_key "partner_requests", "businesses"
  add_foreign_key "partner_requests", "partners"
  add_foreign_key "partner_requests", "users"
  add_foreign_key "partner_requests", "users", column: "state_updated_by"
  add_foreign_key "partners", "users"
end
