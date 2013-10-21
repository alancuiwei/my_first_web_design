# -*- encoding : utf-8 -*-
class WeixinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality

  def show
    render :text => params[:echostr]
  end

  def create

    if params[:username]==nil && params[:xml][:FromUserName]!=nil
      @webuser=Webuser.find_by_weixincode(params[:xml][:FromUserName])
    else
      @webuser=Webuser.find_by_username(session[:webusername])
    end
    @userdatamonth=Userdata_month.find_by_username(@webuser.username)

    if params[:username]==nil && params[:xml][:FromUserName]!=nil
      if params[:xml][:Event] == "subscribe"
        if @webuser!=nil
          @webuser.update_attributes(:segment=>0,:targets=>0)
        end
        render "welcome", :formats => :xml
      end

      if params[:xml][:Event] == "CLICK"
        case params[:xml][:EventKey]
          when "V301"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn101", :formats => :xml
          when "V110"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>400,:targets=>0)
              render "rtn400", :formats => :xml
            else
              render "rtn110", :formats => :xml
            end
          when "V111"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn110", :formats => :xml
          when "V202"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn202", :formats => :xml
          when "V203"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn203", :formats => :xml
          when "V204"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn204", :formats => :xml
          when "V302"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn302", :formats => :xml
          when "V303"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn303", :formats => :xml
          when "V304"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn304", :formats => :xml
          when "V408"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>408,:targets=>0)
              if @webuser.asset_score!=nil
                render "rtn412", :formats => :xml
              else
                render "rtn411", :formats => :xml
              end
            else
              render "rtn411", :formats => :xml
            end
          when "V500"
              if @webuser!=nil
              if @webuser.asset_score!=nil
                @webuser.update_attributes(:segment=>0,:targets=>500)
                render "rtn500", :formats => :xml
              else
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn508", :formats => :xml
              end
            else
              render "rtn110", :formats => :xml
            end
        end
      end
    end

    if (params[:username]==nil && params[:xml][:MsgType]=="text") || session[:webusername]!=nil
      if params[:username]==nil && params[:xml][:MsgType]=="text"
        case params[:xml][:Content]
          when "100"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn100", :formats => :xml
          when "101"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn101", :formats => :xml
          when "200"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn200", :formats => :xml
          when "202"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn202", :formats => :xml
          when "203"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn203", :formats => :xml
          when "204"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn204", :formats => :xml

          when "300"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
            end
            render "rtn300", :formats => :xml

#	  else
#	    render "echo", :formats => :xml
        end
      end

      if @webuser!=nil && @webuser.segment==400 && params[:username]==nil
        content=params[:xml][:Content]
        if content=="Y" || content=="y"
          @webuser.update_attributes(:segment=>401,:targets=>0)
          render "rtn401", :formats => :xml
        elsif content=="N" || content=="n"
          @webuser.update_attributes(:segment=>0,:targets=>0)
          render "rtn409", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==401 && params[:username]==nil
        content=params[:xml][:Content].gsub("，",",")
        content=content.split(",")
        if content[3]=="1"
          kids=content[4].to_i
        else
          kids=0
        end
        @webuser.update_attributes(:age=>content[0],:sex=>content[1],:married=>content[2],:kids=>kids)
        @webuser.update_attributes(:segment=>402,:targets=>0)
        render "rtn402", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==402 && params[:username]==nil
        content=params[:xml][:Content].gsub("，",",")
        content=content.split(",")
        income_typeid=[1000,2000,3000]
        for i in 0..2
          @incomemonth=Userdata_detailedincome_month.find_by_username_and_income_typeid(@webuser.username,income_typeid[i])
          if @incomemonth==nil
            Userdata_detailedincome_month.new do |e|
              e.username=@webuser.username
              e.income_typeid=income_typeid[i]
              e.income_value=content[i]
              e.save
            end
          else
            @incomemonth.update_attributes(:income_value=>content[i])
          end
        end
        income=content[0].to_i+content[1].to_i
        extra=content[2].to_i

        @userdatamonth=Userdata_month.find_by_username(@webuser.username)
        if @userdatamonth==nil
          Userdata_month.new do |e|
            e.username=@webuser.username
            e.salary_month=income
            e.extra_income_month=extra
            e.save
          end
        else
          @userdatamonth.update_attributes(:salary_month=>income,:extra_income_month=>extra)
        end
        @webuser.update_attributes(:segment=>403,:targets=>0)
        render "rtn403", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==403 && params[:username]==nil
        if params[:xml][:Content]=="月消费详解"
          render "rtn4031", :formats => :xml
        else
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          expense_typeid=[100,200,300,400,500,600,700]
          must_expense=0
          fun_expense=0
          for i in 0..6
            @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(@webuser.username,expense_typeid[i])
            if @expensemonth==nil
              Userdata_detailedexpense_month.new do |e|
                e.username=@webuser.username
                e.expense_typeid=expense_typeid[i]
                e.expense_value=content[i]
                e.save
              end
            else
              @expensemonth.update_attributes(:expense_value=>content[i])
            end
            @expensetype=Admin_expense_type_month.find_by_expense_id(expense_typeid[i])
            if @expensetype.expense_type=='must_expense'
              must_expense=must_expense+content[i].to_i
            else
              fun_expense=fun_expense+content[i].to_i
            end
          end
          invest_expense_month=0
          @userdatamonth=Userdata_month.find_by_username(@webuser.username)
          if @userdatamonth!=nil
            invest_expense_month=@userdatamonth.salary_month+@userdatamonth.extra_income_month-must_expense-fun_expense
          end
          if invest_expense_month<0
            invest_expense_month=0
          end
          if @userdatamonth!=nil
            @userdatamonth.update_attributes(:must_expense_month=>must_expense,:fun_expense_month=>fun_expense,:invest_expense_month=>invest_expense_month)
          end
          @webuser.update_attributes(:segment=>404,:targets=>0)
          render "rtn404", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==404 && params[:username]==nil
        content=params[:xml][:Content].gsub("，",",")
        content=content.split(",")
        incometype=[2001,2002,2099]
        for i in 0..2
          @incomeannual=Userdata_detailedincome_annual.find_by_username_and_income_type(@webuser.username,incometype[i])
          if @incomeannual==nil
            Userdata_detailedincome_annual.new do |e|
              e.username=@webuser.username
              e.income_type=incometype[i]
              e.income_value=content[i]
              e.save
            end
          else
            @incomeannual.update_attributes(:income_value=>content[i])
          end
        end
        @webuser.update_attributes(:segment=>405,:targets=>0)
        render "rtn405", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==405 && params[:username]==nil
        content=params[:xml][:Content].gsub("，",",")
        content=content.split(",")
        expensetype=[1001,1002,1003,1099]
        for i in 0..3
          @expenseannual=Userdata_detailedexpense_annual.find_by_username_and_expense_type(@webuser.username,expensetype[i])
          if @expenseannual==nil
            Userdata_detailedexpense_annual.new do |e|
              e.username=@webuser.username
              e.expense_type=expensetype[i]
              e.expense_value=content[i]
              e.save
            end
          else
            @expenseannual.update_attributes(:expense_value=>content[i])
          end
        end
        @webuser.update_attributes(:segment=>406,:targets=>0)
        render "rtn406", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==406 && params[:username]==nil
        content=params[:xml][:Content].gsub("，",",")
        content=content.split(",")
        @userassetsheet=User_asset_sheet.destroy_all(:username => @webuser.username)
        for i in 0..content.size/2-1
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=content[2*i]
            e.asset_value=content[2*i+1]
            e.save
          end
        end
        @webuser.update_attributes(:segment=>407,:targets=>0)
        render "rtn407", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==407 || session[:webusername]!=nil
        if params[:username]==nil && params[:xml][:MsgType]=="text"
          @userdebtsheet=User_debt_sheet.destroy_all(:username => @webuser.username)
          if params[:xml][:Content]!="0"
            content=params[:xml][:Content].gsub("，",",")
            content=content.split(",")
            for i in 0..content.size/4-1
              User_debt_sheet.new do |e|
                e.username=@webuser.username
                e.debt_typeid=content[4*i]
                e.debt_value=content[4*i+1]
                e.debt_value_monthly=content[4*i+3]
                e.debt_years=content[4*i+2]
                e.save
              end
            end
          end
        end
        @userdebtsheet=User_debt_sheet.find_all_by_username(@webuser.username)
        debt_month=0
        debt_account=0
        for i in 0..@userdebtsheet.size-1
          debt_account=debt_account+@userdebtsheet[i].debt_value
          debt_month=debt_month+@userdebtsheet[i].debt_value_monthly
        end
        @userdatamonth=Userdata_month.find_by_username(@webuser.username)
        net_month=@userdatamonth.salary_month+@userdatamonth.extra_income_month-@userdatamonth.must_expense_month-@userdatamonth.fun_expense_month-debt_month
        @userdatamonth.update_attributes(:debt_month=>debt_month,:net_month=>net_month)

        @userdataannual=Userdata_annual.find_by_username(@webuser.username)
        salary_annual=@userdatamonth.salary_month*12
        bonus_annual=0;
        other_income_annual=@userdatamonth.extra_income_month*12;
        @incomeannual=Userdata_detailedincome_annual.find_all_by_username(@webuser.username)
        for i in 0..@incomeannual.size-1
          if @incomeannual[i].income_type==2001 || @incomeannual[i].income_type==2002
            bonus_annual=bonus_annual+@incomeannual[i].income_value
          elsif @incomeannual[i].income_type==2099
            other_income_annual=other_income_annual+@incomeannual[i].income_value
          end
        end
        must_expense_annual=@userdatamonth.must_expense_month*12
        fun_expense_annual=@userdatamonth.fun_expense_month*12;
        debt_annual=@userdatamonth.debt_month*12;
        income_annual=salary_annual+bonus_annual+other_income_annual
        @expenseannual=Userdata_detailedexpense_annual.find_all_by_username(@webuser.username)
        expense_annual=must_expense_annual+fun_expense_annual+debt_annual;
        for i in 0..@expenseannual.size-1
          expense_annual=expense_annual+@expenseannual[i].expense_value
        end
        net_annual=income_annual-expense_annual
        if @userdataannual==nil
          Userdata_annual.new do |e|
            e.username=@webuser.username
            e.salary_annual=salary_annual
            e.bonus_annual=bonus_annual
            e.other_income_annual=other_income_annual
            e.must_expense_annual=must_expense_annual
            e.fun_expense_annual=fun_expense_annual
            e.debt_annual=debt_annual
            e.income_annual=income_annual
            e.expense_annual=expense_annual
            e.net_annual=net_annual
            e.save
          end
        else
          @userdataannual.update_attributes(:salary_annual=>salary_annual,:bonus_annual=>bonus_annual,:other_income_annual=>other_income_annual,:must_expense_annual=>must_expense_annual,
                                            :fun_expense_annual=>fun_expense_annual,:debt_annual=>debt_annual,:income_annual=>income_annual,:expense_annual=>expense_annual,:net_annual=>net_annual)
        end

        @userbalancesheet=User_balance_sheet.find_by_username(@webuser.username)
        asset_account=0;
        asset_fluid_account=0;
        asset_safefy_account=0;
        asset_risky_account=0;
        @userassetsheet=User_asset_sheet.find_all_by_username(@webuser.username)
        for i in 0..@userassetsheet.size-1
          asset_account=asset_account+@userassetsheet[i].asset_value
          @assettype=Admin_asset_type.find_by_asset_typeid(@userassetsheet[i].asset_typeid)
          if @assettype!=nil
            if @assettype.asset_type_L1==100
              asset_fluid_account=asset_fluid_account+@userassetsheet[i].asset_value
            elsif @assettype.asset_type_L1==200
              asset_safefy_account=asset_safefy_account+@userassetsheet[i].asset_value
            elsif @assettype.asset_type_L1==300
              asset_risky_account=asset_risky_account+@userassetsheet[i].asset_value
            end
          end
        end
        net_account=asset_account-debt_account

        if @userbalancesheet==nil
          User_balance_sheet.new do |e|
            e.username=@webuser.username
            e.asset_account=asset_account
            e.debt_account=debt_account
            e.net_account=net_account
            e.asset_fluid_account=asset_fluid_account
            e.asset_risky_account=asset_risky_account
            e.asset_safefy_account=asset_safefy_account
            e.save
          end
        else
          a2=@userbalancesheet.debt_account
          @userbalancesheet.update_attributes(:asset_account=>asset_account,:debt_account=>debt_account,:net_account=>net_account,:asset_fluid_account=>asset_fluid_account,
                                              :asset_risky_account=>asset_risky_account,:asset_safefy_account=>asset_safefy_account)
        end

        @webuser=Webuser.find_by_username(@webuser.username)
        xianjin=asset_fluid_account
        wenjian=asset_safefy_account
        fengxian=asset_risky_account
        jixu=asset_account
        total=@userdatamonth.invest_expense_month*12+jixu
        xian=@userdatamonth.must_expense_month*3
        feng=(total*(80-@webuser.age)/100).to_i
        wen=total-xian-feng
        if jixu!=0 && total!=0
          asset_score=(3-((xian.to_f/total-xianjin.to_f/jixu).abs+(wen.to_f/total-wenjian.to_f/jixu).abs+(feng.to_f/total-fengxian.to_f/jixu).abs))*100/3
        else
          asset_score=0;
        end

        if net_account<0 && net_month<0 && (net_account<-2000 || net_month<-200)
          level=1
        elsif net_account>=0 && net_month<0 && (net_account>=2000 || net_month<-200)
          level=2
        elsif net_account.abs<2000 && net_month.abs<200
          level=3
        elsif net_account<0 && net_month>=0 && (net_account<-2000 || net_month>=200)
          level=4
        elsif net_account>=0 && net_account<50000 && net_month>=5000
          level=5
        elsif net_account>=0 && net_month>=0 && net_account<50000 && net_month<5000 && (net_account>=2000 || net_month>=200)
          level=6
        elsif net_month>=0 && net_account>=50000 && net_month<5000
          level=7
        elsif net_account>=50000 && net_month>=5000
          level=8
        end
        @webuser.update_attributes(:asset_score=>asset_score.round(1),:moonlite_typeid=>level)

        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1100)                        # 储蓄比率=月结余/月收入
        if @userdatamonth.salary_month+@userdatamonth.extra_income_month!=0
          indicators_value=(net_month.to_f/(@userdatamonth.salary_month+@userdatamonth.extra_income_month)).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1100
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1107)                        # 工资收入占比=月工资 / 月总收入
        if @userdatamonth.salary_month+@userdatamonth.extra_income_month!=0
          indicators_value=(@userdatamonth.salary_month.to_f/(@userdatamonth.salary_month+@userdatamonth.extra_income_month)).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1107
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1108)                      # 生活支出占比 =月必要支出/ 月总收入
        if @userdatamonth.salary_month+@userdatamonth.extra_income_month!=0
          indicators_value=(@userdatamonth.must_expense_month.to_f/(@userdatamonth.salary_month+@userdatamonth.extra_income_month)).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1108
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1101)                      #消费性支出占比=消费性支出/总支出
        if @userdatamonth.must_expense_month+@userdatamonth.fun_expense_month+@userdatamonth.debt_month!=0
          indicators_value=(@userdatamonth.fun_expense_month.to_f/(@userdatamonth.must_expense_month+@userdatamonth.fun_expense_month+@userdatamonth.debt_month)).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1101
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1109)                    # 理财支出占比 =理财支出 / 总支出
        if @userdatamonth.must_expense_month+@userdatamonth.fun_expense_month+@userdatamonth.debt_month!=0
          indicators_value=(net_month.to_f/(@userdatamonth.must_expense_month+@userdatamonth.fun_expense_month+@userdatamonth.debt_month)).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1109
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1102)            # 负债比率=总负债/总资产
        if asset_account!=0
          indicators_value=(debt_account.to_f/asset_account).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1102
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1110)                #净值比率=总净值 / 总资产
        if asset_account!=0
          indicators_value=(net_account.to_f/asset_account).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1110
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1111)             # 短期清偿能力=流动资产 / 短期负债  ,  短期负债 = 1年内的总负债，也就是月负债*12
        if @userdatamonth.debt_month!=0
          indicators_value=(asset_fluid_account.to_f/(@userdatamonth.debt_month*12)).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1111
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1112)                  # 生息资产占比 =（流动性+风险性+保本性）/ 总资产
        if asset_account!=0
          indicators_value=((asset_fluid_account+asset_safefy_account+asset_risky_account).to_f/asset_account).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1112
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1103)                   # 负债收入比 = 每月家庭债务/当月收入
        if @userdatamonth.salary_month+@userdatamonth.extra_income_month!=0
          indicators_value=(@userdatamonth.debt_month.to_f/(@userdatamonth.salary_month+@userdatamonth.extra_income_month)).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1103
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1104)                  # 流动性比率 = 流动性资产/每月支出
        if @userdatamonth.salary_month+@userdatamonth.extra_income_month!=0
          indicators_value=(asset_fluid_account.to_f/(@userdatamonth.salary_month+@userdatamonth.extra_income_month)).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1104
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1105)                # 投资性支出占比 = 风险资产/总资产
        if asset_account!=0
          indicators_value=(asset_risky_account.to_f/asset_account).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1105
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        @indicators=User_financial_indicators.find_by_username_and_indicatortypeid(@webuser.username,1106)                # 储蓄支出占比 = 保本资产/总资产
        if asset_account!=0
          indicators_value=(asset_safefy_account.to_f/asset_account).round(2)
        else
          indicators_value=0
        end
        if @indicators==nil
          User_financial_indicators.new do |e|
            e.username=@webuser.username
            e.indicatortypeid=1106
            e.indicators_value=indicators_value
            e.save
          end
        else
          @indicators.update_attributes(:indicators_value=>indicators_value)
        end
        if params[:username]==nil && params[:xml][:MsgType]=="text"
          @webuser.update_attributes(:segment=>408,:targets=>0)
          render "rtn408", :formats => :xml
        else
          render :json => 's'.to_json
        end
      end
      if params[:username]==nil && params[:xml][:MsgType]=="text"
        if params[:xml][:Content]=~/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/ && @webuser!=nil
          email=params[:xml][:Content]
          if @webuser.email!=email
            @webuser.update_attributes(:email=>email)
          end
          Thread.new{
            UserMailer.report(@webuser.username,email,"家庭财务诊断报告").deliver
          }
          @webuser.update_attributes(:segment=>408,:targets=>0)
          render "rtn410", :formats => :xml
        end
      end

      if @webuser!=nil && @webuser.targets==500
        content=params[:xml][:Content]
        targts=["买房","买车","结婚","子女教育","旅游度假","退休计划"]
        if content=="1" || content=="2" || content=="3" || content=="4" || content=="5" || content=="6"
          @targets=User_targets.find_by_username(@webuser.username)
          if @targets==nil
            User_targets.new do |e|
              e.username=@webuser.username
              e.user_target=targts[content.to_i-1]
              e.save
            end
          else
            @targets.update_attributes(:user_target=>targts[content.to_i-1])
          end
          @webuser.update_attributes(:segment=>0,:targets=>500+content.to_i)
          render "rtn50"+content, :formats => :xml
        end
      elsif @webuser!=nil && @webuser.targets==501                    #买房
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        @targets.update_attributes(:transition_value1=>content)
        @webuser.update_attributes(:segment=>0,:targets=>5011)
        render "rtn5011", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5011                    #买房
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        @targets.update_attributes(:user_target_period=>content)
        @webuser.update_attributes(:segment=>0,:targets=>5012)
        render "rtn5012", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5012                    #买房
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        @targets.update_attributes(:transition_value2=>content)
        @webuser.update_attributes(:segment=>0,:targets=>5013)
        render "rtn5013", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5013                    #买房
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        @targets.update_attributes(:transition_value3=>content)
        @webuser.update_attributes(:segment=>0,:targets=>5014)
        render "rtn5014", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5014                    #买房
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        user_target_value=@targets.transition_value1*@targets.transition_value2/10-@targets.transition_value3-content.to_i
        @targets.update_attributes(:transition_value4=>content,:user_target_value=>user_target_value/10000)
        Thread.new{
          UserMailer.targetreport(@webuser.username,@webuser.email,"理财目标报告").deliver
        }
        @webuser.update_attributes(:segment=>0,:targets=>507)
        render "rtn507", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==502                    #买车
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        @targets.update_attributes(:transition_value1=>content)
        @webuser.update_attributes(:segment=>0,:targets=>5021)
        render "rtn5021", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5021                    #买车
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        @targets.update_attributes(:user_target_period=>content)
        @webuser.update_attributes(:segment=>0,:targets=>5022)
        render "rtn5022", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5022                    #买车
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        user_target_value=@targets.transition_value1-content.to_i
        @targets.update_attributes(:transition_value2=>content,:user_target_value=>user_target_value/10000)
        Thread.new{
          UserMailer.targetreport(@webuser.username,@webuser.email,"理财目标报告").deliver
        }
        @webuser.update_attributes(:segment=>0,:targets=>507)
        render "rtn507", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==503                    #结婚
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        @targets.update_attributes(:transition_value1=>content)
        @webuser.update_attributes(:segment=>0,:targets=>5031)
        render "rtn5031", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5031                    #结婚
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        @targets.update_attributes(:user_target_period=>content)
        @webuser.update_attributes(:segment=>0,:targets=>5032)
        render "rtn5032", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5032                    #结婚
        content=params[:xml][:Content]
        @targets=User_targets.find_by_username(@webuser.username)
        user_target_value=@targets.transition_value1-content.to_i
        @targets.update_attributes(:transition_value2=>content,:user_target_value=>user_target_value/10000)
        Thread.new{
          UserMailer.targetreport(@webuser.username,@webuser.email,"理财目标报告").deliver
        }
        @webuser.update_attributes(:segment=>0,:targets=>507)
        render "rtn507", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==504                    #子女教育
        if params[:xml][:Content]=="1"
          @targets=User_targets.find_by_username(@webuser.username)
          @targets.update_attributes(:user_target_period=>15,:user_target_value=>22.14)
          Thread.new{
            UserMailer.targetreport(@webuser.username,@webuser.email,"理财目标报告").deliver
          }
          @webuser.update_attributes(:segment=>0,:targets=>507)
          render "rtn507", :formats => :xml
        end
      elsif @webuser!=nil && @webuser.targets==505                    #旅游度假
        content=params[:xml][:Content]
          @targets=User_targets.find_by_username(@webuser.username)
          @targets.update_attributes(:user_target_value=>content.to_f/10000)
          @webuser.update_attributes(:segment=>0,:targets=>5051)
          render "rtn5051", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==5051                    #旅游度假
        content=params[:xml][:Content]
          @targets=User_targets.find_by_username(@webuser.username)
          @targets.update_attributes(:user_target_period=>content.to_i)
        Thread.new{
          UserMailer.targetreport(@webuser.username,@webuser.email,"理财目标报告").deliver
        }
          @webuser.update_attributes(:segment=>0,:targets=>507)
          render "rtn507", :formats => :xml
      elsif @webuser!=nil && @webuser.targets==506                    #退休计划
        if params[:xml][:Content]=="1"
          @targets=User_targets.find_by_username(@webuser.username)
          @userdatamonth=Userdata_month.find_by_username(@webuser.username)
          @targets.update_attributes(:user_target_period=>65-@webuser.age,:user_target_value=>@userdatamonth.must_expense_month*12*15/10000)
          Thread.new{
            UserMailer.targetreport(@webuser.username,@webuser.email,"理财目标报告").deliver
          }
          @webuser.update_attributes(:segment=>0,:targets=>507)
          render "rtn507", :formats => :xml
        end
      end
    end
  end

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    if params[:username]==nil
      array = ["zhongren", params[:timestamp], params[:nonce]].sort
      render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
    end
  end
end
