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

ActiveRecord::Schema.define(version: 20140907043304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "articles", force: true do |t|
    t.string   "title"
    t.string   "article_url"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keywords",    array: true
    t.tsvector "tsv_title"
  end

  add_index "articles", ["site_id"], name: "index_articles_on_site_id", using: :btree
  add_index "articles", ["tsv_title"], name: "index_articles_tsv_title", using: :gin

  create_table "links", force: true do |t|
    t.string   "url"
    t.boolean  "visited",    default: false
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "scanned",    default: false
  end

  add_index "links", ["site_id"], name: "index_links_on_site_id", using: :btree

  create_table "schedulers", force: true do |t|
    t.integer  "schedule"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedulers", ["site_id"], name: "index_schedulers_on_site_id", using: :btree

  create_table "scores", force: true do |t|
    t.integer  "alexa",      default: 1, null: false
    t.integer  "google",     default: 1, null: false
    t.integer  "moz",        default: 1, null: false
    t.integer  "articles",   default: 1, null: false
    t.integer  "reviews",    default: 1, null: false
    t.integer  "books",      default: 1, null: false
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["site_id"], name: "index_scores_on_site_id", using: :btree

  create_table "sites", force: true do |t|
    t.string   "name"
    t.string   "site_url"
    t.string   "feed"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "confidence",  default: 0
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
