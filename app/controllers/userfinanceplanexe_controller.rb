#encoding: utf-8
class UserfinanceplanexeController < ApplicationController
 def p5s1_current_asset_allocate
   if session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
     @userfinancedata=User_finance_data.find_by_username(@webuser.username)
     @assetsheet=User_asset_sheet.where(username:session[:webusername])
     @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
     @userplanedsheet=User_planed_balance_sheets.find_by_username(session[:webusername])
     @userfirstmove=User_firstmove_balance_sheets.find_by_username(session[:webusername])
     @assettype=Admin_asset_type.all
     @hash4={}
     for i in 0..@assettype.size-1
       @hash4.store(@assettype[i].asset_typeid.to_i,[@assettype[i].asset_typename,@assettype[i].asset_type_L1])
     end
   else
     redirect_to(:controller=>"usermanagement", :action=>"login", :p5s1=>"1")
   end
 end
 def p5s2_salary_allocate_month
   @blog=Blog.find_by_id(519)
   @assettype=Admin_asset_type.find_by_sql("select * from admin_asset_type where asset_typeid<>'401' and asset_typeid<>'402'")
   if session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
     @userplanmonth=User_plan_month.where(username:session[:webusername])
     @userfinancedata=User_finance_data.find_by_username(@webuser.username)
     @record=Record.where(username:session[:webusername])
     @hash2={}
     for i in 0..@record.size-1
       @asset=Admin_asset_type.find_by_asset_typename(@record[i].pname)
       if @asset!=nil
         @hash2.store(@record[i].id,[@asset.asset_type_L1])
       else
         @hash2.store(@record[i].id,[nil])
       end
     end
     @userdatamonth=Userdata_month.find_by_username(session[:webusername])
     @hash={}
     if @userfinancedata!=nil
       @fluidproduct=Monetary_fund_quote.find_by_productname(@userfinancedata.fluid_productid)
       @fluidproduct2=Fund_product.find_by_productname(@userfinancedata.fluid_productid)
       @category1=Admin_asset_type_l2.find_by_L2_typeid(101)
       if @fluidproduct!=nil
         if @fluidproduct2!=nil
           @hash.store('fluid',[@category1.id,@category1.classify,1,@fluidproduct.id,@fluidproduct2.buy_link])
         else
           @hash.store('fluid',[@category1.id,@category1.classify,1,@fluidproduct.id,'http://fund.fund123.cn/html/'+@fluidproduct.product_code+'/index.html'])
         end
       else
         @hash.store('fluid',[@category1.id,@category1.classify,0,nil,nil])
       end
       @category2=Admin_asset_type_l2.find_by_L2_typeid(201)
       @hash.store('safe',[@category2.id,@category2.classify])
       @riskproduct1=Monetary_fund_quote.find_by_productname(@userfinancedata.risk_productid)
       @riskproduct3=Fund_product.find_by_productname(@userfinancedata.risk_productid)
       @riskproduct2=General_fund_quote.find_by_product_name(@userfinancedata.risk_productid)
       @riskproduct4=General_fund_product.find_by_product_name(@userfinancedata.risk_productid)
       @riskproduct5=Banks_self_products.find_by_productname(@userfinancedata.risk_productid)
       if @riskproduct1!=nil
         @category3=Admin_asset_type_l2.find_by_L2_typeid(101)
         if @riskproduct3!=nil
           @hash.store('risk',[@category3.id,@category3.classify,1,@riskproduct1.id,@riskproduct3.buy_link])
         else
           @hash.store('risk',[@category3.id,@category3.classify,1,@riskproduct1.id,'http://fund.fund123.cn/html/'+@riskproduct1.product_code+'/index.html'])
         end
       elsif @riskproduct2!=nil
         @category3=Admin_asset_type_l2.find_by_L2_typeid(@riskproduct2.L2_typeid)
         if @riskproduct4!=nil
           @hash.store('risk',[@category3.id,@category3.classify,0,@riskproduct2.id,@riskproduct4.buy_link])
         else
           @hash.store('risk',[@category3.id,@category3.classify,0,@riskproduct2.id,'http://fund.fund123.cn/html/'+@riskproduct2.product_code+'/index.html'])
         end
       elsif @riskproduct5!=nil
         @category3=Admin_asset_type_l2.find_by_L2_typeid(@riskproduct5.L2_typeid)
         @hash.store('risk',[@category3.id,@category3.classify,2,@riskproduct5.id,nil])
       else
         @hash.store('risk',[nil,nil,-1,nil,nil])
       end
     else
       redirect_to(:controller=>"userfinanceplan", :action=>"p4s1_Emergency_fund")
     end
   else
     redirect_to(:controller=>"usermanagement", :action=>"login", :p5s2=>"1")
   end
 end
end