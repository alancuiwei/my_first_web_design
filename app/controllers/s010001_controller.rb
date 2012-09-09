#encoding: utf-8
require 'rubygems'
class S010001Controller < ApplicationController
  def shownorisk
    session[:login]="shownorisk"
    @allmaxreturnrate=ArbcostmaxreturnrateV.all
    @strategy_norisk=Strategyweb.find_by_strategyid_and_name("010001","无风险套利")
    #gettime for ajax refresh
    if params[:gettime]!=nil
    @gettime=Time.now
    puts @gettime
      render :json => @gettime  #render json
    end
    #webuser
    @webuser = Webuser.find_by_name(session[:webuser_name])
    #db (struct)
    db=Struct.new(:commodityid,:lendrate,:tradecharge,:trademargingap,:tradechargetype)
    @db=Array.new
    if @webuser==nil
    @defaultusercommodity=UsercommodityT.find_all_by_userid("tester1")
      @dbnum=@defaultusercommodity.size
    for i in 0..@defaultusercommodity.size-1 do
        @db[i]=db.new(@defaultusercommodity[i].commodityid,@defaultusercommodity[i].lendrate,@defaultusercommodity[i].tradecharge,@defaultusercommodity[i].trademargingap,@defaultusercommodity[i].tradechargetype)
    end
    else
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
      @dbnum=@usercommodity.size
    for i in 0..@usercommodity.size-1 do
        @db[i]=db.new(@usercommodity[i].commodityid,@usercommodity[i].lendrate,@usercommodity[i].tradecharge,@usercommodity[i].trademargingap,@usercommodity[i].tradechargetype)
          end
      #try and subscribe
      if @webuser.tryid!=nil
        @tryid=@webuser.tryid.scan(/\d/)
       if @tryid!=nil
         @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.trydate.to_s(:db),"%Y-%m-%d").to_i)/86400
         for i in 0..@tryid.size-1
           if @tryid[i]!=nil&&@strategy_norisk.id.to_s==@tryid[i]
             @norisk_istry=1
             if(@strategy_norisk.trydays-@days)>0
             @norisk_havetry=(@strategy_norisk.trydays-@days)
        else
               @norisk_havetry=-1
        end
        else
             break
           end
         end
       end
      end
      if @webuser.subid!=nil
        @subid=@webuser.subid.scan(/\d/)
       if @subid!=nil
         @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.subdate.to_s(:db),"%Y-%m-%d").to_i)/86400
         for i in 0..@subid.size-1
           if @subid[i]!=nil&&@strategy_norisk.id.to_s==@subid[i]
             @norisk_issub=1
             @subscribe=Subscribetable.find(:all,:conditions =>["subscribe_userid=? and strategyid=? and ordernum=? and strategy_userid=?",@webuser.id,@strategy_norisk.strategyid,@strategy_norisk.ordernum,@strategy_norisk.userid],:order =>"subscribedate DESC",:limit=>1)[0]
             if (@subscribe.subscribedays-@days)>0
              @norisk_havesub=(@subscribe.subscribedays-@days)
             else
               @norisk_havesub=-1
             end
           else
             break
           end
         end
          end
      end
    end
  end

end
