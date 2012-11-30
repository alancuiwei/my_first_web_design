#encoding: utf-8
require 'date'
class ProductsController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
  def index
    @product=Product.find_by_id(params[:id])

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

    @diffdate=Productrecord.find(:all,:conditions =>["pname=?",@product.pname],:order =>"date DESC")[0].date-@product.founddate

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
    date=Date.parse(@invest_date[0].date.to_s)
    datevalue=0
    @interestdate={}
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

end
