#encoding: utf-8
require 'rubygems'
class StrategyController < ApplicationController

  def showror
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")
  end

  def shownorisk
    if params[:gettime]!=nil
    @gettime=Time.now
    puts @gettime
    render :json => @gettime
    end
    session[:login]="shownorisk"
    @stg010001 = Stg010001.find_all_by_username(session[:webuser_name])
    if params[:pairname]!=nil
      Stg010001.new do |stg|
        stg.username=session[:webuser_name]
        stg.pairname=params[:pairname]
        stg.returnrate=params[:returnrate].to_f
        stg.time=Time.now.to_s(:db)
        stg.save
      end
    end
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")
    @defaultusercommodity=UsercommodityT.find_all_by_userid("tester1")
    #default from db
    defaultdb=Struct.new(:commodityid,:lendrate,:tradecharge,:trademargingap)
    @defaultdb=Array.new
    for i in 0..@defaultusercommodity.size-1 do
      @defaultdb[i]=defaultdb.new(@defaultusercommodity[i].commodityid,@defaultusercommodity[i].lendrate,@defaultusercommodity[i].tradecharge,@defaultusercommodity[i].trademargingap)
    end
    @db_num=@defaultusercommodity.size
    #login flag
    @userflag=0
    #for default 初始化
    #just for chargetrade edit
    userchange=Struct.new(:commodityid,:tradecharge)
    @userchange=Array.new
    @tradechargechange_num=0
    #user from db
    userdb=Struct.new(:commodityid,:lendrate,:trademargingap)
    @userdb=Array.new
    if @webuser!=nil
      #login
      @userflag=1
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
    user_tradecharge=Array.new
    #重组数组
      #change tradecharge commodityid
    useredit_commodityid=Array.new
      #get all form db
   for i in 0..@usercommodity.size-1 do
      user_tradecharge[i]=@usercommodity[i].tradecharge
     @userdb[i]=userdb.new(@usercommodity[i].commodityid,@usercommodity[i].lendrate,@usercommodity[i].trademargingap)
   end
    for i in 0..@usercommodity.size-1 do
      useredit_commodityid[i]=-1
        if( user_tradecharge[i]!=@defaultdb[i].tradecharge)
          useredit_commodityid[i]=@userdb[i].commodityid
          end
    end
    j=0
    for i in 0..@usercommodity.size-1 do
          if(useredit_commodityid[i]!=-1)
        @userchange[j]=userchange.new(useredit_commodityid[i],user_tradecharge[i])
            j=j+1
          end
    end
      @tradechargechange_num=j
    end #end if
  end

  def intronorisk
  end

  def personaltrading
    session[:login]="personaltrading"
    @webuser = Webuser.find_by_name(session[:webuser_name])
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
