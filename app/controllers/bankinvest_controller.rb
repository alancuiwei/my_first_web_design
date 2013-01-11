#encoding: utf-8
require 'date'
class BankinvestController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'

  def index
    @bankfinances=Bankfinance.all
    @client_ip=request.remote_ip
  end

  def specialfinance
    @specialfinances=Bankfinance.find_by_sql('select * from bankfinance where ispickout=1')
  end

  def secondpickout
  cookies[:bcolumn] = params[:bcolumn]
  cookies[:amount] = params[:amount]
  end

  def thirdpickout
    cookies[:deadline] = params[:deadline]
  end

  def fourthpickout
    @bankfinances=Bankfinance.all
    cookies[:optionsRadios] = params[:optionsRadios]
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
