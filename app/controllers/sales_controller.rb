#encoding: utf-8
class SalesController < ApplicationController
  def index
    if session[:webusername]=="admin"
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
      else
        @webuser=Webuser.find_by_username(session[:webusername])
  end
    else
      @webuser=Webuser.find_by_username(session[:webusername])
      @banfinance=Bankfinance.find_by_id(params[:bid])
    end
  end

  def myorder
    if session[:webusername]!="admin"
      @reserve=Reserve.find_all_by_username(session[:webusername])
    end
  end
end