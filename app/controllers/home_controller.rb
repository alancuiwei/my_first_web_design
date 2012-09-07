#encoding: utf-8
class HomeController < ApplicationController
  def index
    @pagetitle="首页"
    @strat_profit=200000
    #UserMailer.forgetpassword("feifan_5223@163.com",1,1).deliver
    @versions=Versionstable.find(:all, :order =>"update_date DESC",:limit => 3)
    @versions_all=Versionstable.find(:all, :order =>"update_date DESC")

    @strategywebs = Strategyweb.find(:all, :order =>"updated_at DESC",:limit => 4)

    @allmaxreturnrate=ArbcostmaxreturnrateT.find(:all, :order =>"returnrate DESC",:limit => 1)

    @hash_reference=Hash.new
    @reference=Array.new
    i=0
    @strategywebs.each do |strategyweb|
      if strategyweb.strategyid.size>6
        @reference[i]= StrategyreferenceT.find_by_strategyid_and_userid_and_ordernum_and_rightid(strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,strategyweb.strategyid.slice(0,6)+"000000-"+strategyweb.strategyid.slice(7,6)+"000000")
      else
      @reference[i]= StrategyreferenceT.find_by_strategyid_and_userid_and_ordernum_and_rightid(strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,strategyweb.strategyid+"000000")
      end
      if @reference[i]!=nil
       @hash_reference.store(strategyweb.strategyid.to_s+strategyweb.userid.to_s+strategyweb.ordernum.to_s,[@reference[i].maxdrawdown,@reference[i].percentprofitable,@reference[i].aveyearreturn])
      else
        @hash_reference.store(strategyweb.strategyid.to_s+strategyweb.userid.to_s+strategyweb.ordernum.to_s,[nil,nil,nil])
      end
      i=i+1
    end
    @hash_reference.store("01000100",["无","无",@allmaxreturnrate[0].returnrate])

    Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'

    @profitchart_arr=Array.new
    @profitchart_arr_day=Array.new
    @profitchart_hash=Hash.new

    @strategywebs.each do |strategyweb|
      profit=Profitchart.find(:all,:conditions =>["strategyid=? and userid=? and ordernum=? and id%30=?",strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,0], :order =>"dateint ASC")
      @test=profit
    if  profit!=nil
      @profitchart_arr=[]
      @profitchart_arr_day=[]

    for i in 0..profit.size-1
    @profitchart_arr[i]=profit[i].profit+@strat_profit
    @profitchart_arr_day[i]=Time.at(profit[i].dateint/1000).to_s(:stamp)
    #DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000
    end
    @profitchart_hash.store(strategyweb.id,[@profitchart_arr,@profitchart_arr_day])
      end
    end

  end

  def comingsoon
  end
end
