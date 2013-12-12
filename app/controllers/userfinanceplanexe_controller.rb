#encoding: utf-8
class UserfinanceplanexeController < ApplicationController
 def p5s1_current_asset_allocate
   if session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
     @userfinancedata=User_finance_data.find_by_username(@webuser.username)
     @assetsheet=User_asset_sheet.find_all_by_username(session[:webusername])
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
     @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
     @userfinancedata=User_finance_data.find_by_username(@webuser.username)
     @record=Record.find_all_by_username(session[:webusername])
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
       @category1=Admin_asset_type_l2.find_by_L2_typeid(101)
       if @fluidproduct!=nil
         @hash.store('fluid',[@category1.id,@category1.classify,1,@fluidproduct.id])
       else
         @hash.store('fluid',[@category1.id,@category1.classify,0,nil])
       end
       @category2=Admin_asset_type_l2.find_by_L2_typeid(201)
         @hash.store('safe',[@category2.id,@category2.classify])
       @riskproduct1=Monetary_fund_quote.find_by_productname(@userfinancedata.risk_productid)
       @riskproduct2=General_fund_quote.find_by_product_name(@userfinancedata.risk_productid)
       if @riskproduct1!=nil
         @category3=Admin_asset_type_l2.find_by_L2_typeid(101)
         @hash.store('risk',[@category3.id,@category3.classify,1,@riskproduct1.id])
       elsif @riskproduct2!=nil
         @category3=Admin_asset_type_l2.find_by_L2_typeid(@riskproduct2.L2_typeid)
         @hash.store('risk',[@category3.id,@category3.classify,0,@riskproduct2.id])
       else
         @hash.store('risk',[nil,nil,-1,nil])
       end
     end
   else
     redirect_to(:controller=>"usermanagement", :action=>"login", :p5s2=>"1")
   end
 end
end