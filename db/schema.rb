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

ActiveRecord::Schema.define(version: 20161006132341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.integer  "business_website_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
    t.index ["business_website_id", "name"], name: "index_ahoy_events_on_business_website_id_and_name", using: :btree
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  end

  create_table "blog_contents", force: :cascade do |t|
    t.integer  "business_website_id"
    t.integer  "owner_id"
    t.integer  "editor_id"
    t.integer  "writer_id"
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.integer  "status"
    t.datetime "published_at"
    t.integer  "comments_count",      default: 0
    t.string   "featured_image_id"
    t.integer  "categories_count",    default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "type"
    t.integer  "optimizer_id"
    t.integer  "anchors_count",       default: 0
    t.index ["business_website_id"], name: "index_blog_contents_on_business_website_id", using: :btree
    t.index ["slug"], name: "index_blog_contents_on_slug", using: :btree
    t.index ["type"], name: "index_blog_contents_on_type", using: :btree
  end

  create_table "blog_contents_taxonomies", id: false, force: :cascade do |t|
    t.integer "blog_taxonomy_id", null: false
    t.integer "blog_content_id",  null: false
    t.index ["blog_content_id"], name: "index_blog_contents_taxonomies_on_blog_content_id", using: :btree
    t.index ["blog_taxonomy_id", "blog_content_id"], name: "index_blog_contents_taxonomies_on_content_id_and_taxonomy_id", unique: true, using: :btree
  end

  create_table "blog_taxonomies", force: :cascade do |t|
    t.integer  "business_website_id"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "slug"
    t.integer  "posts_count",         default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "type"
    t.index ["business_website_id"], name: "index_blog_taxonomies_on_business_website_id", using: :btree
    t.index ["type"], name: "index_blog_taxonomies_on_type", using: :btree
  end

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

  create_table "business_languages", force: :cascade do |t|
    t.string   "name"
    t.string   "isocode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_products", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_websites", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "platform",                     null: false
    t.string   "url",                          null: false
    t.integer  "backlinks_count",  default: 0
    t.integer  "posts_count",      default: 0
    t.integer  "categories_count", default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "tags_count",       default: 0
    t.integer  "pages_count",      default: 0
    t.index ["business_id"], name: "index_business_websites_on_business_id", using: :btree
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name",                             null: false
    t.integer  "business_product_id"
    t.integer  "business_language_id",             null: false
    t.integer  "websites_count",       default: 0
    t.integer  "backlinks_count",      default: 0
    t.integer  "requests_count",       default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
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

  create_table "histories", force: :cascade do |t|
    t.string   "archivable_type",               null: false
    t.integer  "archivable_id",                 null: false
    t.integer  "person_id"
    t.datetime "valid_from",                    null: false
    t.datetime "valid_to",                      null: false
    t.integer  "lock_version",     default: 0,  null: false
    t.jsonb    "datas",            default: {}, null: false
    t.integer  "history_event_id"
    t.index ["archivable_type", "archivable_id"], name: "index_histories_on_archivable_type_and_archivable_id", using: :btree
    t.index ["history_event_id"], name: "index_histories_on_history_event_id", using: :btree
    t.index ["person_id"], name: "index_histories_on_person_id", using: :btree
  end

  create_table "history_events", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.jsonb    "datas"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "meta", force: :cascade do |t|
    t.string   "metaable_type"
    t.integer  "metaable_id"
    t.jsonb    "datas",         default: {}, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["metaable_type", "metaable_id"], name: "index_meta_on_metaable_type_and_metaable_id", unique: true, using: :btree
  end

  create_table "partner_backlinks", force: :cascade do |t|
    t.integer  "partner_id"
    t.integer  "business_id"
    t.integer  "business_website_id"
    t.integer  "partner_request_id"
    t.integer  "owner_id"
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
  end

  create_table "partner_requests", force: :cascade do |t|
    t.integer  "partner_id"
    t.integer  "business_id"
    t.integer  "owner_id"
    t.string   "subject"
    t.text     "body"
    t.integer  "channel"
    t.datetime "sent_at"
    t.integer  "state",            default: 0, null: false
    t.datetime "state_updated_at"
    t.integer  "state_updated_by"
    t.integer  "backlinks_count",  default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["business_id"], name: "index_partner_requests_on_business_id", using: :btree
    t.index ["partner_id"], name: "index_partner_requests_on_partner_id", using: :btree
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
    t.integer  "owner_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "type"
    t.string   "username",               default: "", null: false
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.jsonb    "preferences",            default: {}, null: false
    t.jsonb    "meta",                   default: {}, null: false
    t.integer  "posts_count",            default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "pages_count",            default: 0
    t.integer  "edited_posts_count",     default: 0
    t.integer  "written_posts_count",    default: 0
    t.integer  "optimized_posts_count",  default: 0
    t.string   "profile_image_id"
    t.index ["email"], name: "index_people_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_people_on_username", unique: true, using: :btree
  end

  create_table "seo_anchors", force: :cascade do |t|
    t.string   "text"
    t.integer  "seo_link_id"
    t.integer  "blog_content_id"
    t.string   "image_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["blog_content_id"], name: "index_seo_anchors_on_blog_content_id", using: :btree
    t.index ["seo_link_id"], name: "index_seo_anchors_on_seo_link_id", using: :btree
  end

  create_table "seo_domains", force: :cascade do |t|
    t.string   "url"
    t.integer  "category",      default: 0, null: false
    t.integer  "links_count",   default: 0, null: false
    t.integer  "anchors_count", default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "seo_links", force: :cascade do |t|
    t.string   "url"
    t.integer  "seo_domain_id"
    t.integer  "level",         default: 2, null: false
    t.integer  "anchors_count", default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["seo_domain_id"], name: "index_seo_links_on_seo_domain_id", using: :btree
  end

  create_table "seo_stop_words", force: :cascade do |t|
    t.string   "excludable_type"
    t.integer  "excludable_id"
    t.string   "word"
    t.string   "source"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["excludable_type", "excludable_id", "word"], name: "index_seo_stop_words_on_excludable_and_word", unique: true, using: :btree
  end

  create_table "seo_words", force: :cascade do |t|
    t.string   "word_countable_type"
    t.integer  "word_countable_id"
    t.string   "word"
    t.integer  "frequency"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["word_countable_type", "word_countable_id", "word"], name: "index_seo_words_on_word_countable_and_word", unique: true, using: :btree
    t.index ["word_countable_type", "word_countable_id"], name: "index_seo_words_on_word_countable", using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.integer  "business_website_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["business_website_id"], name: "index_visits_on_business_website_id", using: :btree
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  end

  add_foreign_key "blog_contents", "business_websites"
  add_foreign_key "blog_contents", "people", column: "editor_id"
  add_foreign_key "blog_contents", "people", column: "owner_id"
  add_foreign_key "blog_contents", "people", column: "writer_id"
  add_foreign_key "blog_taxonomies", "blog_taxonomies", column: "parent_id"
  add_foreign_key "blog_taxonomies", "business_websites"
  add_foreign_key "business_websites", "businesses"
  add_foreign_key "businesses", "business_products"
  add_foreign_key "histories", "history_events"
  add_foreign_key "histories", "people"
  add_foreign_key "partner_backlinks", "business_websites"
  add_foreign_key "partner_backlinks", "businesses"
  add_foreign_key "partner_backlinks", "partner_requests"
  add_foreign_key "partner_backlinks", "partners"
  add_foreign_key "partner_backlinks", "people", column: "owner_id"
  add_foreign_key "partner_requests", "businesses"
  add_foreign_key "partner_requests", "partners"
  add_foreign_key "partner_requests", "people", column: "owner_id"
  add_foreign_key "partner_requests", "people", column: "state_updated_by"
  add_foreign_key "partners", "people", column: "owner_id"
  add_foreign_key "seo_anchors", "blog_contents"
  add_foreign_key "seo_anchors", "seo_links"
  add_foreign_key "seo_links", "seo_domains"
end
