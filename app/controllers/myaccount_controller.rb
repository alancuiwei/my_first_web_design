#encoding: utf-8
require 'date'
class MyaccountController < ApplicationController
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
    period=@webuser.period
        @remind={}
        @confirm={}
        for i in 0..@funds.size-1
          if @hash_interest[@funds[i].ordernum]!=nil
            paydate= (Date.parse(@hash_interest[@funds[i].ordernum][0])>>period)
            if (paydate-Date.today)> 0
              @remind.store(paydate.to_s,[@funds[i].ordernum,@funds[i].recordvalue])
            else
              while (paydate-Date.today)< 0

                @confirm.store(paydate.to_s,[@funds[i].ordernum,@funds[i].recordvalue])
                paydate=paydate>>period

              end
            end

          else
            paydate= (Date.parse(@funds[i].date.to_s)>>period)
            if (paydate-Date.today)> 0
              @remind.store(paydate.to_s,[@funds[i].ordernum,@funds[i].recordvalue])
            else
              while (paydate-Date.today)< 0

                @confirm.store(paydate.to_s,[@funds[i].ordernum,@funds[i].recordvalue])
                paydate=paydate>>period

              end
            end
          end

        end

      end
  end

    end
