#encoding: utf-8
require 'date'
class MyaccountController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
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
