#encoding: utf-8
class UserfinanceplanController < ApplicationController

  def p4s1_Emergency_fund
    @blog=Blog.find_by_id(111)
    if session[:webusername]!=nil
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
      @userassetsheet=User_asset_sheet.find_all_by_username(session[:webusername])
      @userbanlance=User_balance_sheet.find_by_username(session[:webusername])
      @userplanedbalance=User_planed_balance_sheets.find_by_username(session[:webusername])
      @averagereturnrate=Average_return_rate.find_by_typeid_and_years(101,1)
      @array=[0,0,0,0]
      for i in 0..@userassetsheet.size-1
        if @userassetsheet[i].asset_typeid==101
          @array[0]=@array[0]+@userassetsheet[i].asset_value
        end
        if @userassetsheet[i].asset_typeid==102
          @array[2]=@array[2]+@userassetsheet[i].asset_value
        end
      end
      @hash={}
      if @userplanedbalance!=nil && @userplanedbalance.asset_planed_fluid_account!=nil
        @array[1]=@userplanedbalance.asset_planed_fluid_account/3
        @array[3]=@userplanedbalance.asset_planed_fluid_account*2/3
        @hash.store(0,[@userplanedbalance.asset_planed_fluid_account])
      else
        @hash.store(0,[0])
      end
      @hash1={}
      @hash2={}
      if @array[0]>=@array[1] && @array[2]>=@array[3]
        @hash1.store(0,[0])
        @hash2.store(0,[@array[3]-@array[2]])
        for i in 1..@userplanmonth.size-1
          @hash1.store(i,[0])
          @hash2.store(i,[0])
        end
      end
      if @array[0]<@array[1] && @array[2]<@array[3]
        xianjin=@array[1]-@array[0]
        huobi=@array[3]-@array[2]
        for i in 0..@userplanmonth.size-1
           if @userplanmonth[i].fluid_account>0
              if huobi>0
                 if huobi>@userplanmonth[i].fluid_account
                   @hash1.store(i,[0])
                   @hash2.store(i,[@userplanmonth[i].fluid_account/100*100])
                   huobi=huobi-@userplanmonth[i].fluid_account
                 else
                   @hash1.store(i,[@userplanmonth[i].fluid_account-huobi])
                   @hash2.store(i,[huobi/100*100])
                   huobi=0
                   xianjin=xianjin-(@userplanmonth[i].fluid_account-huobi)
                 end
              else
                @hash1.store(i,[@userplanmonth[i].fluid_account])
                @hash2.store(i,[0])
                huobi=0
                xianjin=xianjin-@userplanmonth[i].fluid_account
              end
           else
             @hash1.store(i,[0])
             @hash2.store(i,[0])
           end
        end
      end
      if @array[0]>=@array[1] && @array[2]<@array[3]
        xianjin=0
        huobi=@array[3]-@array[2]
        for i in 0..@userplanmonth.size-1
          if @userplanmonth[i].fluid_account>0
            if huobi>0
              @hash1.store(i,[0])
              @hash2.store(i,[@userplanmonth[i].fluid_account/100*100])
              huobi=huobi-@userplanmonth[i].fluid_account
            else
              @hash1.store(i,[0])
              @hash2.store(i,[0])
              huobi=0
            end
          else
            @hash1.store(i,[0])
            @hash2.store(i,[huobi/100*100])
            huobi=0
          end
        end
      end
      if @array[0]<@array[1] && @array[2]>=@array[3]
        xianjin=@array[1]-@array[0]
        huobi=0
        for i in 0..@userplanmonth.size-1
          if @userplanmonth[i].fluid_account>0
            if xianjin>0
              @hash1.store(i,[@userplanmonth[i].fluid_account])
              if i==0
                @hash2.store(i,[@array[3]-@array[2]])
              else
                @hash2.store(i,[0])
              end
              xianjin=xianjin-@userplanmonth[i].fluid_account
            else
              @hash1.store(i,[0])
              if i==0
                @hash2.store(i,[@array[3]-@array[2]])
              else
                @hash2.store(i,[0])
              end
              xianjin=0
            end
          else
            @hash1.store(i,[xianjin])
            if i==0
              @hash2.store(i,[@array[3]-@array[2]])
            else
              @hash2.store(i,[0])
            end
            xianjin=0
          end
        end
      end
      @link=1
      for i in 0..@userplanmonth.size-1
       if @hash1[i][0]>0 || @hash2[i][0]>0
         @link=0
       end
      end
      for i in 1..14
        if @userplanedbalance!=nil && @userplanedbalance.asset_planed_fluid_account!=nil && @averagereturnrate!=nil && @averagereturnrate.average_return_rate!=nil
          @hash.store(i,[(@hash[i-1][0]*(1+@averagereturnrate.average_return_rate/100)).to_i])
        else
          @hash.store(i,[0])
        end
      end
      t = Time.new
      @date = t.strftime("%Y")
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4s1=>"1")
    end
  end

  def p4s1_Emergency_fund_selection
    @blog=Blog.find_by_id(469)
    @blog2=Blog.find_by_id(472)
    @blog3=Blog.find_by_id(467)
    @blog4=Blog.find_by_id(468)
    if session[:webusername]!=nil
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @monetary=Monetary_fund_quote.all
      @hash={}
      for i in 0..@monetary.size-1
        @fundproduct=Monetary_fund_product.find_by_product_code(@monetary[i].product_code)
        t = Time.new
        date = t.strftime("%Y-%m-%d")
        if @fundproduct!=nil
          if @fundproduct.create_date!=nil
            @hash.store(@monetary[i].product_code,[@fundproduct.min_purchase_account,@fundproduct.fund_size,@fundproduct.create_date,DateTime.parse(date)-DateTime.parse(@fundproduct.create_date.to_s)])
          else
            @hash.store(@monetary[i].product_code,[@fundproduct.min_purchase_account,@fundproduct.fund_size,@fundproduct.create_date,nil])
          end
        else
          @hash.store(@monetary[i].product_code,[nil,nil,nil,nil])
        end
      end
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4s1selection=>"1")
    end
  end

  def savefluid
    @userfinancedata=User_finance_data.find_by_username(params[:username])
    if @userfinancedata!=nil
      @userfinancedata.update_attributes(:fluid_productid=>params[:fluid_productid])
    else
      User_finance_data.new do |u|
        u.username=params[:username]
        u.fluid_productid=params[:fluid_productid]
        u.save
      end
    end
    render :json => "s".to_json
  end

  def p4s2_highprofit_fund
    @blog=Blog.find_by_id(111)
    if session[:webusername]!=nil
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
      @userplanedbalance=User_planed_balance_sheets.find_by_username(session[:webusername])
      @userbanlance=User_balance_sheet.find_by_username(session[:webusername])
      @userfirstmove=User_firstmove_balance_sheets.find_by_username(session[:webusername])
      @averagereturnrate=Average_return_rate.find_by_typeid_and_years(101,1)
      @hash={}
      t = Time.new
      @date = t.strftime("%Y")
      @month = t.strftime("%m")
      if @userfirstmove!=nil && @userfirstmove.asset_firstmove_risky_account!=nil
        firstyear=@userfirstmove.asset_firstmove_risky_account
      end
      for i in (@month.to_i+1)..12
        @userplan=User_plan_month.find_by_username_and_date(session[:webusername],@date+'.'+i.to_s)
        if @userplan!=nil
          firstyear=firstyear+@userplan.risky_account
        end
      end
      if @userfirstmove!=nil && @userfirstmove.asset_firstmove_risky_account!=nil
        @hash.store(0,[(firstyear*1.1).to_i])
      else
        @hash.store(0,[0])
      end
      capital=0
      for i in 0..@userplanmonth.size-2
        capital=capital+@userplanmonth[i].risky_account
      end
      for i in 1..14
        if @userfirstmove!=nil && @userfirstmove.asset_firstmove_risky_account!=nil
          @hash.store(i,[(@hash[i-1][0]*1.1+capital).to_i])
        else
          @hash.store(i,[0])
        end
      end
      @link=1
      for i in 0..@userplanmonth.size-1
        if @userplanmonth[i].risky_account>0
          @link=0
        end
      end
      t = Time.new
      @date = t.strftime("%Y")
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4s2=>"1")
    end
  end

  def p4s2_highprofit_fund_selection
    @blog3=Blog.find_by_id(467)
    @blog4=Blog.find_by_id(468)
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @userfinancedata=User_finance_data.find_by_username(@webuser.username)

    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4s2selection=>"1")
    end
    @category1=Admin_asset_type_l2.find_all_by_risklevel(1)
    @category2=Admin_asset_type_l2.find_all_by_risklevel(2)
    @category3=Admin_asset_type_l2.find_all_by_risklevel(3)
    @category4=Admin_asset_type_l2.find_all_by_risklevel(4)
    @category5=Admin_asset_type_l2.find_all_by_risklevel(5)
    @hash={}
    @hash2={}
    @category=Admin_asset_type_l2.all
    for i in 0..@category.size-1
      loss1='--';loss3='--';max1='--';max3='--';avg1='--';avg3='--';
      @loss=Loss_probability.find_by_typeid_and_years(@category[i].L2_typeid,1)
      if @loss!=nil
        loss1=@loss.probability.round(3)
      end
      @loss=Loss_probability.find_by_typeid_and_years(@category[i].L2_typeid,3)
      if @loss!=nil
        loss3=@loss.probability.round(3)
      end
      @max=Max_return_rate.find_by_typeid_and_years(@category[i].L2_typeid,1)
      if @max!=nil
        max1=@max.returnrate
      end
      @max=Max_return_rate.find_by_typeid_and_years(@category[i].L2_typeid,3)
      if @max!=nil
        max3=@max.returnrate
      end
      @ave=Average_return_rate.find_by_typeid_and_years(@category[i].L2_typeid,1)
      if @ave!=nil
        avg1=@ave.average_return_rate.round(2)
      end
      @ave=Average_return_rate.find_by_typeid_and_years(@category[i].L2_typeid,3)
      if @ave!=nil
        avg3=@ave.average_return_rate.round(2)
      end

      @hash2.store(@category[i].L2_typeid,[@category[i].classify,loss1,loss3,max1,max3,avg1,avg3])
      @hash.store(i,[@category[i].id,@category[i].classify])
    end
    @fundproduct=Monetary_fund_product.all

    @hash3={}
    @hash5={}
    for i in 0..@fundproduct.size-1
      @average=Average_return_rate.find_by_typeid_and_years(@fundproduct[i].productid,1)
      if @average!=nil
        f1=@average.average_return_rate
      else
        f1=''
      end
      @rank=Rank.find_by_productid_and_years(@fundproduct[i].productid,1)
      if @rank!=nil
        f2=@rank.rank_num
        f3=@rank.total_num
      else
        f2=''
        f3=''
      end
      @quote=Monetary_fund_quote.find_by_product_code(@fundproduct[i].product_code)
      t = Time.new
      date = t.strftime("%Y-%m-%d")
      if @quote!=nil
        if @fundproduct[i].create_date!=nil
          @hash5.store(@fundproduct[i].product_code,[@quote.date,@quote.million_income,@quote.sevenD_years_return,@quote.one_year_return,@quote.two_year_return,@quote.three_year_return,@quote.one_year_rank,@quote.two_year_rank,@quote.three_year_rank,DateTime.parse(date)-DateTime.parse(@fundproduct[i].create_date.to_s)])
        else
          @hash5.store(@fundproduct[i].product_code,[@quote.date,@quote.million_income,@quote.sevenD_years_return,@quote.one_year_return,@quote.two_year_return,@quote.three_year_return,@quote.one_year_rank,@quote.two_year_rank,@quote.three_year_rank,nil])
        end
      else
        if @fundproduct[i].create_date!=nil
          @hash5.store(@fundproduct[i].product_code,[nil,nil,nil,nil,nil,nil,nil,nil,nil,DateTime.parse(date)-DateTime.parse(@fundproduct[i].create_date.to_s)])
        else
          @hash5.store(@fundproduct[i].product_code,[nil,nil,nil,nil,nil,nil,nil,nil,nil,nil])
        end
      end
      @hash3.store(@fundproduct[i].productid,[f1,f2,f3])
    end
    @hash6={}
    @monetaryfundquote=Monetary_fund_quote.all
    t = Time.new
    date = t.strftime("%Y-%m-%d")
    for i in 0..@monetaryfundquote.size-1
      @product=Monetary_fund_product.find_by_product_code(@monetaryfundquote[i].product_code)
      if @product!=nil
        if @product.create_date!=nil
          @hash6.store(@monetaryfundquote[i].product_code,[@product.min_purchase_account,DateTime.parse(date)-DateTime.parse(@product.create_date.to_s),@product.fund_size])
        else
          @hash6.store(@monetaryfundquote[i].product_code,[@product.min_purchase_account,nil,@product.fund_size])
        end
      else
        @hash6.store(@monetaryfundquote[i].product_code,[nil,nil,nil])
      end
    end
    @generalfundquote=General_fund_quote.all
    for i in 0..@generalfundquote.size-1
      @product=General_fund_product.find_by_product_code(@generalfundquote[i].product_code)
      if @product!=nil
        if @product.date!=nil
          @hash6.store(@generalfundquote[i].product_code,[1000,DateTime.parse(date)-DateTime.parse(@product.date.to_s),@product.fund_size])
        else
          @hash6.store(@generalfundquote[i].product_code,[1000,nil,@product.fund_size])
        end
      else
        @hash6.store(@generalfundquote[i].product_code,[nil,nil,nil])
      end
    end
  end

  def saverisk
    @userfinancedata=User_finance_data.find_by_username(params[:username])
    if @userfinancedata!=nil
      @userfinancedata.update_attributes(:risk_productid=>params[:risk_productid])
    else
      User_finance_data.new do |u|
        u.username=params[:username]
        u.risk_productid=params[:risk_productid]
        u.save
      end
    end
    render :json => "s".to_json
  end

  def p4s3_stableprofit_fund
    @blog=Blog.find_by_id(442)
    if session[:webusername]!=nil
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
      @userfirstmove=User_firstmove_balance_sheets.find_by_username(session[:webusername])
      @userplanedbalance=User_planed_balance_sheets.find_by_username(session[:webusername])
      @userbanlance=User_balance_sheet.find_by_username(session[:webusername])
      t = Time.new
      @date = t.strftime("%Y")
      @month = t.strftime("%m")
      @hash={}
      if @userfirstmove!=nil && @userfirstmove.asset_firstmove_safety_account!=nil && @userplanedbalance!=nil && @userplanedbalance.asset_planed_safety_account!=nil
       if @userplanedbalance.asset_planed_safety_account>@userfirstmove.asset_firstmove_safety_account
        @hash.store(0,[(1.03*(@userfirstmove.asset_firstmove_safety_account+(12-@month.to_i)*(@userplanedbalance.asset_planed_safety_account-@userfirstmove.asset_firstmove_safety_account)/12)).to_i])
       else
         @hash.store(0,[(1.03*@userfirstmove.asset_firstmove_safety_account).to_i])
       end
      else
        @hash.store(0,[0])
      end
      for i in 1..14
        if @userfirstmove!=nil && @userfirstmove.asset_firstmove_safety_account!=nil && @userplanedbalance!=nil && @userplanedbalance.asset_planed_safety_account!=nil && @userplanedbalance.asset_planed_safety_account>@userfirstmove.asset_firstmove_safety_account
          @hash.store(i,[(1.03*(@hash[i-1][0])+(@userplanedbalance.asset_planed_safety_account-@userfirstmove.asset_firstmove_safety_account)).to_i])
        else
          @hash.store(i,[(1.03*@hash[i-1][0]).to_i])
        end
      end
      @averagereturnrate=Average_return_rate.find_by_typeid_and_years(101,1)
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4s3=>"1")
    end
  end

  def p4s4_invest_estimate_plan
    if session[:webusername]!=nil
      @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
      @userbanlance=User_balance_sheet.find_by_username(session[:webusername])
      @asset_account=0
      @asset_fixed_account=0
      if @userbanlance!=nil
        @asset_account=@userbanlance.asset_fluid_account+@userbanlance.asset_risky_account+@userbanlance.asset_safefy_account
        @asset_fixed_account=@userbanlance.asset_account-@asset_account
      end

      @totalfluid=0
      @totalrisky=0
      @totalsafety=0
      for i in 0..@userplanmonth.size-1
        @totalfluid=@totalfluid+@userplanmonth[i].fluid_account
        @totalrisky=@totalrisky+@userplanmonth[i].risky_account
        @totalsafety=@totalsafety+@userplanmonth[i].safety_account
      end
     # @total=@totalfluid+@totalrisky+@totalsafety
      @date =["当前","一年后","两年后","三年后","四年后","五年后","六年后","七年后","八年后","九年后","十年后","十一年后","十二年后","十三年后","十四年后","十五年后"]
      @userassetsheet=User_asset_sheet.find_all_by_username(session[:webusername])
      @userplanedbalance=User_planed_balance_sheets.find_by_username(session[:webusername])
      @array=[0,0,0,0]
      for i in 0..@userassetsheet.size-1
        if @userassetsheet[i].asset_typeid==101
          @array[0]=@array[0]+@userassetsheet[i].asset_value
        end
        if @userassetsheet[i].asset_typeid==102
          @array[2]=@array[2]+@userassetsheet[i].asset_value
        end
      end
      @hash={}
      if @userplanedbalance!=nil && @userplanedbalance.asset_planed_fluid_account!=nil
        @array[1]=@userplanedbalance.asset_planed_fluid_account/3
        @array[3]=@userplanedbalance.asset_planed_fluid_account*2/3
        @hash.store(0,[@userplanedbalance.asset_planed_fluid_account])
      else
        @hash.store(0,[0])
      end
      @hash1={}
      @hash2={}
      if @array[0]>=@array[1] && @array[2]>=@array[3]
        @hash1.store(i,[0])
        @hash2.store(0,[@array[3]-@array[2]])
        for i in 1..@userplanmonth.size-1
          @hash1.store(i,[0])
          @hash2.store(i,[0])
        end
      end
      if @array[0]<@array[1] && @array[2]<@array[3]
        xianjin=@array[1]-@array[0]
        huobi=@array[3]-@array[2]
        for i in 0..@userplanmonth.size-1
          if @userplanmonth[i].fluid_account>0
            if huobi>0
              if huobi>@userplanmonth[i].fluid_account
                @hash1.store(i,[0])
                @hash2.store(i,[@userplanmonth[i].fluid_account/100*100])
                huobi=huobi-@userplanmonth[i].fluid_account
              else
                @hash1.store(i,[@userplanmonth[i].fluid_account-huobi])
                @hash2.store(i,[huobi/100*100])
                huobi=0
                xianjin=xianjin-(@userplanmonth[i].fluid_account-huobi)
              end
            else
              @hash1.store(i,[@userplanmonth[i].fluid_account])
              @hash2.store(i,[0])
              huobi=0
              xianjin=xianjin-@userplanmonth[i].fluid_account
            end
          else
            @hash1.store(i,[0])
            @hash2.store(i,[0])
          end
        end
      end
      if @array[0]>=@array[1] && @array[2]<@array[3]
        xianjin=0
        huobi=@array[3]-@array[2]
        for i in 0..@userplanmonth.size-1
          if @userplanmonth[i].fluid_account>0
            if huobi>0
              @hash1.store(i,[0])
              @hash2.store(i,[@userplanmonth[i].fluid_account/100*100])
              huobi=huobi-@userplanmonth[i].fluid_account
            else
              @hash1.store(i,[0])
              @hash2.store(i,[0])
              huobi=0
            end
          else
            @hash1.store(i,[0])
            @hash2.store(i,[huobi/100*100])
            huobi=0
          end
        end
      end
      if @array[0]<@array[1] && @array[2]>=@array[3]
        xianjin=@array[1]-@array[0]
        huobi=0
        for i in 0..@userplanmonth.size-1
          if @userplanmonth[i].fluid_account>0
            if xianjin>0
              @hash1.store(i,[@userplanmonth[i].fluid_account])
              if i==0
                @hash2.store(i,[@array[3]-@array[2]])
              else
                @hash2.store(i,[0])
              end
              xianjin=xianjin-@userplanmonth[i].fluid_account
            else
              @hash1.store(i,[0])
              if i==0
                @hash2.store(i,[@array[3]-@array[2]])
              else
                @hash2.store(i,[0])
              end
              xianjin=0
            end
          else
            @hash1.store(i,[xianjin])
            if i==0
              @hash2.store(i,[@array[3]-@array[2]])
            else
              @hash2.store(i,[0])
            end
            xianjin=0
          end
        end
      end
      @totalhuobi=0
      for i in 0..@userplanmonth.size-1
        @totalhuobi=@totalhuobi+@hash2[i][0]
      end
      @total=@totalhuobi+@totalrisky+@totalsafety
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4s4=>"1")
    end
  end

  def p4_user_finance_plan_report
    if session[:webusername]!=nil
      @targets=User_targets.find_by_username(session[:webusername])
      @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
      @userbanlance=User_balance_sheet.find_by_username(session[:webusername])
      @asset_account=0
      if @userbanlance!=nil
        @asset_account=@userbanlance.asset_fluid_account+@userbanlance.asset_risky_account+@userbanlance.asset_safefy_account
      end
      t = Time.new
      @date = t.strftime("%Y")
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4=>"1")
    end
    if @webuser!=nil
    end
  end

end