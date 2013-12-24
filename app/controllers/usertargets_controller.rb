#encoding: utf-8
require 'open-uri'
class UsertargetsController < ApplicationController

  def p2_usertargets
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @userfinancedata=User_finance_data.find_by_username(session[:webusername])
      @blog=Blog.find_by_id(452)
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p2_usertargets=>"1")
    end
  end

  def p2s1_user_target_select
    if session[:webusername]!=nil
      @targets=User_targets.find_all_by_username(session[:webusername])
      @webuser=Webuser.find_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @userfinancedata=User_finance_data.find_by_username(session[:webusername])
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p2s1=>"1")
    end
  end

  def p2s1_house_buying
    if session[:webusername]!=nil
      @userhousetarget=User_house_buying_target.find_by_username(session[:webusername])
      @debtqita=0
      @userdebtsheet=User_debt_sheet.find_all_by_username(session[:webusername])
      for i in 0..@userdebtsheet.size-1
        if @userdebtsheet[i].debt_value_monthly!=nil
          if @userdebtsheet[i].debt_typeid!=101
            @debtqita=@debtqita+@userdebtsheet[i].debt_value_monthly
          end
        end
      end
      @xiaofei=0
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @halfofsalarymonth=0
      if @userdatamonth!=nil
        if @userdatamonth.salary_month!=nil
          @halfofsalarymonth=@halfofsalarymonth+@userdatamonth.salary_month/2
        end
        if @userdatamonth.extra_income_month!=nil
          @halfofsalarymonth=@halfofsalarymonth+@userdatamonth.extra_income_month/2
        end
        if @userdatamonth.must_expense_month!=nil
          @xiaofei=@xiaofei+@userdatamonth.must_expense_month
        end
        if @userdatamonth.fun_expense_month!=nil
          @xiaofei=@xiaofei+@userdatamonth.fun_expense_month
        end
        if @userdatamonth.invest_expense_month!=nil
          @xiaofei=@xiaofei+@userdatamonth.invest_expense_month
        end
      end
      @incomemonth1=Userdata_detailedincome_month.find_by_username_and_income_typeid(session[:webusername],1000)
      @incomemonth2=Userdata_detailedincome_month.find_by_username_and_income_typeid(session[:webusername],2000)
      @salarymonth1=0
      @salarymonth2=0
      if @incomemonth1!=nil || @incomemonth2!=nil
         if @incomemonth1!=nil && @incomemonth1.income_value!=nil
           @salarymonth1=@incomemonth1.income_value
         end
         if @incomemonth2!=nil && @incomemonth2.income_value!=nil
           @salarymonth2=@incomemonth2.income_value
         end
      elsif @userdatamonth!=nil && @userdatamonth.salary_month!=nil
        @salarymonth1= @userdatamonth.salary_month
      end
      @gjjfee1=(@salarymonth1*0.45*12*20>300000?300000:@salarymonth1*0.45*12*20).to_i
      @gjjfee2=(@salarymonth2*0.45*12*20>300000?300000:@salarymonth2*0.45*12*20).to_i
      @gjjfee=@gjjfee1+@gjjfee2
      if @userhousetarget==nil || (@userhousetarget.sell_house_account==nil && @userhousetarget.family_saving_account==nil && @userhousetarget.borrowing_account==nil)
        sell_house_account=0
        @user_asset_sheet=User_asset_sheet.find_by_username_and_asset_typeid(session[:webusername],401)
        if @user_asset_sheet!=nil
          sell_house_account=@user_asset_sheet.asset_value
        end
        family_saving_account=0
        @userassetsheet=User_asset_sheet.find_by_sql("select * from user_asset_sheet where username='"+session[:webusername]+"' and asset_typeid<>401 && asset_typeid<>402")
        for i in 0..@userassetsheet.size-1
          family_saving_account=family_saving_account+@userassetsheet[i].asset_value
        end

        if @userhousetarget!=nil
          @userhousetarget.update_attributes(:sell_house_account=>sell_house_account,:family_saving_account=>family_saving_account,:borrowing_account=>0)
        else
          User_house_buying_target.new do |u|
            u.username=session[:webusername]
            u.sell_house_account=sell_house_account
            u.family_saving_account=family_saving_account
            u.borrowing_account=0
            u.save
          end
        end
      end
      @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
      @chuxu=0
      if @userbalancesheet!=nil && @userbalancesheet.asset_account!=nil
        @chuxu=@userbalancesheet.asset_account
      end
      @userhousetarget=User_house_buying_target.find_by_username(session[:webusername])
      @downpayment=0
      if @userhousetarget!=nil
        if @userhousetarget.sell_house_account!=nil
          @downpayment=@downpayment+@userhousetarget.sell_house_account
        end
        if @userhousetarget.family_saving_account!=nil
          @chuxu=@chuxu-@userhousetarget.family_saving_account
          @downpayment=@downpayment+@userhousetarget.family_saving_account
        end
        if @userhousetarget.borrowing_account!=nil
          @downpayment=@downpayment+@userhousetarget.borrowing_account
        end
      end
      if @chuxu<0
        @chuxu=0
      end
      @month=0
     if @userdatamonth!=nil && @userdatamonth.must_expense_month!=nil
       @month=@chuxu/@userdatamonth.must_expense_month
     end
      @syfee=(7*@downpayment/3-@gjjfee)>0?(7*@downpayment/3-@gjjfee):0
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p2s1house=>"1")
    end
  end

  def house_target_save
    @userhousetarget=User_house_buying_target.find_by_username(params[:username])
    if @userhousetarget!=nil
      @userhousetarget.update_attributes(:sell_house_account=>params[:sell_house_account],:family_saving_account=>params[:family_saving_account],:borrowing_account=>params[:borrowing_account],
                                         :mortgage_years=>params[:mortgage_years],:mortgage_rate=>params[:mortgage_rate])

    else
      User_house_buying_target.new do |u|
        u.username=params[:username]
        u.sell_house_account=params[:sell_house_account]
        u.family_saving_account=params[:family_saving_account]
        u.borrowing_account=params[:borrowing_account]
        u.mortgage_years=params[:mortgage_years]
        u.mortgage_rate=params[:mortgage_rate]
        u.save
      end
    end
    render :json => "s".to_json
  end

  def housebuyingtarget_save
    @userhousetarget=User_house_buying_target.find_by_username(params[:username])
    if @userhousetarget!=nil
      @userhousetarget.update_attributes(:buy_house_type=>params[:buy_house_type],:buy_house_area=>params[:buy_house_area],:buy_house_uint_prince=>params[:buy_house_uint_prince],
                                         :buy_house_attribute=>params[:buy_house_attribute],:house_sell_years=>params[:house_sell_years],:is_first_house=>params[:is_first_house])
    else
      User_house_buying_target.new do |u|
        u.username=params[:username]
        u.buy_house_type=params[:buy_house_type]
        u.buy_house_area=params[:buy_house_area]
        u.buy_house_uint_prince=params[:buy_house_uint_prince]
        u.buy_house_attribute=params[:buy_house_attribute]
        u.house_sell_years=params[:house_sell_years]
        u.is_first_house=params[:is_first_house]
        u.save
      end
    end
    render :json => "s".to_json
  end

  def p2s2_user_target_intro
    if params[:username]!=nil
      @webuser=Webuser.find_by_username(params[:username])
    elsif session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p2s2=>"1")
    end
    if @webuser!=nil
    @targets=User_targets.find_by_username(@webuser.username)
    @userdata=Userdata_annual.find_by_username(@webuser.username)
    @userfinancedata=User_finance_data.find_by_username(@webuser.username)
    @detailedmonth=Userdata_detailedincome_month.find_by_username_and_income_typeid(@webuser.username,3000)
    @annual=0
    if @userdata!=nil &&  @userdata.net_annual!=nil
      if @detailedmonth!=nil
        @annual=@userdata.net_annual+@detailedmonth.income_value*12
      else
        @annual=@userdata.net_annual
      end
    elsif @detailedmonth!=nil && @detailedmonth.income_value!=nil
      @annual=@detailedmonth.income_value*12
    end

    @userbalancesheet=User_balance_sheet.find_by_username(@webuser.username)
    @income=0
    if @userbalancesheet!=nil
      @income=@userbalancesheet.asset_fluid_account+@userbalancesheet.asset_safefy_account+@userbalancesheet.asset_risky_account
    end

    @month=0
    @userdatamonth=Userdata_month.find_by_username(@webuser.username)

    @incomemonth=Userdata_detailedincome_month.find_all_by_username(session[:webusername])
    @expensemonth=Userdata_detailedexpense_month.find_all_by_username(session[:webusername])
    if @userdatamonth!=nil
      if @incomemonth!=nil && @expensemonth!=nil
        @month=@userdatamonth.invest_expense_month
      else
      if @userdatamonth.debt_month!=nil
        @month=@userdatamonth.invest_expense_month-@userdatamonth.debt_month
      else
        @month=@userdatamonth.invest_expense_month
      end
    end
  end
end
end
end
