#encoding: utf-8
require 'date'
class ProductsController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
  def index
    @product=Product.find_by_id(params[:id])

    @invest_f=Investrecord.find_all_by_recordtype("fund")
    @invest_i=Investrecord.find_all_by_recordtype("interest")
    piefunds={}
    @pie={}
    @webusers=Webuser.all
    @webusers.each do |w|
      piefunds.store(w.username,[Investrecord.find_all_by_username_and_recordtype(w.username,"fund")])
    end
    for i in 0..@webusers.size-1

      userfund=piefunds[@webusers[i].username][0]
      pie=0
      for j in 0..userfund.size-1
        pie=pie+userfund[j].recordvalue
      end
      @pie.store(@webusers[i].username,pie)
    end
    @funds=0
    @invest_f.each do |i|
      @funds=@funds+i.recordvalue
    end
    @interest=0
    @invest_i.each do |i|
      @interest=@interest+i.recordvalue
    end

    @diffdate=Date.today-Date.parse("2012-5-1")

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
