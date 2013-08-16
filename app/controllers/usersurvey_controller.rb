#encoding: utf-8
require 'open-uri'
class UsersurveyController < ApplicationController

  def userexpensemonth
    @userexpensemonth=User_expense_month.find_by_username(params[:username])
    if params[:salary]==""
      a1=0;
    else
      a1=params[:salary].to_i
    end
    if params[:rent]==""
      a2=0;
    else
      a2=params[:rent].to_i
    end
    if params[:wages]==""
      a3=0;
    else
      a3=params[:wages].to_i
    end
    if @userexpensemonth==nil
      User_expense_month.new do |e|
        e.username=params[:username]
        e.income=params[:salary]
        e.must_expense=params[:rent]
        e.fun_expense=params[:wages]
        e.invest_expense=a1-a2-a3
        e.save
      end
      render :json => "s1".to_json
    else
      @userexpensemonth.update_attributes(:income=>params[:salary],:must_expense=>params[:rent],:fun_expense=>params[:wages],:invest_expense=>a1-a2-a3)
      render :json => "s2".to_json
    end
  end

  def measure
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
    else
      redirect_to(:controller=>"sales", :action=>"login", :start=>"1")
    end
  end

  def startup
    @blog=Blog.find_by_id(401)
    @blog2=Blog.find_by_id(111)
    @blog3=Blog.find_by_id(403)
    if session[:webusername]!=nil
      @examination=Examination.find_by_username(session[:webusername])
      @userexpensemonth=User_expense_month.find_by_username(session[:webusername])
      @webuser=Webuser.find_by_username(session[:webusername])
      @category=Category_2.all
      @hash={}
      for i in 0..@category.size-1
        if @category[i].averagerate!=nil && @category[i].averagerate!=''
          @hash.store(@category[i].classify,[@category[i].averagerate])
        else
          @hash.store(@category[i].classify,[0])
        end
      end
      @record=Record.find_all_by_username(@webuser.username)
    else
      redirect_to(:controller=>"sales", :action=>"login", :start=>"1")
    end
  end

  def score
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
    @webuser.update_attributes(:score=>params[:score])
    end
    render :json => "s".to_json
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
        e.arr=params[:arr]
        e.acta=params[:acta]
        e.level=params[:level]
        e.debttype=params[:debttype]
        e.loan=params[:loan]
        e.repayment=params[:repayment]
        e.period=params[:period]
        e.save
      end
      render :json => "s1".to_json
    else
      @examination.update_attributes(:username=>params[:username],:variety=>params[:variety],
                 :amount=>params[:amount],:pname=>params[:pname],:age=>params[:age],:arr=>params[:arr],
                 :salary=>params[:salary],:rent=>params[:rent],:wages=>params[:wages],
                 :debttype=>params[:debttype],:loan=>params[:loan],:repayment=>params[:repayment],:period=>params[:period],
                 :xian=>params[:xian],:wen=>params[:wen],:feng=>params[:feng],:acta=>params[:acta],:level=>params[:level])
      if params[:xianp]!="" &&  params[:xianp]!=nil
        @examination.update_attributes(:xianp=>params[:xianp],
                 :wenp=>params[:wenp],:fengp=>params[:fengp])
      end
      render :json => "s2".to_json
    end
  end

  def savescore2
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
        e.arr=params[:arr]
        e.acta=params[:acta]
        e.level=params[:level]
        e.meals=params[:meals]
        e.fare=params[:fare]
        e.shop=params[:shop]
        e.taste=params[:taste]
        e.education=params[:education]
        e.family=params[:family]
        e.intercourse=params[:intercourse]
        e.income1=params[:income1]
        e.income2=params[:income2]
        e.income3=params[:income3]
        e.income4=params[:income4]
        e.income5=params[:income5]
        e.income6=params[:income6]
        e.income7=params[:income7]
        e.income8=params[:income8]
        e.income9=params[:income9]
        e.income10=params[:income10]
        e.income11=params[:income11]
        e.income12=params[:income12]
        e.debttype=params[:debttype]
        e.loan=params[:loan]
        e.repayment=params[:repayment]
        e.period=params[:period]
        e.save
      end
      render :json => "s1".to_json
    else
      @examination.update_attributes(:username=>params[:username],:variety=>params[:variety],
                 :amount=>params[:amount],:pname=>params[:pname],:age=>params[:age],:arr=>params[:arr],
                 :salary=>params[:salary],:rent=>params[:rent],:wages=>params[:wages],
                 :meals=>params[:meals],:fare=>params[:fare],:shop=>params[:shop],:taste=>params[:taste],
                 :debttype=>params[:debttype],:loan=>params[:loan],:repayment=>params[:repayment],:period=>params[:period],
                 :education=>params[:education],:family=>params[:family],:intercourse=>params[:intercourse],:income1=>params[:income1],
                 :income2=>params[:income2],:income3=>params[:income3],:income4=>params[:income4],:income5=>params[:income5],
                 :income6=>params[:income6],:income7=>params[:income7],:income8=>params[:income8],:income9=>params[:income9],
                 :income10=>params[:income10],:income11=>params[:income11],:income12=>params[:income12],
                 :xian=>params[:xian],:wen=>params[:wen],:feng=>params[:feng],:acta=>params[:acta],:level=>params[:level])
      if params[:xianp]!="" &&  params[:xianp]!=nil
        @examination.update_attributes(:xianp=>params[:xianp],
                 :wenp=>params[:wenp],:fengp=>params[:fengp])
      end
      render :json => "s2".to_json
    end
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
end
