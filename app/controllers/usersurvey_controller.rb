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

  def dreamconfig
    @webuser=Webuser.find_by_username(params[:username])
    @personalfinance=Personalfinance.find_by_username(params[:username])

    @webuser.update_attributes(:dream=>params[:dream],:province=>params[:province],:city=>params[:city],
                               :amount=>params[:amount],:realizetime=>params[:realizetime],:monthpay=>params[:monthpay],:scharge=>params[:scharge],:remark=>params[:remark],:isauto=>0)
    if @personalfinance!=nil
      @personalfinance.update_attributes(:investamount=>params[:investamount])
    else
      Personalfinance.new do |w|
        w.username=params[:username]
        w.investamount=params[:investamount]
        w.save
      end
    end
    render :json => "s".to_json
  end
end
