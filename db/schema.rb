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

ActiveRecord::Schema.define(version: 20140724211654) do

  create_table "blacklist_urls", force: true do |t|
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "reports", force: true do |t|
    t.string   "name"
    t.string   "site_url"
    t.string   "creator_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urls", force: true do |t|
    t.integer  "report_id"
    t.string   "uri"
    t.integer  "domain_authority"
    t.integer  "page_authority"
    t.integer  "ext_links"
    t.integer  "links"
    t.string   "canonical_url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",           default: "not done"
    t.string   "domain"
    t.string   "public_suffix"
    t.string   "description"
    t.string   "twitter"
    t.string   "http_status"
  end

  create_table "whitelist_urls", force: true do |t|
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
