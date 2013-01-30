#encoding: utf-8
class SalesController < ApplicationController
  def index
    @banfinance=Bankfinance.find_by_id(params[:bid])
    if @banfinance==nil
      redirect_to(:controller=>"bankinvest", :action=>"index")
    end
    if session[:webusername]=="admin"
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
      else
        @webuser=Webuser.find_by_username(session[:webusername])
  end
    else
      @webuser=Webuser.find_by_username(session[:webusername])
    end
    end

  def myorder
    if session[:webusername]!="admin"
      @reserve=Reserve.find_all_by_username(session[:webusername])
    end
  end

  def confirm
    @banfinance=Bankfinance.find_by_id(params[:bid])
  end
end