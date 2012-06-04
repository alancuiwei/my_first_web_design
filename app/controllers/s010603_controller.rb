#encoding: utf-8
require 'rubygems'
#require 'ctrader'
#require 'iconv'
class S010603Controller < ApplicationController

  def show
    @traderecord=StrategypositionrecordT.find(:all, :order =>"openposdate DESC",:limit => 10)
    @streference = StrategyreferenceT.find_all_by_rightid("010603000000")
    @strategyreturnrates=StrategyreturnrateT.find_all_by_rightid("010603000000")
    @returnrate_arr=Array.new
    i=0
       @strategyreturnrates.each do |stgreturnrate|
         str=stgreturnrate.yearid.to_s+"-"+stgreturnrate.monthid.to_s+"-"+get_days(stgreturnrate.yearid,stgreturnrate.monthid).to_s
          @returnrate_arr[i]=[DateTime.strptime(str, "%Y-%m-%d").to_i*1000,stgreturnrate.returnrate]
         i=i+1
       end
    if params[:getjson]!=nil
      i=0
         @strategyreturnrates.each do |stgreturnrate|
           str=stgreturnrate.yearid.to_s+"-"+stgreturnrate.monthid.to_s+"-"+get_days(stgreturnrate.yearid,stgreturnrate.monthid).to_s
            @returnrate_arr[i]=[DateTime.strptime(str, "%Y-%m-%d").to_i*1000,stgreturnrate.returnrate*100]
           i=i+1
         end
    render :json => @returnrate_arr #render json #render json
    end


  end

  def showall
    @traderecord_all=StrategypositionrecordT.all
  end

  def intro
    @strategy010603=Strategyweb.find_by_name("羽根英树正向套利")
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
