#encoding: utf-8
require 'rubygems'
#require 'ctrader'
#require 'iconv'
class StrategyController < ApplicationController



  def shownorisk
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
      if @webuser.level==99
        @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.leveldate.to_s(:db),"%Y-%m-%d").to_i)/86400
        if @days<=60
          @webuser.level=1
          @trynotice="您是试用用户，还有"+(60-@days).to_s+"天的试用！"
        else
          @webuser.level=0
          @trynotice="该帐号试用期限已满，如果您想继续使用的话，需要缴费，请邮件联系 alan_cuiwei@yahoo.com.cn 或电话 13451936496！"
        end
      end
    end
  end

  def subscribe
    @strategy=Strategyweb.find(params[:id])
  end

  def pay
    @strategy=Strategyweb.find(params[:id])
    parameters = {
      'service' => 'create_direct_pay_by_user',
      'partner' => '2088801189204575',
      'seller_email' => 'zhongrensoft@gmail.com',
      'out_trade_no' => '616002006',
      'subject' => 'hefeng',
      'price' => '0.01',
      'quantity' => '1',
      'payment_type' => '1',
      '_input_charset' => 'utf-8',
      'notify_url' => url_for(:only_path => false, :action => 'notify'),
      'return_url' => url_for(:only_path => false, :action => 'done')
    }

    values = {}
    # 支付宝要求传递的参数必须要按照首字母的顺序传递，所以这里要sort
    parameters.keys.sort.each do |k|
      values[k] = parameters[k];
    end

    # 一定要先unescape后再生成sign，否则支付宝会报ILLEGAL SIGN
    sign = Digest::MD5.hexdigest(CGI.unescape(values.to_query) + 'xf1fj8kltbbc766co0ziulq1wowejpzm')
    gateway = 'https://mapi.alipay.com/gateway.do?'
    redirect_to gateway + values.to_query + '&sign=' + sign + '&sign_type=MD5'
  end

  def notify
    render :text => 'success'
  end

  def done
    if verify_sign
      render :text => 'Payment successful'
    else
      render :text =>'Alipay Error: ILLEGAL_SIGN'
    end
  end

  protected
    def verify_sign
      params.delete(sign_type)
      sign = params.delete(sign)

      values = {}
      params.keys.sort.each do |k|
        values[k] = params[k];
      end

      sign.downcase == Digest::MD5.hexdigest(CGI.unescape(values.to_query) +  'xf1fj8kltbbc766co0ziulq1wowejpzm')
    end
end
