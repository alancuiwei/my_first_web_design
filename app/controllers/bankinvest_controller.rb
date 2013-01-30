#encoding: utf-8
require 'date'
class BankinvestController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'

  def compare
    @compareid=session[:compareid].split("|")
    @compareid.delete("")
    for i in 0..@compareid.size-1
        for j in i+1..@compareid.size-1
            if  @compareid[i]==@compareid[j]
              @compareid.delete_at(j)
            end
        end
    end
    @compareobj=[]
    for i in 0..@compareid.size-1
      @compareobj[i]= Bankfinance.find(@compareid[i]);
    end
  end
  def comparesession
    if params[:comparenum]=='0'
      session[:compareid]=""
    end
    if params[:type]=="deleteid"
      session[:compareid]=session[:compareid].gsub(params[:compareid],"")
      else
     session[:compareid]=session[:compareid]+"|"+params[:compareid]
    end
     render :json => "s".to_json
  end
  def index
    @bankfinances=Bankfinance.all
  end

  def specialfinance
    @specialfinances=Bankfinance.find_by_sql('select * from bankfinance where ispickout=1')
  end

  def secondpickout
  cookies[:bcolumn] = params[:bcolumn]
  if  params[:amounts] != nil
    cookies[:amount] = params[:amounts]
  else
  cookies[:amount] = params[:amount]
  end
  end

  def thirdpickout
    cookies[:deadline] = params[:deadline]
  end

  def fourthpickout
    @bankfinances=Bankfinance.all
    cookies[:optionsRadios] = params[:optionsRadios]
    if @bankfinances==nil
      redirect_to(:controller=>"bankinvest", :action=>"fourthpickout")
    end
  end

  def investrecord

    if session[:webusername]=="admin"
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
      else
        @webuser=Webuser.find_by_username(session[:webusername])
      end
    else
      @webuser=Webuser.find_by_username(session[:webusername])
    end

    if @webuser!=nil
      @products=Product.all
      @product=Product.find_by_id(@products[0].id)

      @username=@webuser.username
      @funds=Investrecord.find(:all,:conditions =>["username=? and recordtype=?",@username,"fund"],:order =>"date DESC")
      @interests=Investrecord.find(:all,:conditions =>["username=? and recordtype=?",@username,"interest"],:order =>"date ASC")
      @hash_interest={}
      @interests.each do |i|
        @hash_interest.store(i.ordernum,[i.date.to_s(:db),i.recordvalue])
      end

      @allfund=0
      @funds.each do |f|
        @allfund=@allfund+f.recordvalue
      end
      @allinterest=0
      @interests.each do |i|
        @allinterest=@allinterest+i.recordvalue
      end
      @allinvest=@allfund+@allinterest

    end
  end

end
