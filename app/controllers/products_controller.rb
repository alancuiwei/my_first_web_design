require 'date'
class ProductsController < ApplicationController
  def index
    @product=Product.find_by_id(params[:id])

    @invest_f=Investrecord.find_all_by_pid_and_recordtype(params[:id],"fund")
    @invest_i=Investrecord.find_all_by_pid_and_recordtype(params[:id],"interest")
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
