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

ActiveRecord::Schema.define(version: 20121203024804) do

  create_table "investrecord", force: true do |t|
    t.string   "username"
    t.datetime "date"
    t.string   "recordtype"
    t.decimal  "recordvalue", precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordernum"
    t.string   "pname"
  end

  create_table "product", force: true do |t|
    t.string   "pname"
    t.text     "description"
    t.float    "lastprofits",   limit: 24
    t.float    "todayprofit",   limit: 24
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "founddate"
    t.string   "dividendtype"
    t.float    "dividendvalue", limit: 24
    t.float    "period",        limit: 24
    t.float    "riskvalue",     limit: 24
    t.text     "descriptions"
  end

  create_table "productrecord", force: true do |t|
    t.string   "pname"
    t.float    "total",       limit: 24
    t.float    "allprofits",  limit: 24
    t.float    "capital",     limit: 24
    t.float    "lastprofits", limit: 24
    t.float    "todayprofit", limit: 24
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "predividend", limit: 24
  end

  create_table "webuser", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "tel"
    t.text     "address"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
