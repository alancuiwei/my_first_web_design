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
