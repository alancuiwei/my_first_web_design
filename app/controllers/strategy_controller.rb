#encoding: utf-8
require 'rubygems'
class StrategyController < ApplicationController

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
      @subscribe=Subscribetable.find(:all,:conditions =>["subscribe_userid=?",@webuser.id],:order =>"subscribedate DESC",:limit=>1)[0]
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
      @dbnum=@usercommodity.size
    for i in 0..@usercommodity.size-1 do
        @db[i]=db.new(@usercommodity[i].commodityid,@usercommodity[i].lendrate,@usercommodity[i].tradecharge,@usercommodity[i].trademargingap,@usercommodity[i].tradechargetype)
          end
      if @webuser.level==99
        @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.leveldate.to_s(:db),"%Y-%m-%d").to_i)/86400
        if @days<=60
          @webuser.level=1
          @trynotice="您是试用用户，还有"+(60-@days).to_s+"天的试用！"
        else
          @webuser.level=0
          @trynotice="该帐号试用期限已满，如果您想继续使用的话，需要缴费，请邮件联系 alan_cuiwei@yahoo.com.cn 或电话 13451936496！"
        end
      elsif @webuser.level==1
        @sub_days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@subscribe.subscribedate.to_s(:db),"%Y-%m-%d").to_i)/86400
        @trynotice="您是订阅用户，还有"+(@subscribe.subscribedays-@sub_days).to_i.to_s+"天的使用天数！"
      end
    end
  end

  def subscribe
    @strategy=Strategyweb.find(params[:id])
  end

  def pay
    @strategy=Strategyweb.find(params[:id])
  end

  def prealipay
    @strategy=Strategyweb.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
    Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
    @subsribe_id=Time.now.to_s(:stamp)+@webuser.id.to_s

    parameters = {
      'service' => 'create_direct_pay_by_user',
      'partner' => '2088801189204575',
      '_input_charset' => 'utf-8',
      'return_url' => 'http://127.0.0.1:3000/strategy/done/'+@strategy.id.to_s,
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
       @webuser.update_attribute(:level,1)
end
    end
  end

end
