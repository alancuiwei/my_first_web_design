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
    @webuser = Webuser.find_by_name(session[:webuser_name])

    if @webuser!=nil
    Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
    @subscribe=Subscribetable.find(:all,:conditions =>["subscribe_userid=? and strategyid=? and ordernum=? and strategy_userid=?",@webuser.id,@strategy.strategyid,@strategy.ordernum,@strategy.userid],:order =>"subscribedate DESC",:limit=>1)[0]
    if @subscribe==nil
      @days=99
      else
    @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@subscribe.subscribedate.to_s(:db),"%Y-%m-%d").to_i)/86400
    end
    if @days>1
    subsribe_id=Time.now.to_s(:stamp)+@webuser.id.to_s
    if @strategy.price==0
      if Subscribetable.find_by_subscribeid(subsribe_id)==nil
      Subscribetable.new do |s|
        s.subscribeid=subsribe_id
        s.strategyid=@strategy.strategyid
        s.ordernum=@strategy.ordernum
        s.strategy_userid=@strategy.userid
        s.subscribe_userid=@webuser.id
        s.price=@strategy.price
        s.subscribedays=30
        s.subscribedate=Time.now.to_s(:db)
        s.save
   end
        @presub=@webuser.subid
        if @presub==nil
          @webuser.update_attribute(:subid,"")
        end
        if @webuser.subid.index(params[:id].to_s)==nil
        if @presub==nil||@presub==''
          @webuser.update_attribute(:subid,params[:id].to_s)
        else
          @webuser.update_attribute(:subid,@presub+"|"+params[:id].to_s)
        end
        end

        @webuser.update_attribute(:subdate,Time.now.to_s(:db))
      end

    end
    end

      end
  end

  def pay
  # prealipay
    @strategy=Strategyweb.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
    Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
    @subsribe_id=Time.now.to_s(:stamp)+@webuser.id.to_s

    parameters = {
      'service' => 'create_direct_pay_by_user',
      'partner' => '2088801189204575',
      '_input_charset' => 'utf-8',
      'return_url' => 'http://www.tongtianshun.com/strategys/done/'+@strategy.id.to_s,
      'seller_email' => 'zhongrensoft@gmail.com',
      'out_trade_no' => @subsribe_id,
      'subject' => @strategy.name+'订阅',
      'price' => @strategy.price,
      'quantity' => '1',
      'payment_type' => '1',
    }
    values = {}
    # 支付宝要求传递的参数必须要按照首字母的顺序传递，所以这里要sort
    parameters.keys.sort.each do |k|
      values[k] = parameters[k];
    end
    # 一定要先unescape后再生成sign，否则支付宝会报ILLEGAL SIGN
    sign = Digest::MD5.hexdigest(CGI.unescape(values.to_query) + 'xf1fj8kltbbc766co0ziulq1wowejpzm')
    gateway = 'https://mapi.alipay.com/gateway.do?'
    @alipy_url= gateway + values.to_query + '&sign=' + sign + '&sign_type=MD5'
  end

  def done
    @notice="交易失败"
    @webuser = Webuser.find_by_id(params[:out_trade_no].slice(14,2).to_i)
    session[:webuser_name]=@webuser.name
    @strategy=Strategyweb.find(params[:id])
    params.delete("sign_type")
    params.delete("id")
    params.delete("action")
    params.delete("controller")
    sign = params.delete("sign")

      values = {}
      params.keys.sort.each do |k|
        values[k] = params[k];
      end

    if sign.downcase == Digest::MD5.hexdigest(CGI.unescape(values.to_query) +  'xf1fj8kltbbc766co0ziulq1wowejpzm') && params[:trade_status]=='TRADE_SUCCESS'
      @notice="交易成功"
       if Subscribetable.find_by_subscribeid(params[:out_trade_no])==nil
       Subscribetable.new do |s|
         s.subscribeid=params[:out_trade_no]
         s.strategyid=@strategy.strategyid
         s.ordernum=@strategy.ordernum
         s.strategy_userid=@strategy.userid
         s.subscribe_userid=@webuser.id
         s.price=@strategy.price
         s.subscribedays=30
         s.subscribedate=Time.now.to_s(:db)
         s.save
    end

       if @webuser!=nil
         @presub=@webuser.subid
         if @presub==nil
           @webuser.update_attribute(:subid,"")
         end
         if @webuser.subid.index(params[:id].to_s)==nil
         if @presub==nil||@presub==''
           @webuser.update_attribute(:subid,params[:id].to_s)
         else
           @webuser.update_attribute(:subid,@presub+"|"+params[:id].to_s)
         end
         end

         @webuser.update_attribute(:subdate,Time.now.to_s(:db))
       end

end
    end
  end

  def try
    @strategy=Strategyweb.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil
      @pretry=@webuser.tryid
      if @pretry==nil
        @webuser.update_attribute(:tryid,"")
      end
      if @webuser.tryid.index(params[:id].to_s)==nil
      if @pretry==nil||@pretry==''
        @webuser.update_attribute(:tryid,params[:id].to_s)
    else
        @webuser.update_attribute(:tryid,@pretry+"|"+params[:id].to_s)
      end
      end
      if  @webuser.trydate==nil
        @webuser.update_attribute(:trydate,Time.now.to_s(:db))
      #@days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.trydate.to_s(:db),"%Y-%m-%d").to_i)/86400
     # @notice_try="您成功试用"+@strategy.name+"策略!您还有"+(@strategy.trydays-@days).to_i.to_s+"的试用天数！"
     # else
      #  @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.trydate.to_s(:db),"%Y-%m-%d").to_i)/86400
      #if (@strategy.trydays-@days)<=0
     #   @notice_try="您的试用期已过！"
     # else
      #  @notice_try="您正在试用"+@strategy.name+"策略!您还有"+(@strategy.trydays-@days).to_i.to_s+"天的试用天数！"
      #end
        end
    end
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

