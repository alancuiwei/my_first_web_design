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
    if @webuser!=nil
      @userdatamonth=Userdata_month.find_by_username(@webuser.username)
      @userasset=User_asset_sheet.find_all_by_username(@webuser.username)
      @assettype=Admin_asset_type.all
      @hash1={}
      for i in 0..@assettype.size-1
        @hash1.store(@assettype[i].asset_typeid.to_i,[@assettype[i].asset_typename,@assettype[i].asset_type_L1])
      end
      @hash={}
      for i in 0..@userasset.size-1
        if @userasset[i].asset_product_code!=nil
          @fundquote1=Monetary_fund_quote.find_by_product_code(@userasset[i].asset_product_code)
          @fundquote2=General_fund_quote.find_by_product_code(@userasset[i].asset_product_code)
          if @fundquote1!=nil
            @hash.store(@userasset[i].asset_product_code,[@fundquote1.productname,@fundquote1.product_code,101])
          elsif @fundquote2!=nil
            @hash.store(@userasset[i].asset_product_code,[@fundquote2.product_name,@fundquote2.product_code,@fundquote2.L2_typeid])
          else
            @hash.store(@userasset[i].asset_product_code,[nil])
          end
        end
      end
    end
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
            if @webuser!=nil && @webuser.asset_score!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
              render "rtn413", :formats => :xml
            elsif @webuser!=nil
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
          when "V500"
            if @webuser!=nil
            @targets=User_targets.find_by_username(@webuser.username)
              if @webuser.asset_score!=nil && @targets!=nil
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn509", :formats => :xml
              elsif @webuser.asset_score!=nil
                @webuser.update_attributes(:segment=>0,:targets=>500)
                render "rtn500", :formats => :xml
              else
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn508", :formats => :xml
              end
            else
              render "rtn110", :formats => :xml
            end
          when "V600"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
              render "rtn600", :formats => :xml
            else
              render "rtn110", :formats => :xml
            end
          when "V700"
            if @webuser!=nil
              @targets=User_targets.find_by_username(@webuser.username)
              if @webuser.asset_score==nil
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn508", :formats => :xml
              elsif  @targets==nil
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn510", :formats => :xml
              elsif @webuser.risk_score!=nil
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn701", :formats => :xml
              else
              @webuser.update_attributes(:segment=>0,:targets=>0)
              render "rtn700", :formats => :xml
              end
            else
              render "rtn110", :formats => :xml
            end
          when "V800"
            if @webuser!=nil && @webuser.property==805
              @userasset=User_asset_sheet.find_all_by_username(@webuser.username)
              @liudong=0
              @guding=0
              @zong=0
              for i in 0..@userasset.size-1
                value=0
                if @userasset[i].asset_product_value!=nil
                  value=@userasset[i].asset_product_value
                elsif @userasset[i].asset_value!=nil
                  value=@userasset[i].asset_value
                end
                if @hash1[@userasset[i].asset_typeid][1]==100
                  @liudong=@liudong+value
                elsif @hash1[@userasset[i].asset_typeid][1]==400
                  @guding=@guding+value
                end
                @zong=@zong+value
              end
              render "rtn805", :formats => :xml
            elsif @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0,:property=>800)
              render "rtn800", :formats => :xml
            else
              render "rtn110", :formats => :xml
            end
          when "V900"
            if @webuser!=nil
              @targets=User_targets.find_by_username(@webuser.username)
              if @webuser.asset_score==nil
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn508", :formats => :xml
              elsif  @targets==nil
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn510", :formats => :xml
              elsif @webuser.risk_score==nil
                @webuser.update_attributes(:segment=>0,:targets=>0)
                render "rtn511", :formats => :xml
              else
                @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>900)
                render "rtn900", :formats => :xml
              end
            else
              render "rtn110", :formats => :xml
            end
        end
      end
    end

    if (params[:username]==nil && params[:xml][:MsgType]=="text") || session[:webusername]!=nil
      if params[:username]==nil && params[:xml][:MsgType]=="text" && !(@webuser.segment>0) && !(@webuser.property>0)
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

          when "601"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
              if @webuser.asset_score!=nil
                render "rtn412", :formats => :xml
              else
                render "rtn411", :formats => :xml
              end
            else
              render "rtn411", :formats => :xml
            end
          when "602"
            if @webuser!=nil
            @targets=User_targets.find_by_username(@webuser.username)
              @webuser.update_attributes(:segment=>0,:targets=>0)
              if @targets!=nil
                render "rtn601", :formats => :xml
              else
                render "rtn602", :formats => :xml
              end
            else
              render "rtn602", :formats => :xml
            end
          when "603"
            if @webuser!=nil
              @webuser.update_attributes(:segment=>0,:targets=>0)
              if @webuser.risk_score!=nil
                render "rtn603", :formats => :xml
              else
                render "rtn604", :formats => :xml
              end
            else
              render "rtn604", :formats => :xml
            end

#	  else
#	    render "echo", :formats => :xml
        end
      end
      count=0
      if @webuser!=nil && (@webuser.segment==400 || @webuser.segment==4001 || @webuser.segment==4002 ) && params[:username]==nil
        content=params[:xml][:Content]
        if content=="Y" || content=="y"
          @webuser.update_attributes(:segment=>401,:targets=>0)
          render "rtn401", :formats => :xml
        elsif content=="X" || content=="x"
          @webuser.update_attributes(:segment=>4001,:targets=>0)
          render "rtn4001", :formats => :xml
        elsif content=="D" || content=="d"
          @webuser.update_attributes(:segment=>4002,:targets=>0)
          render "rtn4002", :formats => :xml
        elsif content=="N" || content=="n"
          @webuser.update_attributes(:segment=>0,:targets=>0)
          render "rtn409", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==401 && params[:username]==nil      #年龄
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4013", :formats => :xml
        elsif content.to_i<18
          @webuser.update_attributes(:age=>content)
          render "rtn4011", :formats => :xml
        elsif content.to_i>70
          @webuser.update_attributes(:age=>content)
          render "rtn4012", :formats => :xml
        else
          @webuser.update_attributes(:age=>content)
          @webuser.update_attributes(:segment=>402,:targets=>0)
          render "rtn402", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==402 && params[:username]==nil      #性别
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4021", :formats => :xml
        elsif content=="1" || content=="0"
          @webuser.update_attributes(:sex=>content)
          @webuser.update_attributes(:segment=>403,:targets=>0)
          render "rtn403", :formats => :xml
        else
          render "rtn4022", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==403 && params[:username]==nil        #婚姻
          content=params[:xml][:Content]
          if content=="W" || content=="w"
            render "rtn4031", :formats => :xml
          elsif content=="1"
            @webuser.update_attributes(:married=>content)
            @webuser.update_attributes(:segment=>404,:targets=>0)
            render "rtn404", :formats => :xml
          elsif content=="0"
            @webuser.update_attributes(:married=>content,:kids=>0)
            @webuser.update_attributes(:segment=>406,:targets=>0)
            render "rtn406", :formats => :xml
          else
            render "rtn4032", :formats => :xml
          end

      elsif @webuser!=nil && @webuser.segment==404 && params[:username]==nil         #是否有子女
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4041", :formats => :xml
        elsif content=="1"
          @webuser.update_attributes(:segment=>405,:targets=>0)
          render "rtn405", :formats => :xml
        elsif content=="0"
          @webuser.update_attributes(:kids=>0)
          @webuser.update_attributes(:segment=>406,:targets=>0)
          render "rtn406", :formats => :xml
        else
          render "rtn4042", :formats => :xml
        end
      elsif @webuser!=nil && @webuser.segment==405 && params[:username]==nil   #子女年龄
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4051", :formats => :xml
        elsif content.to_i<=70 || content.to_i>0
          @webuser.update_attributes(:kids=>content)
          @webuser.update_attributes(:segment=>406,:targets=>0)
          render "rtn406", :formats => :xml
        else
          render "rtn4052", :formats => :xml
        end
      elsif @webuser!=nil && @webuser.segment==406 && params[:username]==nil   #月收入
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4061", :formats => :xml
        else
          @incomemonth=Userdata_detailedincome_month.destroy_all(:username => @webuser.username)
          Userdata_detailedincome_month.new do |e|
            e.username=@webuser.username
            e.income_typeid=1000
            e.income_value=content
            e.save
          end
          if @webuser.married==1
            @webuser.update_attributes(:segment=>407,:targets=>0)
            render "rtn407", :formats => :xml
          else
            @webuser.update_attributes(:segment=>414,:targets=>0)
            render "rtn414", :formats => :xml
          end
        end

      elsif @webuser!=nil && @webuser.segment==407 && params[:username]==nil   #爱人月收入
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4061", :formats => :xml
        else
          Userdata_detailedincome_month.new do |e|
            e.username=@webuser.username
            e.income_typeid=2000
            e.income_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>414,:targets=>0)
          render "rtn414", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==414 && params[:username]==nil   #月额外收入
        content=params[:xml][:Content]
        Userdata_detailedincome_month.new do |e|
          e.username=@webuser.username
          e.income_typeid=3000
          e.income_value=content
          e.save
        end
        income=0
        extra=0
        @incomemonth=Userdata_detailedincome_month.find_all_by_username(@webuser.username)
        for i in 0..@incomemonth.size-1
          if @incomemonth[i].income_typeid==1000 || @incomemonth[i].income_typeid==2000
            income=income+@incomemonth[i].income_value
          elsif @incomemonth[i].income_typeid==3000
            extra=extra+@incomemonth[i].income_value
          end
        end

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
        @webuser.update_attributes(:segment=>415,:targets=>0)
        render "rtn415", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==415 && params[:username]==nil   #餐饮开销
        content=params[:xml][:Content]
        @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(@webuser.username,100)
        if @expensemonth==nil
          Userdata_detailedexpense_month.new do |e|
            e.username=@webuser.username
            e.expense_typeid=100
            e.expense_value=content
            e.save
          end
        else
          @expensemonth.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>416,:targets=>0)
        render "rtn416", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==416 && params[:username]==nil   #交通开销
        content=params[:xml][:Content]
        @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(@webuser.username,200)
        if @expensemonth==nil
          Userdata_detailedexpense_month.new do |e|
            e.username=@webuser.username
            e.expense_typeid=200
            e.expense_value=content
            e.save
          end
        else
          @expensemonth.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>417,:targets=>0)
        render "rtn417", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==417 && params[:username]==nil   #购物开销
        content=params[:xml][:Content]
        @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(@webuser.username,300)
        if @expensemonth==nil
          Userdata_detailedexpense_month.new do |e|
            e.username=@webuser.username
            e.expense_typeid=300
            e.expense_value=content
            e.save
          end
        else
          @expensemonth.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>418,:targets=>0)
        render "rtn418", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==418 && params[:username]==nil   #娱乐开销
        content=params[:xml][:Content]
        @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(@webuser.username,400)
        if @expensemonth==nil
          Userdata_detailedexpense_month.new do |e|
            e.username=@webuser.username
            e.expense_typeid=400
            e.expense_value=content
            e.save
          end
        else
          @expensemonth.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>419,:targets=>0)
        render "rtn419", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==419 && params[:username]==nil   #医教开销
        content=params[:xml][:Content]
        @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(@webuser.username,500)
        if @expensemonth==nil
          Userdata_detailedexpense_month.new do |e|
            e.username=@webuser.username
            e.expense_typeid=500
            e.expense_value=content
            e.save
          end
        else
          @expensemonth.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>420,:targets=>0)
        render "rtn420", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==420 && params[:username]==nil   #居家开销
        content=params[:xml][:Content]
        @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(@webuser.username,600)
        if @expensemonth==nil
          Userdata_detailedexpense_month.new do |e|
            e.username=@webuser.username
            e.expense_typeid=600
            e.expense_value=content
            e.save
          end
        else
          @expensemonth.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>421,:targets=>0)
        render "rtn421", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==421 && params[:username]==nil   #人情开销
        content=params[:xml][:Content]
        @expensemonth=Userdata_detailedexpense_month.find_by_username_and_expense_typeid(@webuser.username,700)
        if @expensemonth==nil
          Userdata_detailedexpense_month.new do |e|
            e.username=@webuser.username
            e.expense_typeid=700
            e.expense_value=content
            e.save
          end
        else
          @expensemonth.update_attributes(:expense_value=>content)
        end
        must_expense=0
        fun_expense=0
        @expensemonth=Userdata_detailedexpense_month.find_all_by_username(@webuser.username)
        for i in 0..@expensemonth.size-1
          @expensetype=Admin_expense_type_month.find_by_expense_id(@expensemonth[i].expense_typeid)
          if @expensetype.expense_type=='must_expense'
            must_expense=must_expense+@expensemonth[i].expense_value
          else
            fun_expense=fun_expense+@expensemonth[i].expense_value
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
        @webuser.update_attributes(:segment=>422,:targets=>0)
        render "rtn422", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==422 && params[:username]==nil   #年终奖
        content=params[:xml][:Content]
        @incomeannual=Userdata_detailedincome_annual.destroy_all(:username => @webuser.username)
        Userdata_detailedincome_annual.new do |e|
          e.username=@webuser.username
          e.income_type=2001
          e.income_value=content
          e.save
        end
        if @webuser.married==1
          @webuser.update_attributes(:segment=>423,:targets=>0)
          render "rtn423", :formats => :xml
        else
          @webuser.update_attributes(:segment=>424,:targets=>0)
          render "rtn424", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==423 && params[:username]==nil   #爱人年终奖
        content=params[:xml][:Content]
        Userdata_detailedincome_annual.new do |e|
          e.username=@webuser.username
          e.income_type=2002
          e.income_value=content
          e.save
        end
        @webuser.update_attributes(:segment=>424,:targets=>0)
        render "rtn424", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==424 && params[:username]==nil   #其他年终收入
        content=params[:xml][:Content]
        Userdata_detailedincome_annual.new do |e|
          e.username=@webuser.username
          e.income_type=2099
          e.income_value=content
          e.save
        end
        @webuser.update_attributes(:segment=>425,:targets=>0)
        render "rtn425", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==425 && params[:username]==nil   #是否有年度开销
        content=params[:xml][:Content]
        if content=="0"
          @expenseannual=Userdata_detailedexpense_annual.destroy_all(:username => @webuser.username)
          @webuser.update_attributes(:segment=>431,:targets=>0)
          render "rtn431", :formats => :xml
        elsif content=="100"
          @webuser.update_attributes(:segment=>426,:targets=>0)
          render "rtn426", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==426 && params[:username]==nil   #年度旅游开销
        content=params[:xml][:Content]
        @expenseannual=Userdata_detailedexpense_annual.find_by_username_and_expense_type(@webuser.username,1001)
        if @expenseannual==nil
          Userdata_detailedexpense_annual.new do |e|
            e.username=@webuser.username
            e.expense_type=1001
            e.expense_value=content
            e.save
          end
        else
          @expenseannual.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>427,:targets=>0)
        render "rtn427", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==427 && params[:username]==nil   #年度保险开销
        content=params[:xml][:Content]
        @expenseannual=Userdata_detailedexpense_annual.find_by_username_and_expense_type(@webuser.username,1002)
        if @expenseannual==nil
          Userdata_detailedexpense_annual.new do |e|
            e.username=@webuser.username
            e.expense_type=1002
            e.expense_value=content
            e.save
          end
        else
          @expenseannual.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>428,:targets=>0)
        render "rtn428", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==428 && params[:username]==nil   #年度子女学费
        content=params[:xml][:Content]
        @expenseannual=Userdata_detailedexpense_annual.find_by_username_and_expense_type(@webuser.username,1003)
        if @expenseannual==nil
          Userdata_detailedexpense_annual.new do |e|
            e.username=@webuser.username
            e.expense_type=1003
            e.expense_value=content
            e.save
          end
        else
          @expenseannual.update_attributes(:expense_value=>content)
        end
        @webuser.update_attributes(:segment=>429,:targets=>0)
        render "rtn429", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==429 && params[:username]==nil   #其他年度开销
        content=params[:xml][:Content]
        @expenseannual=Userdata_detailedexpense_annual.find_by_username_and_expense_type(@webuser.username,1099)
        if @expenseannual==nil
          Userdata_detailedexpense_annual.new do |e|
            e.username=@webuser.username
            e.expense_type=1099
            e.expense_value=content
            e.save
          end
        else
          @expenseannual.update_attributes(:expense_value=>content)
        end
        @expenseannual430=Userdata_detailedexpense_annual.find_all_by_username(@webuser.username)
        @expensetype430=Admin_expense_type_annual.all
        @hash430={}
        for i in 0..@expensetype430.size-1
          @hash430.store(@expensetype430[i].expense_id,[@expensetype430[i].expense_name])
        end
        @webuser.update_attributes(:segment=>430,:targets=>0)
        render "rtn430", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==430 && params[:username]==nil   #显示所有年度开销
        content=params[:xml][:Content]
        if content=="1"
        @webuser.update_attributes(:segment=>431,:targets=>0)
        render "rtn431", :formats => :xml
        elsif content=="0"
          @webuser.update_attributes(:segment=>426,:targets=>0)
          render "rtn426", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==431 && params[:username]==nil   #活期存款
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          @userassetsheet=User_asset_sheet.destroy_all(:username => @webuser.username)
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=101
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>432,:targets=>0)
          render "rtn432", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==432 && params[:username]==nil   #定期存款
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=201
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>433,:targets=>0)
          render "rtn433", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==433 && params[:username]==nil   #银行理财产品
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=202
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>434,:targets=>0)
          render "rtn434", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==434 && params[:username]==nil   #货币基金
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=102
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>435,:targets=>0)
          render "rtn435", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==435 && params[:username]==nil   #股票、基金
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=301
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>436,:targets=>0)
          render "rtn436", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==436 && params[:username]==nil   #债券、基金
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=203
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>437,:targets=>0)
          render "rtn437", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==437 && params[:username]==nil   #房产
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=401
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>438,:targets=>0)
          render "rtn438", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==438 && params[:username]==nil   #汽车
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=402
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>439,:targets=>0)
          render "rtn439", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==439 && params[:username]==nil   #借贷
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=302
            e.asset_value=content
            e.save
          end
          @webuser.update_attributes(:segment=>440,:targets=>0)
          render "rtn440", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==440 && params[:username]==nil   #其他资产
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4311", :formats => :xml
        else
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=399
            e.asset_value=content
            e.save
          end
          @userassetsheet441=User_asset_sheet.find_all_by_username(@webuser.username)
          @assettype441=Admin_asset_type.all
          @hash441={}
          for i in 0..@assettype441.size-1
            @hash441.store(@assettype441[i].asset_typeid.to_i,[@assettype441[i].asset_typename])
          end
          @webuser.update_attributes(:segment=>441,:targets=>0)
          render "rtn441", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==441 && params[:username]==nil   #显示所有资产
        content=params[:xml][:Content]
        if content=="1"
          @webuser.update_attributes(:segment=>442,:targets=>0)
          render "rtn442", :formats => :xml
        elsif content=="0"
          @webuser.update_attributes(:segment=>431,:targets=>0)
          render "rtn431", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==442 && params[:username]==nil   #是否有贷款负债
        content=params[:xml][:Content]
        if content=="W" || content=="w"
          render "rtn4421", :formats => :xml
        elsif content=="0"
          @userdebtsheet=User_debt_sheet.destroy_all(:username => @webuser.username)
          count=1
        elsif content=="100"
          @webuser.update_attributes(:segment=>443,:targets=>0)
          render "rtn443", :formats => :xml
        end

      elsif @webuser!=nil && @webuser.segment==443 && params[:username]==nil   #房贷
        content=params[:xml][:Content]
        @userdebtsheet=User_debt_sheet.destroy_all(:username => @webuser.username)
        User_debt_sheet.new do |e|
          e.username=@webuser.username
          e.debt_typeid=101
          e.debt_value=content
          e.save
        end
        @webuser.update_attributes(:segment=>444,:targets=>0)
        render "rtn444", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==444 && params[:username]==nil   #房贷
        content=params[:xml][:Content]
        @userdebtsheet=User_debt_sheet.find_by_username_and_debt_typeid(@webuser.username,101)
        if @userdebtsheet!=nil
          @userdebtsheet.update_attributes(:debt_years=>content)
        end
        @webuser.update_attributes(:segment=>445,:targets=>0)
        render "rtn445", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==445 && params[:username]==nil   #房贷
        content=params[:xml][:Content]
        @userdebtsheet=User_debt_sheet.find_by_username_and_debt_typeid(@webuser.username,101)
        if @userdebtsheet!=nil
          @userdebtsheet.update_attributes(:debt_value_monthly=>content)
        end
        @webuser.update_attributes(:segment=>446,:targets=>0)
        render "rtn446", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==446 && params[:username]==nil   #车贷
        content=params[:xml][:Content]
        User_debt_sheet.new do |e|
          e.username=@webuser.username
          e.debt_typeid=102
          e.debt_value=content
          e.save
        end
        @webuser.update_attributes(:segment=>447,:targets=>0)
        render "rtn447", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==447 && params[:username]==nil   #车贷
        content=params[:xml][:Content]
        @userdebtsheet=User_debt_sheet.find_by_username_and_debt_typeid(@webuser.username,102)
        if @userdebtsheet!=nil
          @userdebtsheet.update_attributes(:debt_years=>content)
        end
        @webuser.update_attributes(:segment=>448,:targets=>0)
        render "rtn448", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==448 && params[:username]==nil   #车贷
        content=params[:xml][:Content]
        @userdebtsheet=User_debt_sheet.find_by_username_and_debt_typeid(@webuser.username,102)
        if @userdebtsheet!=nil
          @userdebtsheet.update_attributes(:debt_value_monthly=>content)
        end
        @webuser.update_attributes(:segment=>449,:targets=>0)
        render "rtn449", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==449 && params[:username]==nil   #其他贷款
        content=params[:xml][:Content]
        User_debt_sheet.new do |e|
          e.username=@webuser.username
          e.debt_typeid=199
          e.debt_value=content
          e.save
        end
        @webuser.update_attributes(:segment=>450,:targets=>0)
        render "rtn450", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==450 && params[:username]==nil   #其他贷款
        content=params[:xml][:Content]
        @userdebtsheet=User_debt_sheet.find_by_username_and_debt_typeid(@webuser.username,199)
        if @userdebtsheet!=nil
          @userdebtsheet.update_attributes(:debt_years=>content)
        end
        @webuser.update_attributes(:segment=>451,:targets=>0)
        render "rtn451", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==451 && params[:username]==nil   #其他贷款
        content=params[:xml][:Content]
        @userdebtsheet=User_debt_sheet.find_by_username_and_debt_typeid(@webuser.username,199)
        if @userdebtsheet!=nil
          @userdebtsheet.update_attributes(:debt_value_monthly=>content)
        end
        @userdebtsheet452=User_debt_sheet.find_all_by_username(@webuser.username)
        @debttype452=Admin_debt_type.all
        @hash452={}
        for i in 0..@debttype452.size-1
          @hash452.store(@debttype452[i].debt_typeid,[@debttype452[i].debt_typename])
        end
        @webuser.update_attributes(:segment=>452,:targets=>0)
        render "rtn452", :formats => :xml

      elsif @webuser!=nil && @webuser.segment==452 && params[:username]==nil   #显示所有贷款
        content=params[:xml][:Content]
        if content=="1"
          count=1
        elsif content=="0"
          @webuser.update_attributes(:segment=>443,:targets=>0)
          render "rtn443", :formats => :xml
        end
      end
      if count==1 || session[:webusername]!=nil
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
          value=0
          if @userassetsheet[i].asset_product_value!=nil
            value=@userassetsheet[i].asset_product_value
          elsif @userassetsheet[i].asset_value!=nil
            value=@userassetsheet[i].asset_value
          end
          asset_account=asset_account+value
          @assettype=Admin_asset_type.find_by_asset_typeid(@userassetsheet[i].asset_typeid)
          if @assettype!=nil
            if @assettype.asset_type_L1==100
              asset_fluid_account=asset_fluid_account+value
            elsif @assettype.asset_type_L1==200
              asset_safefy_account=asset_safefy_account+value
            elsif @assettype.asset_type_L1==300
              asset_risky_account=asset_risky_account+value
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

      if params[:username]==nil && params[:xml][:MsgType]=="text"
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
          @targets.update_attributes(:transition_value4=>content,:transition_value5=>0,:user_target_value=>user_target_value/10000)
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
        if @webuser!=nil && @webuser.property==800
          content=params[:xml][:Content]
          if content=="Y" || content=="y"
            huobi=0,zhaiquan=0,gupiao=0;
            @userassetsheet=User_asset_sheet.find_all_by_username(@webuser.username)
            for i in 0..@userassetsheet.size-1
              if @userassetsheet[i].asset_typeid==102
                huobi=1;
              end
              if @userassetsheet[i].asset_typeid==203
                zhaiquan=1
              end
              if @userassetsheet[i].asset_typeid==301
                gupiao=1
              end
            end
            if huobi==1
              @webuser.update_attributes(:segment=>0,:targets=>0,:property=>801)
              render "rtn801", :formats => :xml
            elsif zhaiquan==1
              @webuser.update_attributes(:segment=>0,:targets=>0,:property=>801)
              render "rtn802", :formats => :xml
            elsif gupiao==1
              @webuser.update_attributes(:segment=>0,:targets=>0,:property=>801)
              render "rtn803", :formats => :xml
            else
              @webuser.update_attributes(:segment=>0,:targets=>0,:property=>805)
              render "rtn804", :formats => :xml
            end
          end
        elsif @webuser!=nil && @webuser.property==801
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          @userassetsheet=User_asset_sheet.destroy_all(:username => @webuser.username,:asset_typeid => 102)

          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=102
            e.asset_product_value=content[1].to_i
            e.asset_value=content[1].to_i
            e.asset_product_code=content[0]
            e.save
          end

          @webuser.update_attributes(:segment=>0,:targets=>0,:property=>8011)
          render "rtn8011", :formats => :xml
        elsif @webuser!=nil && @webuser.property==8011
         if params[:xml][:Content]!="0";
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")

          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=102
            e.asset_product_value=content[1].to_i
            e.asset_value=content[1].to_i
            e.asset_product_code=content[0]
            e.save
          end
          render "rtn8011", :formats => :xml
         else
           @userassetsheet=User_asset_sheet.find_all_by_username(@webuser.username)
           zhaiquan=0,gupiao=0;
           for i in 0..@userassetsheet.size-1
             if @userassetsheet[i].asset_typeid==203
               zhaiquan=1
             end
             if @userassetsheet[i].asset_typeid==301
               gupiao=1
             end
           end
           if zhaiquan==1
             @webuser.update_attributes(:segment=>0,:targets=>0,:property=>802)
             render "rtn802", :formats => :xml
           elsif gupiao==1
             @webuser.update_attributes(:segment=>0,:targets=>0,:property=>803)
             render "rtn803", :formats => :xml
           else
             @userasset=User_asset_sheet.find_all_by_username(@webuser.username)
             @liudong=0
             @guding=0
             @zong=0
             for i in 0..@userasset.size-1
               value=0
               if @userasset[i].asset_product_value!=nil
                 value=@userasset[i].asset_product_value
               elsif @userasset[i].asset_value!=nil
                 value=@userasset[i].asset_value
               end
               if @hash1[@userasset[i].asset_typeid][1]==100
                 @liudong=@liudong+value
               elsif @hash1[@userasset[i].asset_typeid][1]==400
                 @guding=@guding+value
               end
               @zong=@zong+value
             end
             @webuser.update_attributes(:segment=>0,:targets=>0,:property=>805)
             render "rtn805", :formats => :xml
           end
         end
        elsif @webuser!=nil && @webuser.property==802
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          @userassetsheet=User_asset_sheet.destroy_all(:username => @webuser.username,:asset_typeid => 203)
          assetproductvalue=0
          @fundquote=General_fund_quote.find_by_product_code(content[0])
          if @fundquote!=nil && @fundquote.today_value!=nil
            assetproductvalue=@fundquote.today_value*content[1].to_i
          end
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=203
            e.asset_product_value=assetproductvalue
            e.asset_value=assetproductvalue
            e.asset_product_code=content[0]
            e.asset_product_share=content[1]
            e.save
          end

          @webuser.update_attributes(:segment=>0,:targets=>0,:property=>8021)
          render "rtn8021", :formats => :xml
        elsif @webuser!=nil && @webuser.property==8021
          if params[:xml][:Content]!="0";
            content=params[:xml][:Content].gsub("，",",")
            content=content.split(",")
            @userassetsheet=User_asset_sheet.destroy_all(:username => @webuser.username,:asset_typeid => 203)
            assetproductvalue=0
            @fundquote=General_fund_quote.find_by_product_code(content[0])
            if @fundquote!=nil && @fundquote.today_value!=nil
              assetproductvalue=@fundquote.today_value*content[1].to_i
            end
            User_asset_sheet.new do |e|
              e.username=@webuser.username
              e.asset_typeid=203
              e.asset_product_value=assetproductvalue
              e.asset_value=assetproductvalue
              e.asset_product_code=content[0]
              e.asset_product_share=content[1]
              e.save
            end
            render "rtn8021", :formats => :xml
          else
            @userassetsheet=User_asset_sheet.find_all_by_username(@webuser.username)
            gupiao=0;
            for i in 0..@userassetsheet.size-1
              if @userassetsheet[i].asset_typeid==301
                gupiao=1
              end
            end
            if gupiao==1
              @webuser.update_attributes(:segment=>0,:targets=>0,:property=>803)
              render "rtn803", :formats => :xml
            else
              @userasset=User_asset_sheet.find_all_by_username(@webuser.username)
              @liudong=0
              @guding=0
              @zong=0
              for i in 0..@userasset.size-1
                value=0
                if @userasset[i].asset_product_value!=nil
                  value=@userasset[i].asset_product_value
                elsif @userasset[i].asset_value!=nil
                  value=@userasset[i].asset_value
                end
                if @hash1[@userasset[i].asset_typeid][1]==100
                  @liudong=@liudong+value
                elsif @hash1[@userasset[i].asset_typeid][1]==400
                  @guding=@guding+value
                end
                @zong=@zong+value
              end
              @webuser.update_attributes(:segment=>0,:targets=>0,:property=>805)
              render "rtn805", :formats => :xml
            end
          end
        elsif @webuser!=nil && @webuser.property==803
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          @userassetsheet=User_asset_sheet.destroy_all(:username => @webuser.username,:asset_typeid => 301)
            assetproductvalue=0
            @fundquote=General_fund_quote.find_by_product_code(content[0])
            if @fundquote!=nil && @fundquote.today_value!=nil
              assetproductvalue=@fundquote.today_value*content[1].to_i
            end
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=301
            e.asset_product_value=assetproductvalue
            e.asset_value=assetproductvalue
            e.asset_product_code=content[0]
            e.asset_product_share=content[1]
            e.save
          end

          @webuser.update_attributes(:segment=>0,:targets=>0,:property=>8031)
          render "rtn8031", :formats => :xml
        elsif @webuser!=nil && @webuser.property==8031
          if params[:xml][:Content]!="0";
            content=params[:xml][:Content].gsub("，",",")
            content=content.split(",")
            @userassetsheet=User_asset_sheet.destroy_all(:username => @webuser.username,:asset_typeid => 301)
            assetproductvalue=0
            @fundquote=General_fund_quote.find_by_product_code(content[0])
            if @fundquote!=nil && @fundquote.today_value!=nil
              assetproductvalue=@fundquote.today_value*content[1].to_i
            end
            User_asset_sheet.new do |e|
              e.username=@webuser.username
              e.asset_typeid=301
              e.asset_product_value=assetproductvalue
              e.asset_value=assetproductvalue
              e.asset_product_code=content[0]
              e.asset_product_share=content[1]
              e.save
            end
            render "rtn8031", :formats => :xml
          else
            @userasset=User_asset_sheet.find_all_by_username(@webuser.username)
            @liudong=0
            @guding=0
            @zong=0
            for i in 0..@userasset.size-1
              value=0
              if @userasset[i].asset_product_value!=nil
                value=@userasset[i].asset_product_value
              elsif @userasset[i].asset_value!=nil
                value=@userasset[i].asset_value
              end
              if @hash1[@userasset[i].asset_typeid][1]==100
                @liudong=@liudong+value
              elsif @hash1[@userasset[i].asset_typeid][1]==400
                @guding=@guding+value
              end
              @zong=@zong+value
            end
            @webuser.update_attributes(:segment=>0,:targets=>0,:property=>805)
            render "rtn805", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.property==805
          content=params[:xml][:Content]
          if content=="100"
            @webuser.update_attributes(:segment=>0,:targets=>0,:property=>800)
            render "rtn800", :formats => :xml
          elsif content=="200"
            @userasset=User_asset_sheet.find_all_by_username(@webuser.username)
            @webuser.update_attributes(:segment=>0,:targets=>0,:property=>806)
            render "rtn806", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.property==806
          content=params[:xml][:Content]
          if content.upcase=="M"
            @userasset=User_asset_sheet.find_all_by_username(@webuser.username)
            @webuser.update_attributes(:segment=>0,:targets=>0,:property=>807)
            render "rtn807", :formats => :xml
          elsif content.upcase=="A"
            @webuser.update_attributes(:segment=>0,:targets=>0,:property=>808)
            render "rtn808", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.property==807
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          @fundquote1=Monetary_fund_quote.find_by_product_code(content[1])
          @fundquote2=General_fund_quote.find_by_product_code(content[1])
          if @fundquote1!=nil
            @userasset=User_asset_sheet.find_by_username_and_asset_product_code(@webuser.username,content[1])
            if content[0]=="+"
              asset_value=0
              if @userasset!=nil && @userasset.asset_product_value!=nil
                asset_value=@userasset.asset_product_value+content[2].to_i
              elsif @userasset!=nil && @userasset.asset_value!=nil
                asset_value=@userasset.asset_value+content[2].to_i
              end
              if @userasset!=nil
                @userasset.update_attributes(:asset_product_value=>asset_value,:asset_value=>asset_value)
              end
            elsif content[0]=="-"
              asset_value=0
              if @userasset!=nil && @userasset.asset_product_value!=nil
                asset_value=@userasset.asset_product_value-content[2].to_i
              elsif @userasset!=nil && @userasset.asset_value!=nil
                asset_value=@userasset.asset_value-content[2].to_i
              end
              if @userasset!=nil
                @userasset.update_attributes(:asset_product_value=>asset_value,:asset_value=>asset_value)
              end
            end
          end
          if @fundquote2!=nil
            @userasset=User_asset_sheet.find_by_username_and_asset_product_code(@webuser.username,content[1])
            assetproductvalue=0
            if @fundquote2.today_value!=nil
              assetproductvalue=@fundquote2.today_value*content[2].to_i
            end
            if content[0]=="+"
              asset_value=0
              if @userasset!=nil && @userasset.asset_product_value!=nil
                asset_value=@userasset.asset_product_value+assetproductvalue
              elsif @userasset!=nil && @userasset.asset_value!=nil
                asset_value=@userasset.asset_value+assetproductvalue
              end
              if @userasset!=nil
                @userasset.update_attributes(:asset_product_value=>asset_value,:asset_value=>asset_value)
                if @userasset.asset_product_share!=nil
                  asset_product_share=@userasset.asset_product_share+content[2].to_i
                  @userasset.update_attributes(:asset_product_share=>asset_product_share)
                end
              end
            elsif content[0]=="-"
              asset_value=0
              if @userasset!=nil && @userasset.asset_product_value!=nil
                asset_value=@userasset.asset_product_value-assetproductvalue
              elsif @userasset!=nil && @userasset.asset_value!=nil
                asset_value=@userasset.asset_value-assetproductvalue
              end
              if @userasset!=nil
                @userasset.update_attributes(:asset_product_value=>asset_value,:asset_value=>asset_value)
                if @userasset.asset_product_share!=nil
                  asset_product_share=@userasset.asset_product_share-content[2].to_i
                  @userasset.update_attributes(:asset_product_share=>asset_product_share)
                end
              end
            end
          end
          @userasset=User_asset_sheet.find_all_by_username(@webuser.username)
          @webuser.update_attributes(:segment=>0,:targets=>0,:property=>806)
          render "rtn806", :formats => :xml
        elsif @webuser!=nil && @webuser.property==808
          content=params[:xml][:Content]
          if content=="102"
            @webuser.update_attributes(:segment=>0,:targets=>0,:property=>809)
            render "rtn809", :formats => :xml
          elsif content=="203"
            @webuser.update_attributes(:segment=>0,:targets=>0,:property=>810)
            render "rtn810", :formats => :xml
          elsif content=="301"
            @webuser.update_attributes(:segment=>0,:targets=>0,:property=>811)
            render "rtn811", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.property==809
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=102
            e.asset_product_value=content[1].to_i
            e.asset_value=content[1].to_i
            e.asset_product_code=content[0]
            e.save
          end
        elsif @webuser!=nil && @webuser.property==810
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          assetproductvalue=0
          @fundquote=General_fund_quote.find_by_product_code(content[0])
          if @fundquote!=nil && @fundquote.today_value!=nil
            assetproductvalue=@fundquote.today_value*content[1].to_i
          end
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=203
            e.asset_product_value=assetproductvalue
            e.asset_value=assetproductvalue
            e.asset_product_code=content[0]
            e.asset_product_share=content[1]
            e.save
          end
        elsif @webuser!=nil && @webuser.property==811
          content=params[:xml][:Content].gsub("，",",")
          content=content.split(",")
          assetproductvalue=0
          @fundquote=General_fund_quote.find_by_product_code(content[0])
          if @fundquote!=nil && @fundquote.today_value!=nil
            assetproductvalue=@fundquote.today_value*content[1].to_i
          end
          User_asset_sheet.new do |e|
            e.username=@webuser.username
            e.asset_typeid=301
            e.asset_product_value=assetproductvalue
            e.asset_value=assetproductvalue
            e.asset_product_code=content[0]
            e.asset_product_share=content[1]
            e.save
          end
        end
        if @webuser!=nil && @webuser.plan==900
          content=params[:xml][:Content]
          if content=="Y" || content=="y"
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>901)
            render "rtn901", :formats => :xml
          else
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>0)
          end
        elsif @webuser!=nil && @webuser.plan==901
          content=params[:xml][:Content]
          if content=="Y" || content=="y"
            @userdatamonth=Userdata_month.find_by_username(@webuser.username)
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>902)
            render "rtn902", :formats => :xml
          elsif content=="D" || content=="d"
            render "rtn9011", :formats => :xml
          elsif content=="N" || content=="n"
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>0)
          end
        elsif @webuser!=nil && @webuser.plan==902
          content=params[:xml][:Content]
          if content=="Y" || content=="y"
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>903)
            render "rtn903", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.plan==903
          content=params[:xml][:Content]
          if content=="Y" || content=="y"
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>904)
            render "rtn904", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.plan==904
          content=params[:xml][:Content]
          if content=="Y" || content=="y"
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>905)
            render "rtn905", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.plan==905
          content=params[:xml][:Content]
          if content=="A" || content=="a" || content=="B" || content=="b" || content=="C" || content=="c" || content.upcase=="AB" || content.upcase=="AC" || content.upcase=="BC" || content.upcase=="ABC"
            @webuser.update_attributes(:fluidselect1=>content)
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>906)
            render "rtn906", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.plan==906
          content=params[:xml][:Content]
          if content=="A" || content=="a" || content=="B" || content=="b" || content=="C" || content=="c" || content.upcase=="AB" || content.upcase=="AC" || content.upcase=="BC" || content.upcase=="ABC"
            @webuser.update_attributes(:fluidselect2=>content)
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>907)
            render "rtn907", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.plan==907
          content=params[:xml][:Content]
          if content=="A" || content=="a" || content=="B" || content=="b" || content=="C" || content=="c" || content.upcase=="AB" || content.upcase=="AC" || content.upcase=="BC" || content.upcase=="ABC"
            @webuser.update_attributes(:fluidselect3=>content)
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>908)
            render "rtn908", :formats => :xml
          elsif content=="D" || content=="d"
            render "rtn9071", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.plan==908
          content=params[:xml][:Content]
          if content=="A" || content=="a" || content=="B" || content=="b" || content=="C" || content=="c" || content.upcase=="AB" || content.upcase=="AC" || content.upcase=="BC" || content.upcase=="ABC"
            @webuser.update_attributes(:fluidselect4=>content)
            @fundproduct=Monetary_fund_product.all
            @hash909={}
            k=0
            for i in 0..@fundproduct.size-1
              num1=0
              num2=1
              num3=0
              num4=0
              if @fundproduct[i].min_purchase_account!=nil
                if @fundproduct[i].min_purchase_account>=0 && @fundproduct[i].min_purchase_account<=500
                  if @webuser.fluidselect1.upcase=="A" || @webuser.fluidselect1.upcase=="AB" || @webuser.fluidselect1.upcase=="AC" || @webuser.fluidselect1.upcase=="ABC"
                  num1=1
                 end
                end
                if @fundproduct[i].min_purchase_account>500 && @fundproduct[i].min_purchase_account<=1000
                  if @webuser.fluidselect1.upcase=="B" || @webuser.fluidselect1.upcase=="AB" || @webuser.fluidselect1.upcase=="BC" || @webuser.fluidselect1.upcase=="ABC"
                  num1=1
                 end
                end
                if @fundproduct[i].min_purchase_account>1000
                  if @webuser.fluidselect1.upcase=="C" || @webuser.fluidselect1.upcase=="AC" || @webuser.fluidselect1.upcase=="BC" || @webuser.fluidselect1.upcase=="ABC"
                  num1=1
                 end
                end
              end
              @fundquote=Monetary_fund_quote.find_by_product_code(@fundproduct[i].product_code)
              if @fundquote!=nil
                if @webuser.fluidselect2.upcase=="A" || @webuser.fluidselect2.upcase=="AB" || @webuser.fluidselect2.upcase=="AC" || @webuser.fluidselect2.upcase=="ABC"
                  if !(@fundquote.one_year_rank!=nil && @fundquote.one_year_rank.split("/")[0].to_i<=20)
                    num2=0
                  end
                end
                if @webuser.fluidselect2.upcase=="B" || @webuser.fluidselect2.upcase=="AB" || @webuser.fluidselect2.upcase=="BC" || @webuser.fluidselect2.upcase=="ABC"
                  if !(@fundquote.two_year_rank!=nil && @fundquote.two_year_rank.split("/")[0].to_i<=20)
                    num2=0
                  end
                end
                if @webuser.fluidselect2.upcase=="C" || @webuser.fluidselect2.upcase=="AC" || @webuser.fluidselect2.upcase=="BC" || @webuser.fluidselect2.upcase=="ABC"
                  if !(@fundquote.three_year_rank!=nil && @fundquote.three_year_rank.split("/")[0].to_i<=20)
                    num2=0
                  end
                end
              end
              if @fundproduct[i].fund_size!=nil
                if @fundproduct[i].fund_size>=0 && @fundproduct[i].fund_size<=1
                  if @webuser.fluidselect3.upcase=="A" || @webuser.fluidselect3.upcase=="AB" || @webuser.fluidselect3.upcase=="AC" || @webuser.fluidselect3.upcase=="ABC"
                    num3=1
                  end
                end
                if @fundproduct[i].fund_size>1 && @fundproduct[i].fund_size<=10
                  if @webuser.fluidselect3.upcase=="B" || @webuser.fluidselect3.upcase=="AB" || @webuser.fluidselect3.upcase=="BC" || @webuser.fluidselect3.upcase=="ABC"
                    num3=1
                  end
                end
                if @fundproduct[i].fund_size>10
                  if @webuser.fluidselect3.upcase=="C" || @webuser.fluidselect3.upcase=="AC" || @webuser.fluidselect3.upcase=="BC" || @webuser.fluidselect3.upcase=="ABC"
                    num3=1
                  end
                end
              end
              if @fundproduct[i].create_date!=nil
                t = Time.new
                date = t.strftime("%Y-%m-%d")
                fate=(DateTime.parse(date)-DateTime.parse(@fundproduct[i].create_date.to_s)).to_s.split("/")[0].to_i

                if fate<=365
                  if @webuser.fluidselect4.upcase=="A" || @webuser.fluidselect4.upcase=="AB" || @webuser.fluidselect4.upcase=="AC" || @webuser.fluidselect4.upcase=="ABC"
                    num4=1
                  end
                end
                if fate>365 && fate<=1095
                  if @webuser.fluidselect4.upcase=="B" || @webuser.fluidselect4.upcase=="AB" || @webuser.fluidselect4.upcase=="BC" || @webuser.fluidselect4.upcase=="ABC"
                    num4=1
                  end
                end
                if fate>1095
                  if @webuser.fluidselect4.upcase=="C" || @webuser.fluidselect4.upcase=="AC" || @webuser.fluidselect4.upcase=="BC" || @webuser.fluidselect4.upcase=="ABC"
                    num4=1
                  end
                end
              end
              if num1==1 && num2==1 && num3==1 && num4==1
                @hash909.store(k,[@fundproduct[i].product_code,@fundproduct[i].productname,@fundproduct[i].min_purchase_account,@fundproduct[i].fund_size,@fundproduct[i].create_date,@fundquote.one_year_rank,@fundquote.two_year_rank,@fundquote.three_year_rank])
                k=k+1
              end
            end
            if @hash909.size!=0
              @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>909)
              render "rtn909", :formats => :xml
            else
              @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>910)
              render "rtn910", :formats => :xml
            end
          elsif content=="D" || content=="d"
            render "rtn9081", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.plan==909
          content=params[:xml][:Content]
          @monetaryfundproduct=Monetary_fund_product.find_by_product_code(content)
          if @monetaryfundproduct!=nil
            @webuser.update_attributes(:fluid_productid=>@monetaryfundproduct.productname)
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>911)
            render "rtn911", :formats => :xml
          end
        elsif @webuser!=nil && @webuser.plan==910
          content=params[:xml][:Content]
          if content=="1000"
            @webuser.update_attributes(:segment=>0,:targets=>0,:plan=>905)
            render "rtn905", :formats => :xml
          end
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
