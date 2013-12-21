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
      @downpayment=0
      if @userhousetarget!=nil
        if @userhousetarget.sell_house_account!=nil
          @downpayment=@downpayment+@userhousetarget.sell_house_account
        end
        if @userhousetarget.family_saving_account!=nil
          @downpayment=@downpayment+@userhousetarget.family_saving_account
        end
        if @userhousetarget.borrowing_account!=nil
          @downpayment=@downpayment+@userhousetarget.borrowing_account
        end
      end
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p2s1house=>"1")
    end
  end

  def house_target_save
    @userhousetarget=User_house_buying_target.find_by_username(params[:username])
    if @userhousetarget!=nil
      @userhousetarget.update_attributes(:sell_house_account=>params[:sell_house_account],:family_saving_account=>params[:family_saving_account],:borrowing_account=>params[:borrowing_account],
                                         :monthly_public_fund_house=>params[:monthly_public_fund_house],:spouse_monthly_public_fund_house=>params[:spouse_monthly_public_fund_house],:loan_commercial_years=>params[:loan_commercial_years],
                                         :loan_commercial_rate=>params[:loan_commercial_rate],:city=>params[:city])
    else
      User_house_buying_target.new do |u|
        u.username=params[:username]
        u.sell_house_account=params[:sell_house_account]
        u.family_saving_account=params[:family_saving_account]
        u.borrowing_account=params[:borrowing_account]
        u.monthly_public_fund_house=params[:monthly_public_fund_house]
        u.spouse_monthly_public_fund_house=params[:spouse_monthly_public_fund_house]
        u.loan_commercial_years=params[:loan_commercial_years]
        u.loan_commercial_rate=params[:loan_commercial_rate]
        u.city=params[:city]
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
