#encoding: utf-8
class HomeController < ApplicationController
  def index
    @personinvestinfo=Personinvestinfo.all
    @username=Personalfinance.find_by_sql('select distinct username from personalfinance')
    @num=@username.length
  end
  def productindex
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
end
