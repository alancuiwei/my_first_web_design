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
      @targets=User_targets.where(username:session[:webusername])
      @webuser=Webuser.find_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @userfinancedata=User_finance_data.find_by_username(session[:webusername])
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p2s1=>"1")
    end
  end

  def p2s1_house_buying
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @userhousetarget=User_house_buying_target.find_by_username(session[:webusername])
      @user_asset_sheet=User_asset_sheet.find_by_username_and_asset_typeid(session[:webusername],401)
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])

      if @userhousetarget==nil || (@userhousetarget.sell_house_account==nil && @userhousetarget.family_saving_account==nil && @userhousetarget.borrowing_account==nil)
        sell_house_account=0
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

      @userhousetarget=User_house_buying_target.find_by_username(session[:webusername])
      if @userhousetarget.salary_account==nil
      @incomemonth1=Userdata_detailedincome_month.find_by_username_and_income_typeid(session[:webusername],1000)
      @incomemonth2=Userdata_detailedincome_month.find_by_username_and_income_typeid(session[:webusername],2000)
      @incomemonth3=Userdata_detailedincome_month.find_by_username_and_income_typeid(session[:webusername],3000)
      @salarymonth=0
      if @incomemonth1!=nil || @incomemonth2!=nil || @incomemonth3!=nil
        if @incomemonth1!=nil && @incomemonth1.income_value!=nil
          @salarymonth=@salarymonth+@incomemonth1.income_value
        end
        if @incomemonth2!=nil && @incomemonth2.income_value!=nil
          @salarymonth=@salarymonth+@incomemonth2.income_value
        end
        if @incomemonth3!=nil && @incomemonth3.income_value!=nil
          @salarymonth=@salarymonth+@incomemonth3.income_value
        end
      elsif @userdatamonth!=nil && @userdatamonth.salary_month!=nil
        @salarymonth= @userdatamonth.salary_month
      end
      @userhousetarget.update_attributes(:salary_account=>@salarymonth*12)
      end

      @userhousetarget=User_house_buying_target.find_by_username(session[:webusername])
      @gjjfee=(@userhousetarget.salary_account/24*0.45*12*20>300000?600000:@userhousetarget.salary_account/24*0.45*12*20*2).to_i
      @downpayment=0
      if @userhousetarget!=nil
        if @user_asset_sheet!=nil && @userhousetarget.sell_house_account!=nil
          @downpayment=@downpayment+@userhousetarget.sell_house_account
        end
        if @userhousetarget.family_saving_account!=nil
          @downpayment=@downpayment+@userhousetarget.family_saving_account
        end
        if @userhousetarget.borrowing_account!=nil
          @downpayment=@downpayment+@userhousetarget.borrowing_account
        end
      end
      @downpayment=(@downpayment*0.7).to_i
      @month=0
      if @userhousetarget!=nil && ((@userhousetarget.buy_house_type==0 && @userhousetarget.buy_house_attribute==1) || (@userhousetarget.buy_house_type==1 && @userhousetarget.is_first_house==0))
        @syfee=(3*@downpayment/7-@gjjfee)>0?(3*@downpayment/7-@gjjfee):0
      else
        @syfee=(7*@downpayment/3-@gjjfee)>0?(7*@downpayment/3-@gjjfee):0
      end
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p2s1house=>"1")
    end
  end

  def house_target_save
    @userhousetarget=User_house_buying_target.find_by_username(params[:username])
    if @userhousetarget!=nil
      @userhousetarget.update_attributes(:mortgage_years=>params[:mortgage_years],:mortgage_rate=>params[:mortgage_rate])
    else
      User_house_buying_target.new do |u|
        u.username=params[:username]
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
      @userhousetarget.update_attributes(:sell_house_account=>params[:sell_house_account],:family_saving_account=>params[:family_saving_account],:borrowing_account=>params[:borrowing_account],
                                         :buy_house_type=>params[:buy_house_type],:buy_house_area=>params[:buy_house_area],:buy_house_uint_prince=>params[:buy_house_uint_prince],:salary_account=>params[:salary_account],
                                         :buy_house_attribute=>params[:buy_house_attribute],:house_sell_years=>params[:house_sell_years],:is_first_house=>params[:is_first_house])
    else
      User_house_buying_target.new do |u|
        u.username=params[:username]
        u.sell_house_account=params[:sell_house_account]
        u.family_saving_account=params[:family_saving_account]
        u.borrowing_account=params[:borrowing_account]
        u.buy_house_type=params[:buy_house_type]
        u.buy_house_area=params[:buy_house_area]
        u.buy_house_uint_prince=params[:buy_house_uint_prince]
        u.buy_house_attribute=params[:buy_house_attribute]
        u.house_sell_years=params[:house_sell_years]
        u.is_first_house=params[:is_first_house]
        u.salary_account=params[:salary_account]
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

=begin
    if @userdata!=nil &&  @userdata.net_annual!=nil
      if @detailedmonth!=nil
        @annual=@userdata.net_annual+@detailedmonth.income_value*12
      else
        @annual=@userdata.net_annual
      end
    elsif @detailedmonth!=nil && @detailedmonth.income_value!=nil
      @annual=@detailedmonth.income_value*12
    end
=end
    @userbalancesheet=User_balance_sheet.find_by_username(@webuser.username)
    @income=0
    if @userbalancesheet!=nil
      @income=@userbalancesheet.asset_fluid_account+@userbalancesheet.asset_safefy_account+@userbalancesheet.asset_risky_account
    end

    @month=0
    @userdatamonth=Userdata_month.find_by_username(@webuser.username)

    @incomemonth=Userdata_detailedincome_month.where(username:session[:webusername])
    @expensemonth=Userdata_detailedexpense_month.where(username:session[:webusername])
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
      if @month>0
      @annual=@month*12
      end
    end
  end
end
