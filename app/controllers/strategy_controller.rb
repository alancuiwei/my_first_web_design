#encoding: utf-8
require 'rubygems'

class StrategyController < ApplicationController
  $login=1
  def index
    respond_to do |format|
      format.html
#      format.json { render json: @strategywebs }
    end
  end

#  def show
#    respond_to do |format|
#      format.html
#    end
#  end

  def shownorisk

    @webuser = Webuser.find_by_name(session[:webuser_name])

    #default from db
    @defaultdb_commodityid=Array.new
    @defaultdb_lendrate=Array.new
    @defaultdb_tradecharge=Array.new
    @defaultdb_trademargingap=Array.new
    @defaultusercommodity=UsercommodityT.find_all_by_userid("tester1")
    for i in 0..@defaultusercommodity.size-1 do
      @defaultdb_tradecharge[i]=@defaultusercommodity[i].tradecharge
      @defaultdb_commodityid[i]= @defaultusercommodity[i].commodityid
      @defaultdb_lendrate[i]=@defaultusercommodity[i].lendrate
      @defaultdb_trademargingap[i] = @defaultusercommodity[i].trademargingap
    end
    @defaultdb_num=@defaultusercommodity.size

    #login flag
    @userflag=0

    #for default 初始化
    #just for chargetrade edit
    @userchange_commodityid=Array.new
    @userchange_tradecharge=Array.new
    @userdb_commodityid=Array.new
    @userdb_lendrate=Array.new
    @userdb_trademargingap=Array.new
    @userdb_num=0
    @tradechargechange_num=0

    #user from db
    if @webuser!=nil
      #login
      @userflag=1
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)

    user_tradecharge=Array.new
    #重组数组
      #change tradecharge commodityid
    useredit_commodityid=Array.new

      #get all form db
   for i in 0..@usercommodity.size-1 do
      user_tradecharge[i]=@usercommodity[i].tradecharge
        @userdb_commodityid[i]=@usercommodity[i].commodityid
        @userdb_lendrate[i]=@usercommodity[i].lendrate
        @userdb_trademargingap[i]=@usercommodity[i].trademargingap
   end
      #user db size num
      @userdb_num=@usercommodity.size

    for i in 0..@usercommodity.size-1 do
      useredit_commodityid[i]=-1
        if( user_tradecharge[i]!=@defaultdb_tradecharge[i])
          useredit_commodityid[i]=@userdb_commodityid[i]
          end
    end

    j=0
    for i in 0..@usercommodity.size-1 do
          if(useredit_commodityid[i]!=-1)
          @userchange_commodityid[j]=useredit_commodityid[i]
          @userchange_tradecharge[j]=user_tradecharge[i]
            j=j+1
          end
    end
      @tradechargechange_num=j
    end #end if

  end

  def intronorisk
  end

  def maxreturnrate
    @allmaxreturnrate=ArbcostmaxreturnrateV.all
  end
  
  def todayinfo
    @alltodayinfo=TodayinfoT.all
    @hash_commodityid=Hash["CF","棉花","ER","早籼稻","ME","甲醇","RO","菜籽油","SR","白糖","TA","精对苯二甲酸","WS","强麦",
           "WT","硬麦","PM","普麦","IF","股指","a","黄大豆","al","铝","au","黄金","b","黄豆二","c","玉米",
           "cu","铜","fu","燃料油","j","焦炭","l","聚乙烯","m","豆粕","p","棕榈油","pb","铅","rb","螺纹钢",
           "ru","橡胶","v","聚氯乙烯","wr","线材","y","豆油","zn","锌"]
    # @todayinfostr=""
   #File.open("C:\\Sites\\27843651\\app\\assets\\images\\todayinfo.html", "r") do |file|  
    #  file.each_line do |line|  
    #      @todayinfostr+=line  
   #  end  
  #  end 
  # redirect_to("/assets/todayinfo.html")
  end 

end
