# -*- encoding : utf-8 -*-
class WeixinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality

  def show
    render :text => params[:echostr]
  end

  def create
  
	if params[:xml][:Event] == "subscribe"
		render "welcome", :formats => :xml
	end
  
	if params[:xml][:Event] == "CLICK"
		case params[:xml][:EventKey] 
		when "V301"
			render "rtn101", :formats => :xml
    when "V110"
      @webuser=Webuser.find_by_weixincode(params[:xml][:FromUserName])
      if @webuser!=nil
        render "rtn401", :formats => :xml
      else
      render "rtn110", :formats => :xml
      end
    when "V202"
      render "rtn202", :formats => :xml
    when "V203"
      render "rtn203", :formats => :xml
    when "V204"
      render "rtn204", :formats => :xml
    when "V302"
      render "rtn302", :formats => :xml
    when "V303"
      render "rtn303", :formats => :xml
    when "V304"
      render "rtn304", :formats => :xml

		end
	end	
	
    case params[:xml][:MsgType] 
	when "text"
        @webuser=Webuser.find_by_weixincode(params[:xml][:FromUserName])
        if params[:xml][:Content]=~/^基本信息.*$/
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          if content[3]=="已婚"
             married=1
          else
            married=0
          end
          if content[4]=="有子女"
            kids=content[5].to_i
          else
            kids=0
          end
          if @webuser!=nil
            @webuser.update_attributes(:age=>content[1],:sex=>content[2],:married=>married,:kids=>kids)
          end
          render "rtn402", :formats => :xml
        end

        if params[:xml][:Content]=~/^月收入.*$/ && @webuser!=nil
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          income_typeid=[1000,2000,3000]
          for i in 0..2
            @incomemonth=Userdata_detailedincome_month.find_by_username_and_income_typeid(@webuser.username,income_typeid[i])
            if @incomemonth==nil
              Userdata_detailedincome_month.new do |e|
                e.username=@webuser.username
                e.income_typeid=income_typeid[i]
                e.income_value=content[i+1]
                e.save
              end
            else
              @incomemonth.update_attributes(:income_value=>content[i+1])
            end
          end
          income=content[1].to_i+content[2].to_i
          extra=content[3].to_i

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
          render "rtn403", :formats => :xml
        end

        if params[:xml][:Content]=~/^月开销.*$/ && @webuser!=nil
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
                e.expense_value=content[i+1]
                e.save
              end
            else
              @expensemonth.update_attributes(:expense_value=>content[i+1])
            end
            @expensetype=Admin_expense_type_month.find_by_expense_id(expense_typeid[i])
            if @expensetype.expense_type=='must_expense'
              must_expense=must_expense+content[i+1].to_i
            else
              fun_expense=fun_expense+content[i+1].to_i
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
          render "rtn404", :formats => :xml
        end

        if params[:xml][:Content]=~/^年度收入.*$/ && @webuser!=nil
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          incometype=[2001,2002,2099]
          for i in 0..2
            @incomeannual=Userdata_detailedincome_annual.find_by_username_and_income_type(@webuser.username,incometype[i])
            if @incomeannual==nil
              Userdata_detailedincome_annual.new do |e|
                e.username=@webuser.username
                e.income_type=incometype[i]
                e.income_value=content[i+1]
                e.save
              end
            else
              @incomeannual.update_attributes(:income_value=>content[i+1])
            end
          end
          render "rtn405", :formats => :xml
        end

        if params[:xml][:Content]=~/^年度开销.*$/ && @webuser!=nil
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          expensetype=[1001,1002,1003,1099]
          for i in 0..3
            @expenseannual=Userdata_detailedexpense_annual.find_by_username_and_expense_type(@webuser.username,expensetype[i])
            if @expenseannual==nil
              Userdata_detailedexpense_annual.new do |e|
                e.username=@webuser.username
                e.expense_type=expensetype[i]
                e.expense_value=content[i+1]
                e.save
              end
            else
              @expenseannual.update_attributes(:expense_value=>content[i+1])
            end
          end
          render "rtn406", :formats => :xml
        end

        if params[:xml][:Content]=~/^资产现状.*$/ && @webuser!=nil
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          @userassetsheet=User_asset_sheet.destroy_all(:username => @webuser.username)
            for i in 0..(content.size-1)/2-1
              User_asset_sheet.new do |e|
                e.username=@webuser.username
                e.asset_typeid=content[2*i+1]
                e.asset_value=content[2*i+2]
                e.save
              end
            end
          render "rtn407", :formats => :xml
        end

        if params[:xml][:Content]=~/^负债.*$/ && @webuser!=nil
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          @userdebtsheet=User_debt_sheet.destroy_all(:username => @webuser.username)
            for i in 0..(content.size-1)/4-1
              User_debt_sheet.new do |e|
                e.username=@webuser.username
                e.debt_typeid=content[4*i+1]
                e.debt_value=content[4*i+2]
                e.debt_value_monthly=content[4*i+4]
                e.debt_years=content[4*i+3]
                e.save
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
          render "rtn408", :formats => :xml
        end

        if params[:xml][:Content]=~/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/ && @webuser!=nil
          email=params[:xml][:Content]
          Thread.new{
              UserMailer.report(email,"家庭财务诊断报告").deliver
          }
        end

	  case params[:xml][:Content]
	  when "100"
		render "rtn100", :formats => :xml
    when "101"
	  render "rtn101", :formats => :xml
	  when "200"
		render "rtn200", :formats => :xml
    when "202"
    render "rtn202", :formats => :xml
    when "203"
    render "rtn203", :formats => :xml
    when "204"
    render "rtn204", :formats => :xml

    when "300"
	  render "rtn300", :formats => :xml		
    
#	  else
#	    render "echo", :formats => :xml
	  end      
  end
end

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = ["zhongren", params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end
