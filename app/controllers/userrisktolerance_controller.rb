#encoding: utf-8
class UserrisktoleranceController < ApplicationController
   def p3_userrisktolerance
       if session[:webusername]!=nil
         @webuser=Webuser.find_by_username(session[:webusername])
         @blog=Blog.find_by_id(461)
       else
         redirect_to(:controller=>"usermanagement", :action=>"login", :p3_userrisk=>"1")
       end
   end

  def p3steps
    if params[:fromusername]!=nil
      @webuser=Webuser.find_by_weixincode(params[:fromusername])
      if @webuser!=nil
        session[:webusername]=@webuser.username
      end
    end
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @assetsheet=User_asset_sheet.find_by_username(session[:webusername])
      @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @risk=User_risktolerance_qa.find_all_by_username(session[:webusername])
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :p3steps=>"1")
    end
  end

 def p3_risktolerence_report
   @blog=Blog.find_by_id(461)
   if session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
        else
     redirect_to(:controller=>"usermanagement", :action=>"login", :p3report=>"1")
        end
   @risktype=Admin_risktolerance_type.all
  end
end