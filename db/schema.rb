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

ActiveRecord::Schema.define(:version => 20120308094736) do

  create_table "arbitragecontractpairs_t", :id => false, :force => true do |t|
    t.string "firstcontractid",  :limit => 10
    t.string "secondcontractid", :limit => 10
    t.string "rightid",          :limit => 20
  end

  create_table "bank_t", :primary_key => "bankid", :force => true do |t|
    t.float "lendrate"
  end

  create_table "commodity_t", :primary_key => "commodityid", :force => true do |t|
    t.string  "orderid",                    :limit => 4
    t.string  "exchangeid",                 :limit => 10
    t.string  "delivermonth",               :limit => 40
    t.integer "tradeunit"
    t.float   "tick"
    t.boolean "issinglemargin"
    t.float   "exchtrademargin"
    t.integer "exchtradechargetype"
    t.float   "exchtradecharge"
    t.float   "todayexitdiscount"
    t.integer "maxhandpertrade"
    t.float   "dailypricelimit"
    t.string  "lasttradeday",               :limit => 6
    t.string  "startdeliverday",            :limit => 6
    t.string  "lastdeliverday",             :limit => 6
    t.float   "exchdeliverchargebyunit"
    t.float   "exchdeliverchargebyhand"
    t.float   "futuretocurrenchargebyunit"
    t.float   "futuretocurrenchargebyhand"
    t.string  "cancelmonth",                :limit => 40
    t.integer "deliverunit"
    t.integer "deliverway"
    t.float   "vatrate"
    t.float   "storagedailyfee"
    t.string  "mastermonth",                :limit => 40
  end

  create_table "commoditydelivermargin_t", :id => false, :force => true do |t|
    t.string  "commodityid",     :limit => 4, :null => false
    t.integer "checkid"
    t.string  "delivercheckday", :limit => 6
    t.float   "delivermargin"
  end

  create_table "commoditypositionmargin_t", :id => false, :force => true do |t|
    t.string  "commodityid",       :limit => 4, :null => false
    t.integer "checkid"
    t.integer "positionthreshold"
    t.float   "positionmargin"
  end

  create_table "commoditypricelimit_t", :id => false, :force => true do |t|
    t.string  "commodityid",        :limit => 4, :null => false
    t.integer "priceuplimiteddays"
    t.float   "exchtrademargin"
    t.float   "dailypricelimit"
  end

  create_table "commodityright_t", :id => false, :force => true do |t|
    t.string  "rightid",             :limit => 50
    t.string  "arbitragetype",       :limit => 20
    t.string  "arbitragesubtype",    :limit => 50
    t.string  "computetype",         :limit => 50
    t.string  "paritype",            :limit => 50
    t.string  "firstcommodityid",    :limit => 4
    t.string  "secondcommodityid",   :limit => 4
    t.integer "firstcommodityunit",                :default => 1
    t.integer "secondcommodityunit",               :default => 1
    t.boolean "isinstrumentsupport"
  end

  create_table "contract_t", :primary_key => "contractid", :force => true do |t|
    t.string  "commodityid",           :limit => 4, :null => false
    t.date    "lasttradedate"
    t.date    "startdeliverdate"
    t.date    "lastdeliverdate"
    t.integer "priceuplimiteddays"
    t.integer "pricedownlimiteddays"
    t.float   "dailypricelimit"
    t.float   "pricelimitmargin"
    t.float   "positionmargin"
    t.float   "delivermargin"
    t.integer "daystolasttradedate"
    t.integer "daystolastdeliverdate"
    t.float   "tradeunit"
    t.float   "todayexitdiscount"
    t.boolean "issinglemargin"
    t.float   "exchtrademargin"
    t.integer "exchtradechargetype"
    t.float   "exchtradecharge"
    t.boolean "ishavespecpositions"
    t.boolean "isvalid"
    t.float   "uplimitprice"
    t.float   "downlimitprice"
  end

  create_table "contractdelivermargin_t", :id => false, :force => true do |t|
    t.string  "contractid",             :limit => 10, :null => false
    t.integer "checkid"
    t.date    "actualdelivercheckdate"
    t.float   "delivermargin"
  end

  create_table "contractpositionmargin_t", :id => false, :force => true do |t|
    t.string  "contractid",        :limit => 10, :null => false
    t.integer "checkid"
    t.integer "positionthreshold"
    t.float   "positionmargin"
  end

  create_table "exchangecalendar_t", :primary_key => "everydate", :force => true do |t|
    t.integer "orderid",   :default => 0
    t.boolean "isworkday", :default => false
    t.integer "weekday"
  end

  create_table "ib_t", :primary_key => "ibid", :force => true do |t|
    t.integer "numofibbranches"
    t.float   "commission"
  end

  create_table "ibbranch_t", :primary_key => "ibbranchid", :force => true do |t|
    t.string "ibid",       :limit => 10, :null => false
    t.float  "commission"
  end

  create_table "ibbranchcommodity_t", :id => false, :force => true do |t|
    t.string  "ibbranchid",                 :limit => 20, :null => false
    t.string  "commodityid",                :limit => 4,  :null => false
    t.float   "trademargingap"
    t.integer "tradechargetype"
    t.float   "tradecharge"
    t.float   "deliverchargebyunit"
    t.float   "deliverchargebyhand"
    t.float   "futuretocurrenchargebyunit"
    t.float   "futuretocurrenchargebyhand"
  end

  create_table "ibcommodity_t", :id => false, :force => true do |t|
    t.string  "ibid",                       :limit => 10, :null => false
    t.string  "commodityid",                :limit => 4
    t.float   "trademargingap"
    t.integer "tradechargetype"
    t.float   "tradecharge"
    t.float   "deliverchargebyunit"
    t.float   "deliverchargebyhand"
    t.float   "futuretocurrenchargebyunit"
    t.float   "futuretocurrenchargebyhand"
  end

  create_table "marketdaydata_t", :id => false, :force => true do |t|
    t.string  "contractid",      :limit => 10
    t.date    "currentdate"
    t.float   "openprice"
    t.float   "highprice"
    t.float   "lowprice"
    t.float   "closeprice"
    t.integer "volume",          :limit => 8
    t.integer "openinterest",    :limit => 8
    t.float   "settlementprice"
    t.integer "errorid"
  end

  create_table "marketmindata_t", :id => false, :force => true do |t|
    t.string  "contractid",      :limit => 10
    t.date    "currentdate"
    t.time    "currenttime"
    t.float   "openprice"
    t.float   "highprice"
    t.float   "lowprice"
    t.float   "closeprice"
    t.integer "volume",          :limit => 8
    t.integer "openinterest",    :limit => 8
    t.float   "settlementprice"
  end

  create_table "marketrealtimedata_t", :id => false, :force => true do |t|
    t.string  "contractid",      :limit => 10
    t.date    "getdate"
    t.time    "gettime"
    t.float   "currentprice"
    t.float   "openprice"
    t.float   "highprice"
    t.float   "lowprice"
    t.float   "closeprice"
    t.integer "volume",          :limit => 8
    t.integer "openinterest",    :limit => 8
    t.float   "settlementprice"
    t.float   "askprice1"
    t.float   "bidprice1"
  end

  create_table "markettodaydata_t", :id => false, :force => true do |t|
    t.string  "contractid",      :limit => 10
    t.date    "getdate"
    t.time    "gettime"
    t.float   "currentprice"
    t.float   "openprice"
    t.float   "highprice"
    t.float   "lowprice"
    t.float   "closeprice"
    t.integer "volume",          :limit => 8
    t.integer "openinterest",    :limit => 8
    t.float   "settlementprice"
    t.float   "askprice1"
    t.float   "bidprice1"
  end

  create_table "rawdailydata_t", :id => false, :force => true do |t|
    t.string  "commodityid",   :limit => 4,  :null => false
    t.string  "contractmonth", :limit => 10, :null => false
    t.date    "currentdate",                 :null => false
    t.float   "openprice"
    t.float   "highprice"
    t.float   "lowprice"
    t.float   "closeprice"
    t.integer "volume",        :limit => 8
    t.integer "openinterest",  :limit => 8
    t.integer "orderid"
  end

  create_table "serialdailydata_t", :id => false, :force => true do |t|
    t.string  "commodityid",   :limit => 4
    t.string  "contractmonth", :limit => 10, :null => false
    t.date    "currentdate",                 :null => false
    t.float   "openprice"
    t.float   "highprice"
    t.float   "lowprice"
    t.float   "closeprice"
    t.integer "volume",        :limit => 8
    t.integer "openinterest",  :limit => 8
    t.float   "pricegap"
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

  create_table "user_t", :primary_key => "userid", :force => true do |t|
    t.string  "ibbranchid", :limit => 20
    t.string  "password",   :limit => 100
    t.integer "usertype"
    t.integer "roleid"
  end

  create_table "usercommodity_t", :id => false, :force => true do |t|
    t.string  "commodityid",                :limit => 4,  :null => false
    t.string  "userid",                     :limit => 20, :null => false
    t.integer "tradechargetype"
    t.float   "tradecharge"
    t.float   "deliverchargebyunit"
    t.float   "deliverchargebyhand"
    t.float   "futuretocurrenchargebyunit"
    t.float   "futuretocurrenchargebyhand"
    t.float   "lendrate"
    t.float   "trademargingap"
  end

  create_table "usercontract_t", :id => false, :force => true do |t|
    t.string  "contractid",         :limit => 10, :null => false
    t.string  "userid",             :limit => 20, :null => false
    t.string  "commodityid",        :limit => 4
    t.boolean "isvalid"
    t.float   "contractmarginrate"
    t.float   "lendrate"
  end

  create_table "userright_t", :id => false, :force => true do |t|
    t.string "userid",      :limit => 20
    t.string "rightid",     :limit => 20
    t.date   "invaliddate"
  end

  create_table "validcommodities_t", :primary_key => "commodityid", :force => true do |t|
  end

  create_table "validcontracts_t", :primary_key => "contractid", :force => true do |t|
  end

  create_table "webuser", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
