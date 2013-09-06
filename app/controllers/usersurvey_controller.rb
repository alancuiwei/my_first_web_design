#encoding: utf-8
require 'open-uri'
class UsersurveyController < ApplicationController

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
    @targets=User_targets.find_by_username_and_user_target(params[:username],params[:target])
    if @targets==nil
      User_targets.new do |e|
        e.username=params[:username]
        e.user_target=params[:target]
        e.user_target_period=params[:target_period]
        e.user_target_value=params[:target_value]
        e.save
      end
    else
      @targets.update_attributes(:user_target=>params[:target],:user_target_period=>params[:target_period],:user_target_value=>params[:target_value])
    end
    render :json => "s".to_json
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
    @detailedmonth=Userdata_detailed_month.find_by_username(session[:webusername])
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
    month=0
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    if @userdatamonth!=nil
      if @userdatamonth.debt_month!=nil
      month=@userdatamonth.invest_expense-@userdatamonth.debt_month
      else
        month=@userdatamonth.invest_expense
      end
    end
    @hash.store('length',[@targets.size,annual,month])
    render :json => @hash.to_json
  end

  def userdatadetailedannual
    @userdataannual=Userdata_detailed_annual.find_by_username(params[:username])
    if @userdataannual==nil
      Userdata_detailed_annual.new do |e|
        e.username=params[:username]
        e.income1_account=params[:income1]
        e.income2_account=params[:income2]
        e.income3_account=params[:income3]
        e.expense1_account=params[:expense1]
        e.expense2_account=params[:expense2]
        e.expense3_account=params[:expense3]
        e.expense4_account=params[:expense4]
        e.save
      end
    else
      @userdataannual.update_attributes(:income1_account=>params[:income1],:income2_account=>params[:income2],:income3_account=>params[:income3],:expense1_account=>params[:expense1],
                                        :expense2_account=>params[:expense2],:expense3_account=>params[:expense3],:expense4_account=>params[:expense4])
    end
    @userdata=Userdata_annual.find_by_username(session[:webusername])
    @detailedmonth=Userdata_detailed_month.find_by_username(session[:webusername])
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    if @detailedmonth!=nil
      if @detailedmonth.income1_account!=nil && @detailedmonth.income2_account!=nil
        salary_annual=(@detailedmonth.income1_account+@detailedmonth.income2_account)*12
      elsif  @detailedmonth.income1_account!=nil && @detailedmonth.income2_account==nil
        salary_annual=@detailedmonth.income1_account*12
      elsif  @detailedmonth.income1_account==nil && @detailedmonth.income2_account!=nil
        salary_annual=@detailedmonth.income2_account*12
      else
        salary_annual=0
      end
    elsif @userdatamonth!=nil && @userdatamonth.income!=nil
      salary_annual=@userdatamonth.income*12
    else
      salary_annual=0
    end

    if @userdatamonth!=nil && @userdatamonth.must_expense!=nil
      must_expense_annual=@userdatamonth.must_expense*12
    else
      must_expense_annual=0
    end
    if @userdatamonth!=nil && @userdatamonth.fun_expense!=nil
      fun_expense_annual=@userdatamonth.fun_expense*12
    else
      fun_expense_annual=0
    end
    @userdebtsheet=User_debt_sheet.find_by_username(session[:webusername])
    if @userdatamonth!=nil && @userdatamonth.debt_month!=nil
      debt_annual=@userdatamonth.debt_month*12
    elsif @userdebtsheet!=nil
      if @userdebtsheet.debt1_account_monthly!=nil
        debt1_account_monthly=@userdebtsheet.debt1_account_monthly
      else
        debt1_account_monthly=0
      end
      if @userdebtsheet.debt2_account_monthly!=nil
        debt2_account_monthly=@userdebtsheet.debt2_account_monthly
      else
        debt2_account_monthly=0
      end
      if @userdebtsheet.debt99_account_monthly!=nil
        debt99_account_monthly=@userdebtsheet.debt99_account_monthly
      else
        debt99_account_monthly=0
      end
      debt_annual=(debt1_account_monthly+debt2_account_monthly+debt99_account_monthly)*12
    else
      debt_annual=0
    end

    income=params[:income1].to_i+params[:income2].to_i+params[:income3].to_i
    expense=params[:expense1].to_i+params[:expense2].to_i+params[:expense3].to_i+params[:expense4].to_i

    net_annual=salary_annual+income-must_expense_annual-fun_expense_annual-debt_annual-expense

    if @userdata==nil
      Userdata_annual.new do |e|
        e.username=params[:username]
        e.salary_annual=salary_annual
        e.bonus_annual=params[:income1].to_i+params[:income2].to_i
        e.other_income_annual=params[:income3]
        e.must_expense_annual=must_expense_annual
        e.fun_expense_annual=fun_expense_annual
        e.debt_annual=debt_annual
        e.income_annual=income
        e.expense_annual=expense
        e.net_annual=net_annual
        e.save
      end
    else
      @userdata.update_attributes(:salary_annual=>salary_annual,:bonus_annual=>(params[:income1].to_i+params[:income2].to_i),:other_income_annual=>params[:income3],:must_expense_annual=>must_expense_annual,
                                  :fun_expense_annual=>fun_expense_annual,:debt_annual=>debt_annual,:income_annual=>income,:expense_annual=>expense,:net_annual=>net_annual)
    end
    render :json => "s".to_json
  end

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
    must_expense=params[:expense1].to_i+params[:expense2].to_i+params[:expense6].to_i
    fun_expense=params[:expense3].to_i+params[:expense4].to_i+params[:expense5].to_i+params[:expense7].to_i

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
    if params[:mid]=='1'
      @userdata=Userdata_annual.find_by_username(session[:webusername])
      if @userdata!=nil
        incomes=(params[:income1].to_i+params[:income2].to_i)*12+@userdata.income_annual
        expenses=@userdata.debt_annual+must_expense*12+fun_expense*12+@userdata.expense_annual
        @userdata.update_attributes(:salary_annual=>(params[:income1].to_i+params[:income2].to_i)*12,:must_expense_annual=>must_expense*12,:fun_expense_annual=>fun_expense*12,:net_annual=>incomes-expenses)
      end
    end
    t=rate.to_s+','+income.to_s+','+must_expense.to_s+','+(income-must_expense-fun_expense).to_s
    render :json => t.to_json
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
        e.asset10_account=params[:asset10_account]
        e.save
      end
    else
      @userassetsheet.update_attributes(:asset1_account=>params[:asset1_account],:asset2_account=>params[:asset2_account],:asset3_account=>params[:asset3_account],
                                         :asset4_account=>params[:asset4_account],:asset5_account=>params[:asset5_account],:asset6_account=>params[:asset6_account],
                                         :asset7_account=>params[:asset7_account],:asset8_account=>params[:asset8_account],:asset9_account=>params[:asset9_account],:asset10_account=>params[:asset10_account])
    end
    @userbalancesheet=User_balance_sheet.find_by_username(params[:username])
    a1=params[:asset1_account].to_i+params[:asset2_account].to_i+params[:asset3_account].to_i+params[:asset4_account].to_i+params[:asset5_account].to_i+params[:asset6_account].to_i+params[:asset7_account].to_i+params[:asset8_account].to_i+params[:asset9_account].to_i+params[:asset10_account].to_i
    a3=params[:asset1_account].to_i+params[:asset4_account].to_i
    a4=params[:asset5_account].to_i+params[:asset9_account].to_i+params[:asset10_account].to_i
    a5=params[:asset2_account].to_i+params[:asset3_account].to_i+params[:asset6_account].to_i
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
    a6=format("%.2f",a3/@userdatamonth.must_expense.to_f).to_f
    a7=format("%.2f",a4/a1.to_f).to_f
    a8=format("%.2f",(a3+a5)/a1.to_f).to_f
    a9=a6.to_s+','+a7.to_s+','+a8.to_s
    render :json => a9.to_json
  end

  def step8
    @userbalancesheet=User_balance_sheet.find_by_username(params[:username])
    if @userbalancesheet!=nil
    a1=@userbalancesheet.asset_fluid_account
    a2=@userbalancesheet.asset_safefy_account
    a3=@userbalancesheet.asset_risky_account
    else
      a1=0
      a2=0
      a3=0
    end
    render :json => (a1.to_s+','+a2.to_s+','+a3.to_s).to_json
  end

  def step9
    @userdebtsheet=User_debt_sheet.find_by_username(session[:webusername])
    a1=@userdebtsheet.debt1_account_totally
    a2=@userdebtsheet.debt1_account_monthly
    a3=@userdebtsheet.debt2_account_totally
    a4=@userdebtsheet.debt2_account_monthly
    a5=@userdebtsheet.debt99_account_totally
    a6=@userdebtsheet.debt99_account_monthly
    @detailedmonth=Userdata_detailed_month.find_by_username(session[:webusername])
    if @detailedmonth!=nil
    b1=@detailedmonth.income1_account
    b2=@detailedmonth.income2_account
    b3=@detailedmonth.income3_account
    b4=@detailedmonth.expense1_account
    b5=@detailedmonth.expense2_account
    b6=@detailedmonth.expense3_account
    b7=@detailedmonth.expense4_account
    b8=@detailedmonth.expense5_account
    b9=@detailedmonth.expense6_account
    b10=@detailedmonth.expense7_account
    b11=@detailedmonth.expense1_expect_account
    b12=@detailedmonth.expense2_expect_account
    b13=@detailedmonth.expense3_expect_account
    b14=@detailedmonth.expense4_expect_account
    b15=@detailedmonth.expense5_expect_account
    b16=@detailedmonth.expense6_expect_account
    b17=@detailedmonth.expense7_expect_account
    else
      b1=0;b2=0;b3=0;b4=0;b5=0;b6=0;b7=0;b8=0;b9=0;b10=0;
      b11=0;b12=0;b13=0;b14=0;b15=0;b16=0;b17=0;
    end
    @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    c1=@userdatamonth.income
    c2=@userdatamonth.must_expense
    c3=@userdatamonth.fun_expense
    c4=@userdatamonth.invest_expense
    @userdataannual=Userdata_detailed_annual.find_by_username(session[:webusername])
    if @userdataannual!=nil
    d1=@userdataannual.income1_account
    d2=@userdataannual.income2_account
    d3=@userdataannual.income3_account
    d4=@userdataannual.expense1_account
    d5=@userdataannual.expense2_account
    d6=@userdataannual.expense3_account
    d7=@userdataannual.expense4_account
    else
      d1=0
      d2=0
      d3=0
      d4=0
      d5=0
      d6=0
      d7=0
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
    @userassetsheet=User_asset_sheet.find_by_username(session[:webusername])
    if @userassetsheet!=nil
       f1=@userassetsheet.asset1_account
       f2=@userassetsheet.asset2_account
       f3=@userassetsheet.asset3_account
       f4=@userassetsheet.asset4_account
       f5=@userassetsheet.asset5_account
       f6=@userassetsheet.asset6_account
       f7=@userassetsheet.asset7_account
       f8=@userassetsheet.asset8_account
       f9=@userassetsheet.asset9_account
       f10=@userassetsheet.asset10_account
    else
      f1=0
      f2=0
      f3=0
      f4=0
      f5=0
      f6=0
      f7=0
      f8=0
      f9=0
      f10=0
    end
    @userbalancesheet=User_balance_sheet.find_by_username(params[:username])
    if @userbalancesheet!=nil
      g1=@userbalancesheet.asset_account
      g2=@userbalancesheet.debt_account
      g3=@userbalancesheet.net_account
      g4=@userbalancesheet.asset_fluid_account
      g5=@userbalancesheet.asset_safefy_account
      g6=@userbalancesheet.asset_risky_account
    else
      g1=0
      g2=0
      g3=0
      g3=0
      g4=0
      g5=0
      g6=0
    end
    a=[[a1,a2,a3,a4,a5,a6],[b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17],[c1,c2,c3,c4],[d1,d2,d3,d4,d5,d6,d7],[e1,e2,e3,e4,e5,e6,e7,e8,e9],[f1,f2,f3,f4,f5,f6,f7,f8,f9,f10],[g1,g2,g3,g4,g5,g6]]
    render :json => a.to_json
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
      @userdebtsheet=User_debt_sheet.find_by_username(session[:webusername])
      @userassetsheet=User_asset_sheet.find_by_username(session[:webusername])
      @examination=Examination.find_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @detailedmonth=Userdata_detailed_month.find_by_username(session[:webusername])
      @userdateannual=Userdata_annual.find_by_username(session[:webusername])
      @detailedannual=Userdata_detailed_annual.find_by_username(session[:webusername])
      @webuser=Webuser.find_by_username(session[:webusername])
      @category=Admin_asset_type_L2.all
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

  def saveage
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      @webuser.update_attributes(:age=>params[:age],:sex=>params[:sex])
      render :json => "s".to_json
    end
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
