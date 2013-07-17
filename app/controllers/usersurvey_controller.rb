#encoding: utf-8
require 'open-uri'
class UsersurveyController < ApplicationController
  def userinfo
    if params[:id]!=nil
       @webuser=Webuser.find_by_id(params[:id])
       if @webuser==nil
         redirect_to(:controller=>"admin", :action=>"index")
       else
         @personalfinance=Personalfinance.find_by_username(@webuser.username)
         if @personalfinance==nil
            @person=1
         end
       end
    else
      redirect_to(:controller=>"admin", :action=>"index")
    end
  end

  def startup
    if session[:webusername]!=nil
      @examination=Examination.find_by_username(session[:webusername])
      @webuser=Webuser.find_by_username(session[:webusername])
    end
  end

  def savescore
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
    @webuser.update_attributes(:score=>params[:score])
    end
    @examination=Examination.find_by_username(params[:username])
    if @examination==nil
      Examination.new do |e|
        e.username=params[:username]
        e.variety=params[:variety]
        e.amount=params[:amount]
        e.pname=params[:pname]
        e.age=params[:age]
        e.salary=params[:salary]
        e.rent=params[:rent]
        e.wages=params[:wages]
        e.xian=params[:xian]
        e.wen=params[:wen]
        e.feng=params[:feng]
        e.xianp=params[:xianp]
        e.wenp=params[:wenp]
        e.fengp=params[:fengp]
        e.save
      end
    else
      @examination.update_attributes(:username=>params[:username],:variety=>params[:variety],
                 :amount=>params[:amount],:pname=>params[:pname],:age=>params[:age],
                 :salary=>params[:salary],:rent=>params[:rent],:wages=>params[:wages],
                 :xian=>params[:xian],:wen=>params[:wen],:feng=>params[:feng],:xianp=>params[:xianp],
                 :wenp=>params[:wenp],:fengp=>params[:fengp])
    end
    render :json => "s".to_json
  end

  def freeapply
    if session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
    else
     @webuser=Webuser.find_by_username("admin")
    end
  end

  def dreamset
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
    end
  end

  def dreamsset
    @webuser = Webuser.find_by_username(params[:username])
   if @webuser!=nil
    @webuser.update_attributes(:dreamset=>params[:dreamset],:selection=>params[:selection])
   end
    render :json => "s".to_json
  end

  def dreamrevise
    @webuser=Webuser.find_by_id(params[:id])
  end

  def dreamconfig
    @webuser=Webuser.find_by_username(params[:username])

    @webuser.update_attributes(:dream=>params[:dream],:province=>params[:province],:city=>params[:city],:organuser=>params[:organuser],:exeitdeposit=>params[:exeitdeposit],
                               :amount=>params[:amount],:realizetime=>params[:realizetime],:monthpay=>params[:monthpay],:scharge=>params[:scharge],:remark=>params[:remark],:isauto=>0)
    render :json => "s".to_json
  end

  def zhifubao
      @webuser = Webuser.find_by_username(session[:webusername])
      Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
      @subsribe_id=Time.now.to_s(:stamp)+'-'+@webuser.username
      if session[:webusername]=='tester'
         @tester='0.01'
      else
         @tester=params[:scharge]
      end
      parameters = {
          'service' => 'create_partner_trade_by_buyer',
          'partner' => '2088801189204575',
          '_input_charset' => 'utf-8',
        'return_url' => 'http://www.tongtianshun.com/personmanagement/investor?username='+params[:username],
          'seller_email' => 'zhongrensoft@gmail.com',
          'out_trade_no' => @subsribe_id,
          'subject' => '梦想实现',
          'price' => @tester,
          'quantity' => '1',
          'payment_type' => '1',
          'logistics_type'=>'EMS',
          'logistics_fee' => '0',
          'logistics_payment'=>'BUYER_PAY',
          'logistics_type_1'=>'POST',
          'logistics_fee_1' => '0',
          'logistics_payment_1'=>'BUYER_PAY',
          'logistics_type_2'=>'EXPRESS',
          'logistics_fee_2' => '0',
          'logistics_payment_2'=>'BUYER_PAY'
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
    render :json => @alipy_url.to_json
  end

  def zhifubaoformobile
      @webuser = Webuser.find_by_username(session[:webusername])
      Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
      @subsribe_id=Time.now.to_s(:stamp)+'-'+@webuser.username
      if session[:webusername]=='tester'
         @tester='0.01'
      else
         @tester=params[:scharge]
      end
      parameters = {
          'service' => 'alipay.wap.trade.create.direct',
          'format' => 'xml',
          'v' => '2.0',
          'partner' => '2088801189204575',
          'req_id' => @subsribe_id,   # ???
          'sec_id' => 'MD5',
       #   'subject' => '梦想实现',
       #   'out_trade_no' => @subsribe_id,
       #   'total_fee' => @tester,
       #   'seller_account_name' => 'zhongrensoft@gmail.com',
       #   'call_back_url' => 'http://www.tongtianshun.com/personmanagement/investor?username='+params[:username],
          'req_data' => '<direct_trade_create_req><subject>梦想实现</subject><out_trade_no>'+@subsribe_id+'</out_trade_no><total_fee>'+@tester+
              '</total_fee><seller_account_name>zhongrensoft@gmail.com</seller_account_name><call_back_url>http://www.tongtianshun.com/personmanagement/investor?username='+params[:username]+
              '</call_back_url></direct_trade_create_req>'
      }

      values = {}
      # 支付宝要求传递的参数必须要按照首字母的顺序传递，所以这里要sort
      parameters.keys.sort.each do |k|
        values[k] = parameters[k];
      end
      # 一定要先unescape后再生成sign，否则支付宝会报ILLEGAL SIGN
      sign = Digest::MD5.hexdigest(CGI.unescape(values.to_query) + 'xf1fj8kltbbc766co0ziulq1wowejpzm')
      gateway = 'http://wappaygw.alipay.com/service/rest.htm?'
      @alipy_url= gateway + values.to_query + '&sign=' + sign

      open(@alipy_url){|x|
        while line = x.gets
          if(line.include?('request_token'))
            @ss=line.split('request_token%3E')[1].split('%3C%2Frequest_token')[0].gsub("%3C%2F",'')
          end
        end
      }
      parameters = {
          'service' => 'alipay.wap.auth.authAndExecute',
          'format' => 'xml',
          'v' => '2.0',
          'partner' => '2088801189204575',
          'sec_id' => 'MD5',
          'req_data' => '<auth_and_execute_req><request_token>'+@ss+'</request_token></auth_and_execute_req>'
      }
      values = {}
      # 支付宝要求传递的参数必须要按照首字母的顺序传递，所以这里要sort
      parameters.keys.sort.each do |k|
        values[k] = parameters[k];
      end
      sign = Digest::MD5.hexdigest(CGI.unescape(values.to_query) + 'xf1fj8kltbbc766co0ziulq1wowejpzm')
      gateway = 'http://wappaygw.alipay.com/service/rest.htm?'
      @alipy_url= gateway + values.to_query + '&sign=' + sign
    render :json => @alipy_url.to_json
  end

  def dreamin
    @webuser = Webuser.find_by_username(params[:username])
    @webuser.update_attributes(:organuser=>0)
    render :json => "s".to_json
  end
end
