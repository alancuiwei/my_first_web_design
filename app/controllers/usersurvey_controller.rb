#encoding: utf-8
require 'open-uri'
class UsersurveyController < ApplicationController

  def moonlite
    @webuser2=Webuser.find_by_username(session[:webusername])
    @webuser2.update_attributes(:moonlite_typeid=>params[:moonlite_typeid])
    render :json => "s".to_json
  end

  def userdatadetailedmonth
    @expensetype=Admin_expense_type_month.all
    @hash1={}
    for i in 0..@expensetype.size-1
      if @expensetype[i].expense_expect!=nil
        @hash1.store(@expensetype[i].expense_id,[@expensetype[i].expense_expect/100,@expensetype[i].expense_type])
      else
        @hash1.store(@expensetype[i].expense_id,[0,nil])
      end
    end
    income=params[:income1].to_i+params[:income2].to_i+params[:income3].to_i
    must_expense=0
    fun_expense=0
    if @hash1[100][1]=='must_expense'
      must_expense=must_expense+params[:expense1].to_i
    elsif  @hash1[100][1]=='fun_expense'
      fun_expense=fun_expense+params[:expense1].to_i
    end
    if @hash1[200][1]=='must_expense'
      must_expense=must_expense+params[:expense2].to_i
    elsif  @hash1[200][1]=='fun_expense'
      fun_expense=fun_expense+params[:expense2].to_i
    end
    if @hash1[300][1]=='must_expense'
      must_expense=must_expense+params[:expense3].to_i
    elsif  @hash1[300][1]=='fun_expense'
      fun_expense=fun_expense+params[:expense3].to_i
    end
    if @hash1[400][1]=='must_expense'
      must_expense=must_expense+params[:expense4].to_i
    elsif  @hash1[400][1]=='fun_expense'
      fun_expense=fun_expense+params[:expense4].to_i
    end
    if @hash1[500][1]=='must_expense'
      must_expense=must_expense+params[:expense5].to_i
    elsif  @hash1[500][1]=='fun_expense'
      fun_expense=fun_expense+params[:expense5].to_i
    end
    if @hash1[600][1]=='must_expense'
      must_expense=must_expense+params[:expense6].to_i
    elsif  @hash1[600][1]=='fun_expense'
      fun_expense=fun_expense+params[:expense6].to_i
    end
    if @hash1[700][1]=='must_expense'
      must_expense=must_expense+params[:expense7].to_i
    elsif  @hash1[700][1]=='fun_expense'
      fun_expense=fun_expense+params[:expense7].to_i
    end
    @userdatamonth=Userdata_month.find_by_username(params[:username])
    if @userdatamonth==nil
      Userdata_month.new do |e|
        e.username=params[:username]
        e.income=income
        e.must_expense=must_expense
        e.fun_expense=fun_expense
        e.invest_expense=income-must_expense-fun_expense
        e.save
      end
    else
      @userdatamonth.update_attributes(:income=>income,:must_expense=>must_expense,:fun_expense=>fun_expense,:invest_expense=>income-must_expense-fun_expense)
    end
    rate=(income-must_expense-fun_expense)*100/income

    @detailedmonth=Userdata_detailed_month.find_by_username(params[:username])
    if @detailedmonth==nil
      Userdata_detailed_month.new do |e|
        e.username=params[:username]
        e.income1_account=params[:income1]
        e.income2_account=params[:income2]
        e.income3_account=params[:income3]
        e.expense1_account=params[:expense1]
        e.expense2_account=params[:expense2]
        e.expense3_account=params[:expense3]
        e.expense4_account=params[:expense4]
        e.expense5_account=params[:expense5]
        e.expense6_account=params[:expense6]
        e.expense7_account=params[:expense7]
        e.expense1_expect_account=income*@hash1[100][0]
        e.expense2_expect_account=income*@hash1[200][0]
        e.expense3_expect_account=income*@hash1[300][0]
        e.expense4_expect_account=income*@hash1[400][0]
        e.expense5_expect_account=income*@hash1[500][0]
        e.expense6_expect_account=income*@hash1[600][0]
        e.expense7_expect_account=income*@hash1[700][0]
        e.save
      end
    else
      @detailedmonth.update_attributes(:income1_account=>params[:income1],:income2_account=>params[:income2],:income3_account=>params[:income3],:expense1_account=>params[:expense1],
                                                :expense2_account=>params[:expense2],:expense3_account=>params[:expense3],:expense4_account=>params[:expense4],:expense5_account=>params[:expense5],
                                                :expense6_account=>params[:expense6],:expense7_account=>params[:expense7],:expense1_expect_account=>income*@hash1[100][0],:expense2_expect_account=>income*@hash1[200][0],
                                                :expense3_expect_account=>income*@hash1[300][0],:expense4_expect_account=>income*@hash1[400][0],:expense5_expect_account=>income*@hash1[500][0],
                                                :expense6_expect_account=>income*@hash1[600][0],:expense7_expect_account=>income*@hash1[700][0])
    end
    render :json => rate.to_json
  end

  def userdatamonth
    @userdatamonth=Userdata_month.find_by_username(params[:username])
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
    if @userdatamonth==nil
      Userdata_month.new do |e|
        e.username=params[:username]
        e.income=params[:salary]
        e.must_expense=params[:rent]
        e.fun_expense=a1-a2-a3
        e.invest_expense=params[:wages]
        e.save
      end
      render :json => "s1".to_json
    else
      @userdatamonth.update_attributes(:income=>params[:salary],:must_expense=>params[:rent],:fun_expense=>a1-a2-a3,:invest_expense=>params[:wages])
      render :json => "s2".to_json
    end
  end

  def userassetsheet
    @userassetsheet=User_asset_sheet.find_by_username(params[:username])
    if @userassetsheet==nil
      User_asset_sheet.new do |e|
        e.username=params[:username]
        e.asset1_account=params[:asset1_account]
        e.asset2_account=params[:asset2_account]
        e.asset3_account=params[:asset3_account]
        e.asset4_account=params[:asset4_account]
        e.asset5_account=params[:asset5_account]
        e.asset6_account=params[:asset6_account]
        e.asset7_account=params[:asset7_account]
        e.asset8_account=params[:asset8_account]
        e.asset9_account=params[:asset9_account]
        e.save
      end
    else
      @userassetsheet.update_attributes(:asset1_account=>params[:asset1_account],:asset2_account=>params[:asset2_account],:asset3_account=>params[:asset3_account],
                                         :asset4_account=>params[:asset4_account],:asset5_account=>params[:asset5_account],:asset6_account=>params[:asset6_account],
                                         :asset7_account=>params[:asset7_account],:asset8_account=>params[:asset8_account],:asset9_account=>params[:asset9_account])
    end
    @userbalancesheet=User_balance_sheet.find_by_username(params[:username])
    a1=params[:asset1_account].to_i+params[:asset2_account].to_i+params[:asset3_account].to_i+params[:asset4_account].to_i+params[:asset5_account].to_i+params[:asset6_account].to_i+params[:asset7_account].to_i+params[:asset8_account].to_i+params[:asset9_account].to_i
    a2=0
    a3=params[:asset1_account].to_i+params[:asset4_account].to_i
    a4=params[:asset5_account].to_i+params[:asset9_account].to_i
    a5=params[:asset2_account].to_i+params[:asset3_account].to_i+params[:asset6_account].to_i
    if @userbalancesheet==nil
      User_balance_sheet.new do |e|
        e.username=params[:username]
        e.asset_account=a1
        e.debt_account=0
        e.net_account=a1-a2
        e.asset_fluid_account=a3
        e.asset_risky_account=a4
        e.asset_safefy_account=a5
        e.save
      end
    else
      @userbalancesheet.update_attributes(:asset_account=>a1,:debt_account=>a2,:net_account=>a1-a2,:asset_fluid_account=>a3,:asset_risky_account=>a4,:asset_safefy_account=>a5)
    end
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    a6=format("%.2f",a3/@userdatamonth.must_expense.to_f).to_f
    a7=format("%.2f",a4/a1.to_f).to_f
    a8=format("%.2f",a5/a1.to_f).to_f
    a9=a6.to_s+','+a7.to_s+','+a8.to_s
    render :json => a9.to_json
  end

  def userdebtsheet
    @userdebtsheet=User_debt_sheet.find_by_username(params[:username])
    if @userdebtsheet==nil
      User_debt_sheet.new do |e|
        e.username=params[:username]
        e.debt1_account_totally=params[:debt1_account_totally]
        e.debt1_account_monthly=params[:debt1_account_monthly]
        e.debt1_years=params[:debt1_years]
        e.debt2_account_totally=params[:debt2_account_totally]
        e.debt2_account_monthly=params[:debt2_account_monthly]
        e.debt2_years=params[:debt2_years]
        e.debt99_account_totally=params[:debt99_account_totally]
        e.debt99_account_monthly=params[:debt99_account_monthly]
        e.debt99_years=params[:debt99_years]
        e.save
      end
    else
      @userdebtsheet.update_attributes(:debt1_account_totally=>params[:debt1_account_totally],:debt1_account_monthly=>params[:debt1_account_monthly],:debt1_years=>params[:debt1_years],
                                         :debt2_account_totally=>params[:debt2_account_totally],:debt2_account_monthly=>params[:debt2_account_monthly],:debt2_years=>params[:debt2_years],
                                         :debt99_account_totally=>params[:debt99_account_totally],:debt99_account_monthly=>params[:debt99_account_monthly],:debt99_years=>params[:debt99_years])
    end
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    @userdatamonth.update_attributes(:debt_month=>params[:debt1_account_monthly].to_i+params[:debt2_account_monthly].to_i+params[:debt99_account_monthly].to_i)
    @userbalancesheet=User_balance_sheet.find_by_username(params[:username])
    a1=params[:debt1_account_totally].to_i+params[:debt2_account_totally].to_i+params[:debt99_account_totally].to_i
    a2=@userbalancesheet.asset_account.to_i-a1
    a3=a1/@userbalancesheet.asset_account.to_f
    @userbalancesheet.update_attributes(:debt_account=>a1,:net_account=>a2)
    render :json => a3.to_json
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
    @assettype=Admin_asset_type.all
    @debttype=Admin_debt_type.all
    @moonlite=Admin_moonlite_type.all
    @indicators=Admin_finacialindicators.all
    @expensetype=Admin_expense_type_month.order("expense_id ASC").all
    @hash2={}
    for i in 0..@expensetype.size-1
        @hash2.store(@expensetype[i].expense_id,[@expensetype[i].expense_type])
    end
    @incometype=Admin_income_type_month.all
    if session[:webusername]!=nil
      @userdebtsheet=User_debt_sheet.find_by_username(session[:webusername])
      @userassetsheet=User_asset_sheet.find_by_username(session[:webusername])
      @examination=Examination.find_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @detailedmonth=Userdata_detailed_month.find_by_username(session[:webusername])
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
        e.save
      end
      render :json => "s1".to_json
    else
      @examination.update_attributes(:username=>params[:username],:variety=>params[:variety],
                 :amount=>params[:amount],:pname=>params[:pname],:age=>params[:age],:arr=>params[:arr],
                 :salary=>params[:salary],:rent=>params[:rent],:wages=>params[:wages],
                 :meals=>params[:meals],:fare=>params[:fare],:shop=>params[:shop],:taste=>params[:taste],
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
