#encoding: utf-8
class UserfinanceplanController < ApplicationController

  def p4s1_Emergency_fund
    @blog=Blog.find_by_id(111)
    if session[:webusername]!=nil
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
      @fluidaccountsum=0
      for i in 0..@userplanmonth.size-1
        @fluidaccountsum=@fluidaccountsum+@userplanmonth[i].fluid_account
      end
      @averagereturnrate=Average_return_rate.find_by_typeid_and_years(101,1)
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
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4s2=>"1")
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

  def p4s3_stableprofit_fund
    @blog=Blog.find_by_id(442)
    if session[:webusername]!=nil
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
      @safetyaccountsum=0
      for i in 0..@userplanmonth.size-1
        @safetyaccountsum=@safetyaccountsum+@userplanmonth[i].safety_account
      end
      @hash={}
      @hash.store(0,[(1.03*@safetyaccountsum).to_i])
      for i in 1..14
        @hash.store(i,[(1.03*(@hash[i-1][0]+@safetyaccountsum)).to_i])
      end

      @averagereturnrate=Average_return_rate.find_by_typeid_and_years(101,1)
      t = Time.new
      @date = t.strftime("%Y")
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p4s3=>"1")
    end
  end

end