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

ActiveRecord::Schema.define(:version => 20120705011055) do

  create_table "arbcostmaxreturnrate_v", :id => false, :force => true do |t|
    t.string   "pairname",    :limit => 20
    t.float    "firstprice"
    t.float    "secondprice"
    t.float    "cost"
    t.float    "returnrate"
    t.datetime "currenttime"
  end

  create_table "noriskmessage", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profitchart", :force => true do |t|
    t.float "dateint"
    t.float "profit"
  end

  create_table "stg010001", :force => true do |t|
    t.string   "username",            :limit => 20
    t.string   "pairname",            :limit => 20
    t.float    "returnrate"
    t.datetime "time"
    t.float    "firstprice"
    t.float    "secondprice"
    t.float    "firstmarginrate"
    t.float    "secondmarginrate"
    t.float    "storageday",                        :default => 1.0
    t.float    "storagedailyfee",                   :default => 1.0
    t.float    "storagefee",                        :default => 1.0
    t.float    "deliverchargebyhand",               :default => 1.0
    t.float    "deliverfee",                        :default => 1.0
    t.float    "tradecharge",                       :default => 1.0
    t.float    "computetransfee",                   :default => 1.0
    t.float    "lendrate",                          :default => 1.0
    t.float    "D1",                                :default => 1.0
    t.float    "tradeunit",                         :default => 1.0
    t.float    "trademarginfee",                    :default => 1.0
    t.float    "delivermarginfee",                  :default => 1.0
    t.float    "vatrate",                           :default => 1.0
    t.float    "vatfee",                            :default => 1.0
  end

  create_table "strategyparam_t", :force => true do |t|
    t.string  "strategyid", :limit => 20
    t.string  "paramname",  :limit => 20
    t.float   "paramvalue"
    t.string  "username",   :limit => 20
    t.integer "ordernum"
    t.integer "userid"
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
    t.string  "strategyid",    :limit => 20
    t.integer "userid"
    t.integer "ordernum"
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
    t.string  "strategyid",        :limit => 20
    t.integer "userid"
    t.integer "ordernum"
  end

  create_table "strategyreturnrate_t", :id => false, :force => true do |t|
    t.string  "rightid",    :limit => 50
    t.integer "yearid"
    t.integer "monthid"
    t.float   "returnrate"
    t.string  "strategyid", :limit => 20
    t.integer "userid"
    t.integer "ordernum"
  end

  create_table "strategyweb", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "strategyid"
    t.float    "anreturn"
    t.string   "strategytype"
    t.string   "strategyattr"
    t.date     "startdate"
    t.string   "developer"
    t.integer  "strategyweb_id"
    t.string   "control"
    t.string   "action"
    t.float    "lastdayfunds"
    t.integer  "userid"
    t.string   "ordernum"
    t.string   "commoditynames"
    t.string   "configtype",     :limit => 45
    t.float    "price"
    t.float    "trydays"
  end

  create_table "subscribetable", :force => true do |t|
    t.string   "subscribeid"
    t.string   "strategyid"
    t.integer  "ordernum"
    t.integer  "strategy_userid"
    t.integer  "subscribe_userid"
    t.float    "price"
    t.float    "subscribedays"
    t.datetime "subscribedate"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "todayinfo_t", :primary_key => "contractid", :force => true do |t|
    t.string "commodityid", :limit => 40
    t.string "exchname",    :limit => 20
    t.float  "margin"
    t.float  "updownlimit"
  end

  create_table "usercommodity_t", :force => true do |t|
    t.float    "tardecharge"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "userstrategy_t", :force => true do |t|
    t.integer  "userid"
    t.string   "strategyname"
    t.string   "strategyid"
    t.string   "objecttype"
    t.string   "commoditynames"
    t.datetime "startdate"
    t.integer  "ordernum"
  end

  create_table "versionstable", :force => true do |t|
    t.string   "rails_comments"
    t.string   "rails_branch_id"
    t.string   "rails_commit_id"
    t.string   "mysql_comments"
    t.string   "mysql_branch_id"
    t.string   "mysql_commit_id"
    t.string   "ctp_comments"
    t.string   "ctp_branch_id"
    t.string   "ctp_commit_id"
    t.datetime "update_date"
    t.string   "current_version_id"
    t.string   "current_comments"
  end

  create_table "webuser", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at"
    t.integer  "level"
    t.datetime "leveldate"
    t.string   "collect"
    t.text     "ctp_account"
    t.text     "ctp_password"
    t.text     "ctp_brokerid"
    t.text     "ctp_frontaddr"
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
