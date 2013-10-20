#encoding: utf-8
require 'open-uri'
class UsersurveyController < ApplicationController

  def p1_usersurvey
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @blog=Blog.find_by_id(401)
    else
      redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey=>"1")
    end
  end

  def p1s1_user_basic_info
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @blog_age=Blog.find_by_id(490)
      @blog_sex=Blog.find_by_id(491)
      @blog_married=Blog.find_by_id(492)
      @blog_kid=Blog.find_by_id(493)
    else
      redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey=>"1")
    end
  end

  def p1s1_user_basic_info_save
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      @webuser.update_attributes(:age=>params[:age],:sex=>params[:sex],:married=>params[:married],:kids=>params[:kids])
      render :json => "s".to_json
    end
  end

  def p1s2_cash_flow_statement_month
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @incometype=Admin_income_type_month.all
      @expensetype=Admin_expense_type_month.order("expense_id ASC").all
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @incomemonth=Userdata_detailedincome_month.find_all_by_username(session[:webusername])
      @expensemonth=Userdata_detailedexpense_month.find_all_by_username(session[:webusername])
    else
      redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey=>"1")
    end
  end

  def p1s2_cash_flow_statement_month_save_simple
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    fun_expense_month=params[:income].to_i-params[:mustexpense].to_i-params[:investexpense].to_i
    if fun_expense_month<0
      fun_expense_month=0
    end
      if @userdatamonth==nil
        Userdata_month.new do |e|
          e.username=params[:username]
          e.salary_month=params[:income]
          e.extra_income_month=0
          e.must_expense_month=params[:mustexpense]
        e.fun_expense_month=fun_expense_month
          e.invest_expense_month=params[:investexpense]
          e.save
        end
      else
      @userdatamonth.update_attributes(:salary_month=>params[:income],:extra_income_month=>0,:must_expense_month=>params[:mustexpense],:fun_expense_month=>fun_expense_month,:invest_expense_month=>params[:investexpense])
      end
      render :json => "s1".to_json
  end

    def p1s2_cash_flow_statement_month_save_complex
      if params[:income_typeid]!=nil
        @incometypeid=params[:income_typeid].split(",")
        @incomevalue=params[:income_value].split(",")

        for i in 0..@incometypeid.size-1
          @incomemonth=Userdata_detailedincome_month.find_by_username_and_income_typeid(session[:webusername],@incometypeid[i])
          if @incomemonth==nil
            Userdata_detailedincome_month.new do |e|
              e.username=params[:username]
              e.income_typeid=@incometypeid[i]
              e.income_value=@incomevalue[i]
              e.save
            end
          else
            @incomemonth.update_attributes(:income_value=>@incomevalue[i])
          end
        end
        income=@incomevalue[0].to_i+@incomevalue[1].to_i
        extra=@incomevalue[2].to_i

      end
      if params[:expense_typeid]!=nil
        @expensetypeid=params[:expense_typeid].split(",")
        @expensevalue=params[:expense_value].split(",")
        must_expense=0
        fun_expense=0
        for i in 0..@expensetypeid.size-1
          @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(session[:webusername],@expensetypeid[i])
          if @expensemonth==nil
            Userdata_detailedexpense_month.new do |e|
              e.username=params[:username]
              e.expense_typeid=@expensetypeid[i]
              e.expense_value=@expensevalue[i]
              e.save
            end
          else
            @expensemonth.update_attributes(:expense_value=>@expensevalue[i])
          end
          @expensetype=Admin_expense_type_month.find_by_expense_id(@expensetypeid[i].to_i)
          if @expensetype.expense_type=='must_expense'
            must_expense=must_expense+@expensevalue[i].to_i
          else
            fun_expense=fun_expense+@expensevalue[i].to_i
          end
        end
      end
    invest_expense_month=income+extra-must_expense-fun_expense
    if invest_expense_month<0
      invest_expense_month=0
    end
      @userdatamonth=Userdata_month.find_by_username(params[:username])
      if @userdatamonth==nil
        Userdata_month.new do |e|
          e.username=params[:username]
          e.salary_month=income
          e.extra_income_month=extra
          e.must_expense_month=must_expense
          e.fun_expense_month=fun_expense
        e.invest_expense_month=invest_expense_month
          e.save
        end
      else
      @userdatamonth.update_attributes(:salary_month=>income,:extra_income_month=>extra,:must_expense_month=>must_expense,:fun_expense_month=>fun_expense,:invest_expense_month=>invest_expense_month)
      end
      render :json => "s2".to_json
  end

  def p1s3_cash_flow_statement_year
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @incometypeannual=Admin_income_type_annual.all
      @expensetypeannual=Admin_expense_type_annual.all
      @incomeannual=Userdata_detailedincome_annual.find_all_by_username(session[:webusername])
      @expenseannual=Userdata_detailedexpense_annual.find_all_by_username(session[:webusername])
    else
      redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey=>"1")
    end
  end

  def p1s3_cash_flow_statement_year_save
    if params[:income_type]!=nil
      @incometype=params[:income_type].split(",")
      @incomevalue=params[:income_value].split(",")
      for i in 0..@incometype.size-1
        @incomeannual=Userdata_detailedincome_annual.find_by_username_and_income_type(params[:username],@incometype[i])
        if @incomeannual==nil
          Userdata_detailedincome_annual.new do |e|
            e.username=params[:username]
            e.income_type=@incometype[i]
            e.income_value=@incomevalue[i]
            e.save
          end
        else
          @incomeannual.update_attributes(:income_value=>@incomevalue[i])
        end
      end
    end

    if params[:expense_type]!=nil
      @expensetype=params[:expense_type].split(",")
      @expensevalue=params[:expense_value].split(",")
      for i in 0..@expensetype.size-1
        @expenseannual=Userdata_detailedexpense_annual.find_by_username_and_expense_type(params[:username],@expensetype[i])
        if @expenseannual==nil
        Userdata_detailedexpense_annual.new do |e|
          e.username=params[:username]
          e.expense_type=@expensetype[i]
          e.expense_value=@expensevalue[i]
          e.save
        end
        else
          @expenseannual.update_attributes(:expense_value=>@expensevalue[i])
        end
      end
    end
    render :json => "s".to_json
  end

  def p1s4_asset_table
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @assettype=Admin_asset_type.all
      @userassetsheet=User_asset_sheet.find_all_by_username(session[:webusername])
    else
      redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey=>"1")
    end
  end

  def p1s4_asset_table_save
    @userassetsheet=User_asset_sheet.destroy_all(:username => params[:username])

    if params[:asset_typeid]!=nil
      @typeid=params[:asset_typeid].split(",")
      @assetvalue=params[:asset_value].split(",")
      for i in 0..@typeid.size-1
        User_asset_sheet.new do |e|
          e.username=params[:username]
          e.asset_typeid=@typeid[i]
          e.asset_value=@assetvalue[i]
          e.save
        end
      end
    end
    render :json => "s".to_json
  end

  def p1s5_debt_table
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @debttype=Admin_debt_type.all
      @userdebtsheet=User_debt_sheet.find_all_by_username(session[:webusername])
    else
      redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey=>"1")
    end
  end

  def p1s5_debt_table_save
    @userdebtsheet=User_debt_sheet.destroy_all(:username => params[:username])
    if params[:debt_typeid]!=nil
      @debtid=params[:debt_typeid].split(",")
      @debtvalue=params[:debt_value].split(",")
      @debtvaluemonth=params[:debt_value_monthly].split(",")
      @debtyear=params[:debt_years].split(",")
      for i in 0..@debtid.size-1
        User_debt_sheet.new do |e|
          e.username=params[:username]
          e.debt_typeid=@debtid[i]
          e.debt_value=@debtvalue[i]
          e.debt_value_monthly=@debtvaluemonth[i]
          e.debt_years=@debtyear[i]
          e.save
        end
      end
    end
    render :json => 's'.to_json
  end

  def p1_user_survey_report
    if params[:username]!=nil || session[:webusername]!=nil
      if params[:username]!=nil
        @webuser=Webuser.find_by_username(params[:username])
        if @webuser==nil
          redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey_report=>"1")
      end
    else
    @webuser=Webuser.find_by_username(session[:webusername])
    end
      @moonlite=Admin_moonlite_type.all
      @blog=Blog.find_by_id(401)
      @assettype1=Admin_asset_type.find_all_by_asset_type_L1(100);
      @assettype2=Admin_asset_type.find_all_by_asset_type_L1(200);
      @assettype3=Admin_asset_type.find_all_by_asset_type_L1(300);
      @assettype4=Admin_asset_type.find_all_by_asset_type_L1(400);
      @assettype=Admin_asset_type.all
      @expensetype=Admin_expense_type_month.order("expense_id ASC").all
      @hash={}
      must_expense=0
      fun_expense=0
      for i in 0..@expensetype.size-1
        if @expensetype[i].expense_type=="must_expense"
          must_expense=must_expense+@expensetype[i].expense_expect
        else
          fun_expense=fun_expense+@expensetype[i].expense_expect
        end
      end
      @hash.store('must_expense',[must_expense])
      @hash.store('fun_expense',[fun_expense])
      @debttype=Admin_debt_type.all
      @expensetypeannual=Admin_expense_type_annual.all
      @userassetsheet=User_asset_sheet.find_all_by_username(@webuser.username)
      @userdebtsheet=User_debt_sheet.find_all_by_username(@webuser.username)
      @userbalancesheet=User_balance_sheet.find_by_username(@webuser.username)
      @userdatamonth=Userdata_month.find_by_username(@webuser.username)
      @expensemonth=Userdata_detailedexpense_month.find_all_by_username(@webuser.username)
      @userdataannyal=Userdata_annual.find_by_username(@webuser.username)
      @expenseannual=Userdata_detailedexpense_annual.find_all_by_username(@webuser.username)
      @incomemonth=Userdata_detailedincome_month.find_all_by_username(@webuser.username)
      @indicators=Admin_finacialindicators.all
      @financialindicators=User_financial_indicators.find_all_by_username(@webuser.username)
    else
      redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey_report=>"1")
    end
  end

  def save_image
      path = 'app/assets/download'

      File.open("#{Rails.root}/#{path}/"+params[:username]+".png", "wb") { |f|
        f.write Base64.decode64(params[:image].sub!('data:image/png;base64,', ''))
      }
      render :json => 's'.to_json
  end

  def send_image
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      if params[:email]!=@webuser.email
        @webuser.update_attributes(:email=>params[:email])
      end
    end
    Thread.new{
        UserMailer.sendimage(params[:username],params[:email],"家庭财务诊断报告").deliver
    }
    render :json => 's'.to_json
  end

  def goal
    @blog=Blog.find_by_id(452)
   if session[:webusername]!=nil
    @targets=User_targets.find_all_by_username(session[:webusername])
    @webuser=Webuser.find_by_username(session[:webusername])
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
   else
     redirect_to(:controller=>"sales", :action=>"login", :goal=>"1")
   end
  end

  def target1
    @targets=User_targets.find_by_username(params[:username])
    if @targets==nil
      User_targets.new do |e|
        e.username=params[:username]
        e.user_target=params[:target]
        e.user_target_period=params[:target_period]
        e.user_target_value=params[:target_value]
        e.save
      end
      render :json => "s".to_json
    else
      @targets.update_attributes(:user_target=>params[:target],:user_target_period=>params[:target_period],:user_target_value=>params[:target_value])
      render :json => "f".to_json
    end
  end

  def targets
    @targets=User_targets.find_all_by_username(params[:username])
    @hash={}
    for i in 0..@targets.size-1
      if @targets[i].user_target_period<=2
        nature="短期"
      elsif @targets[i].user_target_period<=5
        nature="中期"
      else
        nature="长期"
      end
      @hash.store(i,[@targets[i].user_target,@targets[i].user_target_period,@targets[i].user_target_value,nature])
    end
    @userdata=Userdata_annual.find_by_username(session[:webusername])
    @detailedmonth=Userdata_detailedincome_month.find_by_username_and_income_typeid(session[:webusername],3000)
    annual=0
    if @userdata!=nil &&  @userdata.net_annual!=nil
      if @detailedmonth!=nil
        annual=@userdata.net_annual+@detailedmonth.income_value*12
      else
        annual=@userdata.net_annual
      end
    elsif @detailedmonth!=nil && @detailedmonth.income_value!=nil
      annual=@detailedmonth.income_value*12
    end

    @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
    income=0
    if @userbalancesheet!=nil
      income=@userbalancesheet.asset_fluid_account+@userbalancesheet.asset_safefy_account+@userbalancesheet.asset_risky_account
    end

    month=0
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    if @userdatamonth!=nil
      if @userdatamonth.debt_month!=nil
        month=@userdatamonth.invest_expense_month-@userdatamonth.debt_month
      else
        month=@userdatamonth.invest_expense_month
      end
    end
    @hash.store('length',[@targets.size,annual,month,income])
    render :json => @hash.to_json
  end

  def score
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
    @webuser.update_attributes(:asset_score=>params[:asset_score])
    end
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
end
