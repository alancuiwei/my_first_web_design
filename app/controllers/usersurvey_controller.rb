#encoding: utf-8
class UsersurveyController < ApplicationController
  def userinfo
    if params[:id]!=nil
       @webuser=Webuser.find_by_id(params[:id])
       if @webuser==nil
         redirect_to(:controller=>"admin", :action=>"index")
       else
         @personalfinance=Personalfinance.find_by_username(@webuser.username)
         if @personalfinance==nil
            @person=1
         end
       end
    else
      redirect_to(:controller=>"admin", :action=>"index")
    end
  end

  def freeapply
    if session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
    else
     @webuser=Webuser.find_by_username("admin")
    end
  end
end
