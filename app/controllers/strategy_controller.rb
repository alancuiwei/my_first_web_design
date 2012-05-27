#encoding: utf-8
require 'rubygems'
class StrategyController < ApplicationController

  def showror
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")
  end

  def shownorisk
    #gettime for ajax refresh
    if params[:gettime]!=nil
    @gettime=Time.now
    puts @gettime
      render :json => @gettime  #render json
    end
    #skip saved redirect back(session)
    session[:login]="shownorisk"
    #webuser
    @webuser = Webuser.find_by_name(session[:webuser_name])
    #db (struct)
    db=Struct.new(:commodityid,:lendrate,:tradecharge,:trademargingap)
    @db=Array.new
    if @webuser==nil
    @defaultusercommodity=UsercommodityT.find_all_by_userid("tester1")
      @dbnum=@defaultusercommodity.size
    for i in 0..@defaultusercommodity.size-1 do
        @db[i]=db.new(@defaultusercommodity[i].commodityid,@defaultusercommodity[i].lendrate,@defaultusercommodity[i].tradecharge,@defaultusercommodity[i].trademargingap)
    end
    else
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
      @dbnum=@usercommodity.size
    for i in 0..@usercommodity.size-1 do
        @db[i]=db.new(@usercommodity[i].commodityid,@usercommodity[i].lendrate,@usercommodity[i].tradecharge,@usercommodity[i].trademargingap)
          end
    end
  end

  def intronorisk
  end

  def personaltrading
    #gettime for ajax refresh
    if params[:gettime_p]!=nil
        @gettime_p=Time.now
        puts @gettime_p
        render :json => @gettime_p
        end
    #skip saved redirect back(session)
    session[:login]="personaltrading"
    #webuser
    @webuser = Webuser.find_by_name(session[:webuser_name])
    #stg010001
    @stg010001 = Stg010001.find_all_by_username(session[:webuser_name])
        if params[:pairname_p]!=nil
      Stg010001.new do |stg|
        stg.username=session[:webuser_name]
            stg.pairname=params[:pairname_p]
            stg.returnrate=params[:returnrate_p].to_f
        stg.time=Time.now.to_s(:db)
            stg.firstprice=params[:firstprice_p]
            stg.secondprice=params[:secondprice_p]
            stg.firstmarginrate=params[:firstmarginrate_p]
            stg.secondmarginrate=params[:secondmarginrate_p]
        stg.save
      end
    end
    #strategyparam
    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")
    #db (struct)
    db=Struct.new(:commodityid,:lendrate,:tradecharge,:trademargingap)
    @db=Array.new
    if @webuser==nil
      @userflag=0
    @defaultusercommodity=UsercommodityT.find_all_by_userid("tester1")
      @dbnum=@defaultusercommodity.size
    for i in 0..@defaultusercommodity.size-1 do
        @db[i]=db.new(@defaultusercommodity[i].commodityid,@defaultusercommodity[i].lendrate,@defaultusercommodity[i].tradecharge,@defaultusercommodity[i].trademargingap)
    end
    else
      @userflag=1
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
      @dbnum=@usercommodity.size
   for i in 0..@usercommodity.size-1 do
        @db[i]=db.new(@usercommodity[i].commodityid,@usercommodity[i].lendrate,@usercommodity[i].tradecharge,@usercommodity[i].trademargingap)
          end
    end

  end

  def maxreturnrate
    @allmaxreturnrate=ArbcostmaxreturnrateV.all
  end

  def userreturnrate
    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")
  
    if  params[:paramvalue]!=nil && params[:paramvalue].to_f > @strategyparam.paramvalue.to_f
      @stg010001s=Stg010001.find_all_by_username(session[:webuser_name])
      for i in 0..@stg010001s.size-1
            @stg010001s[i].destroy
      end
    end

    if  params[:paramvalue]!=nil
    @strategyparam.update_attribute(:paramvalue,params[:paramvalue].to_d/100)
    redirect_to :controller=>"strategy" ,:action=>"showror"
    end
  end
end
