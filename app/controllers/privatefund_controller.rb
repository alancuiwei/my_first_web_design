#encoding: utf-8
require 'date'
class PrivatefundController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
  Date::DATE_FORMATS[:cstamp] = '%Y年%m月%d日'
  def index
    @product=Product.find_by_id(params[:id])
    @pdescription=[]
    @pdescriptions=[]
    if @product.description!=nil
      @pdescription=@product.description.split("|")
    end
    if @product.descriptions!=nil
      @pdescriptions=@product.descriptions.split("|")
    end
    @invest_f=Investrecord.find_all_by_recordtype_and_pname("fund",@product.pname)
    @invest_i=Investrecord.find_all_by_recordtype_and_pname("interest",@product.pname)
    piefunds={}
    @pie={}
    @webusers=Webuser.all
    @webusers.each do |w|
      piefunds.store(w.username,[Investrecord.find_all_by_username_and_recordtype_and_pname(w.username,"fund",@product.pname)])
    end
    for i in 0..@webusers.size-1

      userfund=piefunds[@webusers[i].username][0]
      pie=0
      for j in 0..userfund.size-1
        pie=pie+userfund[j].recordvalue
      end
      if pie!=0
        @pie.store(@webusers[i].username,pie)
      end
    end
    @funds=0
    @invest_f.each do |i|
      @funds=@funds+i.recordvalue
    end
    @interest=0
    @invest_i.each do |i|
      @interest=@interest+i.recordvalue
    end

    lastdate=Productrecord.find(:all,:conditions =>["pname=?",@product.pname],:order =>"date DESC")[0]
    if lastdate!=nil
      @diffdate=lastdate.date-@product.founddate
    else
      @diffdate=Date.today-@product.founddate
    end
    interests=Investrecord.find_all_by_recordtype_and_pname_and_date("interest",@product.pname,@product.date)
    if interests==nil
      @dividend=0
    else
      @dividend=0
      interests.each do |i|
        @dividend=@dividend+i.recordvalue
      end
    end

    @invest_date=Investrecord.find(:all,:conditions =>["pname=? and recordtype=?",@product.pname,"interest"],:order =>"date ASC")
    @interestdate={}
    if @invest_date[0]!=nil
      date=Date.parse(@invest_date[0].date.to_s)
      datevalue=0

      for i in 0..@invest_date.size-1
        if date==Date.parse(@invest_date[i].date.to_s)
          datevalue=datevalue+@invest_date[i].recordvalue
        else
          @interestdate.store(date,datevalue)
          date=Date.parse(@invest_date[i].date.to_s)
          datevalue=@invest_date[i].recordvalue
        end
      end
      @interestdate.store(date,datevalue)
    end
  end

  def precordajax
    @product=Product.find_by_id(params[:id])
    @precords=Productrecord.find(:all,:conditions =>["pname=?",@product.pname],:order =>"date ASC")
    recordjson=[]
    for i in 0..@precords.size-1
      recordjson[i]=[]
      recordjson[i][0]=DateTime.strptime(@precords[i].date.to_s,"%Y-%m-%d").to_i*1000
      recordjson[i][1]=@precords[i].total
    end
    render :json => recordjson
  end

  def report

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
