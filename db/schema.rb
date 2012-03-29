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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120327143138) do

  create_table "noriskmessage", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strategypositionrecord_t", :id => false, :force => true do |t|
    t.string  "rightid",       :limit => 50
    t.string  "tradeobject",   :limit => 50
    t.integer "isclosepos"
    t.date    "openposdate"
    t.date    "closeposdate"
    t.float   "openposprice"
    t.float   "closeposprice"
    t.float   "marginaccount"
    t.float   "profit"
  end

  create_table "strategyreference_t", :id => false, :force => true do |t|
    t.string  "rightid",           :limit => 50
    t.float   "minmarginaccount"
    t.float   "totalnetprofit"
    t.float   "grossprofit"
    t.float   "grossloss"
    t.float   "avemonthreturn"
    t.float   "aveyearreturn"
    t.integer "toaltradingdays"
    t.integer "totaltrades"
    t.float   "avedaytrades"
    t.integer "numwintrades"
    t.integer "numlosstrades"
    t.float   "percentprofitable"
    t.float   "largestwintrade"
    t.float   "largestlosstrade"
    t.float   "avewintrade"
    t.float   "avelosstrade"
    t.float   "avetrade"
    t.float   "expectvalue"
    t.float   "maxdrawdown"
    t.integer "maxdrawdowndays"
  end

  create_table "strategyreturnrate_t", :id => false, :force => true do |t|
    t.string  "rightid",    :limit => 50
    t.integer "yearid"
    t.integer "monthid"
    t.float   "returnrate"
  end

  create_table "strategyweb", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "strategyid"
    t.float    "anreturn"
    t.string   "strategytype"
    t.string   "strategyattr"
    t.date     "startdate"
    t.string   "developer"
  end

  create_table "webuser", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "webuserstrategy", :force => true do |t|
    t.string   "username"
    t.string   "strategyid"
    t.string   "paraname"
    t.float    "paravalue"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
