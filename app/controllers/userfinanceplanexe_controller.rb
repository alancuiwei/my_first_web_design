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
   if  session[:webusername]!=nil
     @webusers=Webuser.find_by_username(session[:webusername])
   else
     @webusers=Webuser.find_by_username('admin')
   end
   if  params[:id]!=nil
     @webuser=Webuser.find_by_id(params[:id])
     @userfinancedata=User_finance_data.find_by_username(@webuser.username)
     @userbalancesheet=User_balance_sheet.find_by_username(@webuser.username)
     @record=Record.find_all_by_username(@webuser.username)
     @userdatamonth=Userdata_month.find_by_username(@webuser.username)
     if @userfinancedata!=nil
       @finance1=Monetary_fund_product.find_by_productname(@userfinancedata.fluid_productid)
       if @finance1!=nil
         @category1=Admin_asset_type_l2.find_by_classify(@finance1.L2_typename)
       end
       @finance2=Financial.find_by_pname(@userfinancedata.safe_productid)
       if @finance2!=nil
         @category2=Admin_asset_type_l2.find_by_classify(@finance2.classify)
       end
       @finance3=Financial.find_by_pname(@userfinancedata.risk_productid)
       if @finance3!=nil
         @category3=Admin_asset_type_l2.find_by_classify(@finance3.classify)
       end
     end
     @examination=Examination.find_by_username(@webuser.username)
     @comments=Comments.find_all_by_pid(params[:id])
   elsif session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
     @userfinancedata=User_finance_data.find_by_username(@webuser.username)
     @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
     @record=Record.find_all_by_username(session[:webusername])
     @userdatamonth=Userdata_month.find_by_username(session[:webusername])
     if @userfinancedata!=nil
       @finance1=Monetary_fund_product.find_by_productname(@userfinancedata.fluid_productid)
       if @finance1!=nil
         @category1=Admin_asset_type_l2.find_by_classify(@finance1.L2_typename)
       end
       @finance2=Financial.find_by_pname(@userfinancedata.safe_productid)
       if @finance2!=nil
         @category2=Admin_asset_type_l2.find_by_classify(@finance2.classify)
       end
       @finance3=Financial.find_by_pname(@userfinancedata.risk_productid)
       if @finance3!=nil
         @category3=Admin_asset_type_l2.find_by_classify(@finance3.classify)
       end
     end
     @examination=Examination.find_by_username(@webuser.username)
     @comments=Comments.find_all_by_pid(@webuser.id)
   else
     redirect_to(:controller=>"usermanagement", :action=>"login", :p5s2=>"1")
   end
 end
end