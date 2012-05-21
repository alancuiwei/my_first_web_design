#coding: utf-8
require 'rubygems'

class TradeinfoController < ApplicationController
  def todayinfo
    @alltodayinfo=TodayinfoT.all
    @hash_commodityid=Hash["ag","白银","CF","棉花","ER","早籼稻","ME","甲醇","RO","菜籽油","SR","白糖","TA","精对苯二甲酸","WS","强麦",
           "WT","硬麦","PM","普麦","IF","股指","a","黄大豆","al","铝","au","黄金","b","黄豆二","c","玉米",
           "cu","铜","fu","燃料油","j","焦炭","l","聚乙烯","m","豆粕","p","棕榈油","pb","铅","rb","螺纹钢",
           "ru","橡胶","v","聚氯乙烯","wr","线材","y","豆油","zn","锌"]
    @usercommoditys=UsercommodityT.find_all_by_userid("tester1")

    @hash_todayinfo=Hash.new
    @alltodayinfo.each do |alltodayinfo|
      @hash_todayinfo.store(alltodayinfo.contractid,[alltodayinfo.exchname,alltodayinfo.margin,alltodayinfo.updownlimit])
    end

    #if alltodayinfo.contractid.slice(1,1).to_i==0
    #  @commodityid=alltodayinfo.contractid.slice(0,2)
    #else
    #  @commodityid=alltodayinfo.contractid.slice(0,1)
   # end
    @hash_usercommodity=Hash.new
    @usercommoditys.each do |usercommodity|
      @hash_usercommodity.store(usercommodity.commodityid,[usercommodity.tradecharge,usercommodity.lendrate])
    end
    @hashkeys=Array.new
    @todayinfo_hashkeys=@hash_todayinfo.keys
    # @todayinfostr=""
   #File.open("C:\\Sites\\27843651\\app\\assets\\images\\todayinfo.html", "r") do |file|  
    #  file.each_line do |line|  
    #      @todayinfostr+=line  
   #  end  
  #  end 
  # redirect_to("/assets/todayinfo.html")
  end 

end
