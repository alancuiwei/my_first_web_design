#encoding: utf-8
require 'rubygems'
require 'builder'
require 'rexml/document'
include REXML
class StrategysController < ApplicationController

  def show
    @strat_profit=200000
    @strategyweb = Strategyweb.find(params[:id])
    @traderecord=StrategypositionrecordT.find(:all, :order =>"openposdate DESC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum],:limit => 10)
    if @strategyweb.strategyid.size>6
      @streference = StrategyreferenceT.find_all_by_strategyid_and_userid_and_ordernum_and_rightid(@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid.slice(0,6)+"000000-"+@strategyweb.strategyid.slice(7,6)+"000000")
      else
    @streference = StrategyreferenceT.find_all_by_strategyid_and_userid_and_ordernum_and_rightid(@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000")
   end
   # @strategyreturnrates=StrategyreturnrateT.find_all_by_rightid("010603000000")
   # @returnrate_arr=Array.new
   # if params[:getjson]!=nil
   #   i=0
   #      @strategyreturnrates.each do |stgreturnrate|
   #       str=stgreturnrate.yearid.to_s+"-"+stgreturnrate.monthid.to_s+"-"+get_days(stgreturnrate.yearid,stgreturnrate.monthid).to_s
   #         @returnrate_arr[i]=[DateTime.strptime(str, "%Y-%m-%d").to_i*1000,stgreturnrate.returnrate*100]
   #        i=i+1
   #      end
   # render :json => @returnrate_arr #render json #render json
   # end
   # @s_profits=StrategypositionrecordT.all
    #@hash_profit=Hash.new
    #@profit_arr=Array.new
    #@profits_lastday=StrategypositionrecordT.find(:all, :order =>"closeposdate DESC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum],:limit => 1)[0].closeposdate
    #@profits_first=StrategypositionrecordT.find(:all, :order =>"closeposdate ASC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum],:limit => 1)[0].closeposdate

    #@days=(DateTime.strptime(@profits_lastday.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@profits_first.to_s(:db),"%Y-%m-%d").to_i)/86400

    #for i in 0..@days
    #  @hash_profit.store(1026777600000+i*86400000,0)
    #end

    #  @s_profits.each do |profit|
    #    if @hash_profit[DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000]==0
    #       @hash_profit.store(DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000,profit.profit)
    #    else
    #      @profit_temp=@hash_profit[DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000]+profit.profit
    #      @hash_profit.store(DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000,@profit_temp)
    #   end
    #  end
    #for i in 0..@days
    #  if i==0
    #    @profit_t=0
    #  end
   #   if @hash_profit[1026777600000+i*86400000]!=0
   #     @profit_t=@profit_t+@hash_profit[1026777600000+i*86400000]
   #     @hash_profit.store(1026777600000+i*86400000,@profit_t)
   #     else
    #    @hash_profit.store(1026777600000+i*86400000,@profit_t)
    #    end
    #end

    #for i in 0..@days
    #Profitchart.new do |profit|
    #  profit.dateint=@hash_profit.keys[i]
    #  profit.profit= @hash_profit[@hash_profit.keys[i]]
    #  profit.save
    #end
    #end



    if params[:getprofit]!=nil
      @profits=Profitchart.find_all_by_strategyid_and_userid_and_ordernum(@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum)
    @profit_arr=Array.new
    i=0
      @profits.each do |profit|
       @profit_arr[i]=[profit.dateint,profit.profit+@strat_profit]
      i=i+1
      end

     render :json => @profit_arr #render json #render json
     #@strategyweb = Strategyweb.find_by_name("羽根英树正向套利")
     #@strategyweb.update_attributes(:anreturn=>((@profit_arr[@days][1]-@strat_profit)/@strat_profit))
    end

    #return table
    if @strategyweb.strategyid.size>6
      @returnrate_lastyearnum=StrategyreturnrateT.find(:all, :order =>"yearid DESC,monthid DESC" ,:limit => 1,:conditions =>["strategyid=? and userid=? and ordernum=? and rightid=?",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid.slice(0,6)+"000000-"+@strategyweb.strategyid.slice(7,6)+"000000"])
      @returnrate_lastyear=StrategyreturnrateT.find(:all, :conditions =>["yearid=? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_lastyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid.slice(0,6)+"000000-"+@strategyweb.strategyid.slice(7,6)+"000000"],:order =>"monthid ASC" )
      @returnrate_others=StrategyreturnrateT.find(:all, :conditions =>["yearid<? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_lastyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid.slice(0,6)+"000000-"+@strategyweb.strategyid.slice(7,6)+"000000"],:order =>"yearid DESC,monthid ASC")
      @returnrate_firstyearnum=StrategyreturnrateT.find(:all, :order =>"yearid ASC" ,:limit => 1,:conditions =>["strategyid=? and userid=? and ordernum=? and rightid=?",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid.slice(0,6)+"000000-"+@strategyweb.strategyid.slice(7,6)+"000000"])
    @returnrate_firstyear=StrategyreturnrateT.find(:all, :conditions =>["yearid=? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_firstyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid.slice(0,6)+"000000-"+@strategyweb.strategyid.slice(7,6)+"000000"],:order =>"monthid ASC" )

      else
    @returnrate_lastyearnum=StrategyreturnrateT.find(:all, :order =>"yearid DESC,monthid DESC" ,:limit => 1,:conditions =>["strategyid=? and userid=? and ordernum=? and rightid=?",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"])
    @returnrate_lastyear=StrategyreturnrateT.find(:all, :conditions =>["yearid=? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_lastyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"],:order =>"monthid ASC" )
    @returnrate_others=StrategyreturnrateT.find(:all, :conditions =>["yearid<? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_lastyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"],:order =>"yearid DESC,monthid ASC")

    @returnrate_firstyearnum=StrategyreturnrateT.find(:all, :order =>"yearid ASC" ,:limit => 1,:conditions =>["strategyid=? and userid=? and ordernum=? and rightid=?",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"])
    @returnrate_firstyear=StrategyreturnrateT.find(:all, :conditions =>["yearid=? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_firstyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"],:order =>"monthid ASC" )

    end
    if @returnrate_others.size%12==0
    @returnrate_others_size=@returnrate_others.size/12
    else
      @returnrate_others_size=@returnrate_others.size/12+1
    end


  end



  def intro
    @strategyweb = Strategyweb.find(params[:id])
  end

  def subscribe
    @strategy=Strategyweb.find(params[:id])
  end

  def pay
    @strategy=Strategyweb.find(params[:id])
  end

  def myprocess
    #system 'app/assets/xmls/ZR_PROGRAM_BuiltTestResult.exe'
  end

  def get_days(y,m)
    case m
      when 1,3,5,7,8,10,12
        31
      when 4,6,9,11
        30
      when 2
        if leap_year(y)==1
          29
          else
            28
            end
    end
  end

  def leap_year(year)
  if year%400==0
    else
      if year%100==0
        return 0
        else
          if year%4==0
            return 1
            else
            return 0
          end
        end
      end
    end
end

