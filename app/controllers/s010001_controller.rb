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
      'return_url' => 'http://www.tongtianshun.com/strategy/done/'+@strategy.id.to_s,
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
end
