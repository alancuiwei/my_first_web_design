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
   @financial=Financial.all
   @assettype=Admin_asset_type.all
   if session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
     @userplanmonth=User_plan_month.find_all_by_username(session[:webusername])
     @userfinancedata=User_finance_data.find_by_username(@webuser.username)
     @record=Record.find_all_by_username(session[:webusername])
     @userdatamonth=Userdata_month.find_by_username(session[:webusername])
     @hash={}
     if @userfinancedata!=nil
       @fluidproduct=Monetary_fund_product.find_by_productname(@userfinancedata.fluid_productid)
       if @fluidproduct!=nil
         @category1=Admin_asset_type_l2.find_by_L2_typeid(101)
         @hash.store('fluid',[@fluidproduct.productname,@category1.id,@category1.classify,1,@fluidproduct.id])
       else
         @hash.store('fluid',[nil,nil,nil,0,nil])
       end
       @safeproduct=Financial.find_by_pname(@userfinancedata.safe_productid)
       if @safeproduct!=nil
         @category2=Admin_asset_type_l2.find_by_classify(@safeproduct.classify)
         @hash.store('safe',[@safeproduct.pname,@category2.id,@category2.classify])
       else
         @hash.store('safe',[nil,nil,nil])
       end
       @riskproduct1=Monetary_fund_quote.find_by_productname(@userfinancedata.risk_productid)
       @riskproduct2=General_fund_quote.find_by_product_name(@userfinancedata.risk_productid)
       if @riskproduct1!=nil
         @category3=Admin_asset_type_l2.find_by_L2_typeid(101)
         @hash.store('risk',[@riskproduct1.productname,@category3.id,@category3.classify,1,@riskproduct1.id])
       elsif @riskproduct2!=nil
         @category3=Admin_asset_type_l2.find_by_L2_typeid(@riskproduct2.L2_typeid)
         @hash.store('risk',[@riskproduct2.product_name,@category3.id,@category3.classify,0,nil])
       else
         @hash.store('risk',[nil,nil,nil,0,nil])
       end
     end
   else
     redirect_to(:controller=>"usermanagement", :action=>"login", :p5s2=>"1")
   end
 end
end