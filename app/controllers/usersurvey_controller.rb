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
      if @userdatamonth==nil
        Userdata_month.new do |e|
          e.username=params[:username]
          e.salary_month=params[:income]
          e.extra_income_month=0
          e.must_expense_month=params[:mustexpense]
          e.fun_expense_month=params[:income]-params[:mustexpense]-params[:investexpense]
          e.invest_expense_month=params[:investexpense]
          e.save
        end
      else
        @userdatamonth.update_attributes(:salary_month=>params[:income],:extra_income_month=>0,:must_expense_month=>params[:mustexpense],:fun_expense_month=>params[:income].to_i-params[:mustexpense].to_i-params[:investexpense].to_i,:invest_expense_month=>params[:investexpense])
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
      @userdatamonth=Userdata_month.find_by_username(params[:username])
      if @userdatamonth==nil
        Userdata_month.new do |e|
          e.username=params[:username]
          e.salary_month=income
          e.extra_income_month=extra
          e.must_expense_month=must_expense
          e.fun_expense_month=fun_expense
          e.invest_expense_month=income+extra-must_expense-fun_expense
          e.save
        end
      else
        @userdatamonth.update_attributes(:salary_month=>income,:extra_income_month=>extra,:must_expense_month=>must_expense,:fun_expense_month=>fun_expense,:invest_expense_month=>income+extra-must_expense-fun_expense)
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

  def detailedmonth
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
    @userdatamonth=Userdata_month.find_by_username(params[:username])
    if @userdatamonth==nil
      Userdata_month.new do |e|
        e.username=params[:username]
        e.salary_month=income
        e.extra_income_month=extra
        e.must_expense_month=must_expense
        e.fun_expense_month=fun_expense
        e.invest_expense_month=income+extra-must_expense-fun_expense
        e.save
      end
    else
      @userdatamonth.update_attributes(:salary_month=>income,:extra_income_month=>extra,:must_expense_month=>must_expense,:fun_expense_month=>fun_expense,:invest_expense_month=>income+extra-must_expense-fun_expense)
    end

    rate=(income+extra-must_expense-fun_expense)*100/income

    if params[:mid]=='1'
      @userdata=Userdata_annual.find_by_username(session[:webusername])
      if @userdata!=nil
        incomes=income*12+@userdata.income_annual
        expenses=@userdata.debt_annual+must_expense*12+fun_expense*12+@userdata.expense_annual
        @userdata.update_attributes(:salary_annual=>income*12,:must_expense_annual=>must_expense*12,:fun_expense_annual=>fun_expense*12,:net_annual=>incomes-expenses)
      end
    end
    t=rate.to_s+','+income.to_s+','+must_expense.to_s+','+(income-must_expense-fun_expense).to_s
    render :json => t.to_json
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
    @detailedmonth=Userdata_detailedincome_month.find_by_username(session[:webusername])
    annual=0
    if @userdata!=nil &&  @userdata.net_annual!=nil
      if @detailedmonth!=nil && @detailedmonth.income3_account!=nil
        annual=@userdata.net_annual+@detailedmonth.income3_account*12
      else
        annual=@userdata.net_annual
      end
    elsif @detailedmonth!=nil && @detailedmonth.income3_account!=nil
      annual=@detailedmonth.income3_account*12
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
      month=@userdatamonth.invest_expense-@userdatamonth.debt_month
      else
        month=@userdatamonth.invest_expense
      end
    end
    @hash.store('length',[@targets.size,annual,month,income])
    render :json => @hash.to_json
  end

  def userdatadetailedannual
    @incomeannual=Userdata_detailedincome_annual.destroy_all(:username => params[:username])
    income=0
    expense=0
     if params[:income_type]!=nil
    @typeid=params[:income_type].split(",")
    @assetvalue=params[:income_value].split(",")
    for i in 0..@typeid.size-1
      Userdata_detailedincome_annual.new do |e|
        e.username=params[:username]
        e.income_type=@typeid[i]
        e.income_value=@assetvalue[i]
        e.save
      end
      income=income+@assetvalue[i].to_i
    end
    end

    @expenseannual=Userdata_detailedexpense_annual.destroy_all(:username => params[:username])
    if params[:expense_type]!=nil
    @expensetype=params[:expense_type].split(",")
    @expensevalue=params[:expense_value].split(",")
    for i in 0..@expensetype.size-1
      Userdata_detailedexpense_annual.new do |e|
        e.username=params[:username]
        e.expense_type=@expensetype[i]
        e.expense_value=@expensevalue[i]
        e.save
      end
      expense=expense+@expensevalue[i].to_i
    end
    end
    @userdata=Userdata_annual.find_by_username(session[:webusername])
    @detailedmonth=Userdata_detailedincome_month.find_all_by_username(session[:webusername])
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    salary_annual=0
    if @detailedmonth!=nil
      for i in 0..@detailedmonth.size-1
         if @detailedmonth[i].income_typeid==1000 || @detailedmonth[i].income_typeid==2000
           salary_annual=salary_annual+@detailedmonth[i].income_value*12
         end
      end
    elsif @userdatamonth!=nil
        a=0;b=0;
        if @userdatamonth.salary_month!=nil
          a=@userdatamonth.salary_month
        end
      if  @userdatamonth.extra_income_month!=nil
         b= @userdatamonth.extra_income_month
      end
        salary_annual=(a+b)*12
    else
       salary_annual=0
    end

    if @userdatamonth!=nil && @userdatamonth.must_expense_month!=nil
      must_expense_annual=@userdatamonth.must_expense_month*12
    else
      must_expense_annual=0
    end
    if @userdatamonth!=nil && @userdatamonth.fun_expense_month!=nil
      fun_expense_annual=@userdatamonth.fun_expense_month*12
    else
      fun_expense_annual=0
    end
    debt_annual=0
    @userdebtsheet=User_debt_sheet.find_all_by_username(session[:webusername])
    if @userdatamonth!=nil && @userdatamonth.debt_month!=nil
      debt_annual=@userdatamonth.debt_month*12
    elsif @userdebtsheet!=nil
      for i in 0..@userdebtsheet.size-1
        if @userdebtsheet[i].debt_value_monthly!=nil
          debt_annual=debt_annual+@userdebtsheet[i].debt_value_monthly*12
        end
      end
    else
      debt_annual=0
    end

    net_annual=salary_annual+income-must_expense_annual-fun_expense_annual-debt_annual-expense

    if @userdata==nil
      Userdata_annual.new do |e|
        e.username=params[:username]
        e.salary_annual=salary_annual
        e.bonus_annual=@assetvalue[0].to_i+@assetvalue[1].to_i
        e.other_income_annual=@assetvalue[2].to_i
        e.must_expense_annual=must_expense_annual
        e.fun_expense_annual=fun_expense_annual
        e.debt_annual=debt_annual
        e.income_annual=income
        e.expense_annual=expense
        e.net_annual=net_annual
        e.save
      end
    else
      @userdata.update_attributes(:salary_annual=>salary_annual,:bonus_annual=>(@assetvalue[0].to_i+@assetvalue[1].to_i),:other_income_annual=>@assetvalue[2].to_i,:must_expense_annual=>must_expense_annual,
                                  :fun_expense_annual=>fun_expense_annual,:debt_annual=>debt_annual,:income_annual=>income,:expense_annual=>expense,:net_annual=>net_annual)
    end
    render :json => "s".to_json
  end

  def moonlite
    @webuser2=Webuser.find_by_username(session[:webusername])
    @webuser2.update_attributes(:moonlite_typeid=>params[:moonlite_typeid])
    render :json => "s".to_json
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
        e.salary_month=params[:salary]
        e.extra_income_month=0
        e.must_expense_month=params[:rent]
        e.fun_expense_month=a1-a2-a3
        e.invest_expense_month=params[:wages]
        e.save
      end
      render :json => "s1".to_json
    else
      @userdatamonth.update_attributes(:salary_month=>params[:salary],:extra_income_month=>0,:must_expense_month=>params[:rent],:fun_expense_month=>a1-a2-a3,:invest_expense_month=>params[:wages])
      render :json => "s2".to_json
    end
  end

  def userassetsheet
    @userassetsheet=User_asset_sheet.destroy_all(:username => params[:username])

    if params[:asset_typeid]!=nil
    @typeid=params[:asset_typeid].split(",")
    @assetvalue=params[:asset_value].split(",")
    a1=0
    a3=0
    a4=0
    a5=0
    for i in 0..@typeid.size-1
      User_asset_sheet.new do |e|
        e.username=params[:username]
        e.asset_typeid=@typeid[i]
        e.asset_value=@assetvalue[i]
        e.save
      end
      a1=a1+@assetvalue[i].to_i
      @assettype=Admin_asset_type.find_by_asset_typeid(@typeid[i]);
      if @assettype!=nil
          if @assettype.asset_type_L1==100
            a3=a3+@assetvalue[i].to_i
          elsif @assettype.asset_type_L1==200
            a4=a4+@assetvalue[i].to_i
          elsif @assettype.asset_type_L1==300
            a5=a5+@assetvalue[i].to_i
          end
      end
    end
    end
    @userbalancesheet=User_balance_sheet.find_by_username(params[:username])
    if @userbalancesheet==nil
      User_balance_sheet.new do |e|
        e.username=params[:username]
        e.asset_account=a1
        e.debt_account=0
        e.net_account=a1
        e.asset_fluid_account=a3
        e.asset_risky_account=a4
        e.asset_safefy_account=a5
        e.save
      end
    else
      a2=@userbalancesheet.debt_account
      @userbalancesheet.update_attributes(:asset_account=>a1,:debt_account=>a2,:net_account=>a1-a2,:asset_fluid_account=>a3,:asset_risky_account=>a4,:asset_safefy_account=>a5)
    end
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    a6=format("%.2f",a3/@userdatamonth.must_expense_month.to_f).to_f
    a7=format("%.2f",a4/a1.to_f).to_f
    a8=format("%.2f",(a3+a5)/a1.to_f).to_f
    a9=a6.to_s+','+a7.to_s+','+a8.to_s
    render :json => a9.to_json
  end

  def step8
    @userbalancesheet=User_balance_sheet.find_by_username(params[:username])
    @userdatamonth=Userdata_month.find_by_username(params[:username])
    a1=0;a2=0;a3=0;a4=0;a5=0;
    if @userbalancesheet!=nil
    a1=@userbalancesheet.asset_fluid_account
    a2=@userbalancesheet.asset_safefy_account
    a3=@userbalancesheet.asset_risky_account
    end
    if @userdatamonth!=nil
      a4=@userdatamonth.must_expense_month
      if @userdatamonth.salary_month!=nil
        a5=a5+@userdatamonth.salary_month
      end
      if @userdatamonth.extra_income_month!=nil
        a5=a5+@userdatamonth.extra_income_month
      end
    end
    render :json => (a1.to_s+','+a2.to_s+','+a3.to_s+','+a4.to_s+','+a5.to_s).to_json
  end

  def step9
    @userdebtsheet=User_debt_sheet.find_all_by_username(session[:webusername])
    a1=0;a2=0;a3=0;a4=0;a5=0;a6=0;
    for i in 0..@userdebtsheet.size-1
      if @userdebtsheet[i].debt_typeid==101
        a1=a1+@userdebtsheet[i].debt_value
        a2=a2+@userdebtsheet[i].debt_value_monthly
      elsif @userdebtsheet[i].debt_typeid==102
        a3=a3+@userdebtsheet[i].debt_value
        a4=a4+@userdebtsheet[i].debt_value_monthly
      elsif @userdebtsheet[i].debt_typeid==199
        a5=a5+@userdebtsheet[i].debt_value
        a6=a6+@userdebtsheet[i].debt_value_monthly
      end
    end
    b1=0;b2=0;b3=0;b4=0;b5=0;b6=0;b7=0;b8=0;b9=0;b10=0;b11=0;b12=0;b13=0;b14=0;b15=0;b16=0;;b17=0;
    @incomemonth=Userdata_detailedincome_month.find_all_by_username(session[:webusername])
    @expensemonth=Userdata_detailedexpense_month.find_all_by_username(session[:webusername])
    if @incomemonth!=nil
      for i in 0..@incomemonth.size-1
        if @incomemonth[i].income_typeid==1000
          b1=@incomemonth[i].income_value
        elsif @incomemonth[i].income_typeid==2000
          b2=@incomemonth[i].income_value
        elsif @incomemonth[i].income_typeid==3000
          b3=@incomemonth[i].income_value
        end
      end
    end
    if @expensemonth!=nil
      for i in 0..@expensemonth.size-1
        @expensetype=Admin_expense_type_month.find_by_expense_id(@expensemonth[i].expense_typeid)
        if @expensemonth[i].expense_typeid==100
          b4=@expensemonth[i].expense_value
          b11=(b1+b2+b3)*@expensetype.expense_expect/100
        elsif @expensemonth[i].expense_typeid==200
          b5=@expensemonth[i].expense_value
          b12=(b1+b2+b3)*@expensetype.expense_expect/100
        elsif @expensemonth[i].expense_typeid==300
          b6=@expensemonth[i].expense_value
          b13=(b1+b2+b3)*@expensetype.expense_expect/100
        elsif @expensemonth[i].expense_typeid==400
          b7=@expensemonth[i].expense_value
          b14=(b1+b2+b3)*@expensetype.expense_expect/100
        elsif @expensemonth[i].expense_typeid==500
          b8=@expensemonth[i].expense_value
          b15=(b1+b2+b3)*@expensetype.expense_expect/100
        elsif @expensemonth[i].expense_typeid==600
          b9=@expensemonth[i].expense_value
          b16=(b1+b2+b3)*@expensetype.expense_expect/100
        elsif @expensemonth[i].expense_typeid==700
          b10=@expensemonth[i].expense_value
          b17=(b1+b2+b3)*@expensetype.expense_expect/100
        end
      end
    end
    c1=0;c2=0;c3=0;c4=0;
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    if @userdatamonth!=nil
    if @userdatamonth.salary_month!=nil
    c1=c1+@userdatamonth.salary_month
   end
    if @userdatamonth.extra_income_month!=nil
    c1=c1+@userdatamonth.extra_income_month
   end
    c2=@userdatamonth.must_expense_month
    c3=@userdatamonth.fun_expense_month
    c4=@userdatamonth.invest_expense_month
    end

    d1=0;d2=0;d3=0;d4=0;d5=0;d6=0;d7=0;
    @incomeannual=Userdata_detailedincome_annual.find_all_by_username(session[:webusername])
    @expenseannual=Userdata_detailedexpense_annual.find_all_by_username(session[:webusername])
    if @incomeannual!=nil
      for i in 0..@incomeannual.size-1
        if @incomeannual[i].income_type==2001
          d1=@incomeannual[i].income_value
        elsif @incomeannual[i].income_type==2002
          d2=@incomeannual[i].income_value
        elsif @incomeannual[i].income_type==2099
          d3=@incomeannual[i].income_value
        end
      end
    end
    if @expenseannual!=nil
      for i in 0..@expenseannual.size-1
        if @expenseannual[i].expense_type==1001
          d4=@expenseannual[i].expense_value
        elsif @expenseannual[i].expense_type==1002
          d5=@expenseannual[i].expense_value
        elsif @expenseannual[i].expense_type==1003
          d6=@expenseannual[i].expense_value
        elsif @expenseannual[i].expense_type==1099
          d7=@expenseannual[i].expense_value
        end
      end
    end

    @userdateannual=Userdata_annual.find_by_username(session[:webusername])
    e1=@userdateannual.salary_annual
    e2=@userdateannual.bonus_annual
    e3=@userdateannual.other_income_annual
    e4=@userdateannual.must_expense_annual
    e5=@userdateannual.fun_expense_annual
    e6=@userdateannual.debt_annual
    e7=@userdateannual.income_annual
    e8=@userdateannual.expense_annual
    e9=@userdateannual.net_annual

    f1=0;f2=0;f3=0;f4=0;f5=0;f6=0;f7=0;f8=0;f9=0;f10=0
    @userassetsheet=User_asset_sheet.find_all_by_username(session[:webusername])
    if @userassetsheet!=nil
      for i in 0..@userassetsheet.size-1
        if @userassetsheet[i].asset_typeid==101
          f1=@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==201
          f2=@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==202
          f3=@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==102
          f4=@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==301
          f5=@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==203
          f6=@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==401
          f7=@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==402
          f8@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==399
          f9=@userassetsheet[i].asset_value
        elsif @userassetsheet[i].asset_typeid==302
          f10=@userassetsheet[i].asset_value
        end
      end
    end

    g1=0;g2=0;g3=0;g4=0;g5=0;g6=0;
    @userbalancesheet=User_balance_sheet.find_by_username(params[:username])
    if @userbalancesheet!=nil
      g1=@userbalancesheet.asset_account
      g2=@userbalancesheet.debt_account
      g3=@userbalancesheet.net_account
      g4=@userbalancesheet.asset_fluid_account
      g5=@userbalancesheet.asset_safefy_account
      g6=@userbalancesheet.asset_risky_account
    end
    h1=0;
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      h1=@webuser.asset_score
    end
    a=[[a1,a2,a3,a4,a5,a6],[b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17],[c1,c2,c3,c4],[d1,d2,d3,d4,d5,d6,d7],[e1,e2,e3,e4,e5,e6,e7,e8,e9],[f1,f2,f3,f4,f5,f6,f7,f8,f9,f10],[g1,g2,g3,g4,g5,g6],[h1]]
    render :json => a.to_json
  end

  def userdebtsheet
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

    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    @userdatamonth.update_attributes(:debt_month=>params[:debt1_account_monthly].to_i+params[:debt2_account_monthly].to_i+params[:debt99_account_monthly].to_i)
    @userdateannual=Userdata_annual.find_by_username(session[:webusername])
    income=@userdateannual.salary_annual+@userdateannual.income_annual
    debt=(params[:debt1_account_monthly].to_i+params[:debt2_account_monthly].to_i+params[:debt99_account_monthly].to_i)*12
    expense=debt+@userdateannual.must_expense_annual+@userdateannual.fun_expense_annual+@userdateannual.expense_annual
    @userdateannual.update_attributes(:debt_annual=>debt,:net_annual=>income-expense)
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
    @blog4=Blog.find_by_id(442)
    @assettype=Admin_asset_type.all
    @assettype1=Admin_asset_type.find_all_by_asset_type_L1(100);
    @assettype2=Admin_asset_type.find_all_by_asset_type_L1(200);
    @assettype3=Admin_asset_type.find_all_by_asset_type_L1(300);
    @assettype4=Admin_asset_type.find_all_by_asset_type_L1(400);
    @debttype=Admin_debt_type.all
    @moonlite=Admin_moonlite_type.all
    @indicators=Admin_finacialindicators.all
    @incomeannual=Admin_income_type_annual.all
    @expenseannual=Admin_expense_type_annual.all
    @expensetype=Admin_expense_type_month.order("expense_id ASC").all
    @hash2={}
    for i in 0..@expensetype.size-1
        @hash2.store(@expensetype[i].expense_id,[@expensetype[i].expense_type])
    end
    @incometype=Admin_income_type_month.all
    if session[:webusername]!=nil
      @userdebtsheet=User_debt_sheet.find_all_by_username(session[:webusername])
      @userassetsheet=User_asset_sheet.find_all_by_username(session[:webusername])
      @examination=Examination.find_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @detailedmonth=Userdata_detailedincome_month.find_all_by_username(session[:webusername])
      @expensemonth=Userdata_detailedexpense_month.find_all_by_username(session[:webusername])
      @userdateannual=Userdata_annual.find_by_username(session[:webusername])
      @detailedannual=Userdata_detailedincome_annual.find_all_by_username(session[:webusername])
      @expenannual=Userdata_detailedexpense_annual.find_all_by_username(session[:webusername])
      @webuser=Webuser.find_by_username(session[:webusername])
      @category=Admin_asset_type_l2.all
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
    @webuser.update_attributes(:asset_score=>params[:asset_score])
    end
    render :json => "s".to_json
  end

  def saveassetscore
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
    @webuser.update_attributes(:asset_score=>params[:asset_score])
    end
    render :json => "s".to_json
  end
  def savescore
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
    @webuser.update_attributes(:asset_score=>params[:asset_score])
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
    @webuser.update_attributes(:asset_score=>params[:asset_score])
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
