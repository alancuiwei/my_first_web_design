#encoding: utf-8
require 'rexml/document'
#require 'rexml/streamlistener'
include REXML
#include StreamListener

class UsermanagementController < ApplicationController

def my_subscribe
  @pagetitle="订阅的策略"

  @webuser = Webuser.find(params[:id])
  @sub_stg=Array.new
  if @webuser!=nil
    if @webuser.subid!=nil
   @sub=@webuser.subid.split("|")
      if @sub!=nil
        for i in 0..@sub.size-1
          if @sub[i]!=nil
          @sub_stg[i]=Strategyweb.find_by_id(@sub[i])
          else
            break
          end
        end
      end
    end

  end
end

def params_set
  #session
   @webuser = Webuser.find_by_name(session[:webuser_name])
   #取得默认值
   @usercommodity=UsercommodityT.find_all_by_userid(session[:webuser_name])
  #
  @hash_commodityid=Hash["ag","白银","CF","棉花","ER","早籼稻","ME","甲醇","RO","菜籽油","SR","白糖","TA","精对苯二甲酸","WS","强麦",
       "WT","硬麦","PM","普麦","IF","股指","a","黄大豆","al","铝","au","黄金","b","黄豆二","c","玉米",
       "cu","铜","fu","燃料油","j","焦炭","l","聚乙烯","m","豆粕","p","棕榈油","pb","铅","rb","螺纹钢",
       "ru","橡胶","v","聚氯乙烯","wr","线材","y","豆油","zn","锌"]
   @hash_tradechargetype=Hash[0,"每手",1,"成交金额比例"]

    #xml读取操作
   @doc = Document.new(File.new('app/assets/xmls/commodity.xml'))
   @hash_exchtrademargin=Hash.new

  @hash_commodityidxml=Hash.new
  for i in 0..@usercommodity.size-1
    @hash_commodityidxml.store(@doc.elements.to_a("//commodityid")[i].text,@doc.elements.to_a("//exchtrademargin")[i].text.to_d)
  end

   for i in 0..@usercommodity.size-1
   @hash_exchtrademargin.store(@usercommodity[i].commodityid,@hash_commodityidxml[@usercommodity[i].commodityid]+@usercommodity[i].trademargingap.to_d)
   #@exchtrademargin[i]=@exchtrademargin[i].to_d
   #@exchtrademargin[i]=@exchtrademargin[i]+@usercommodity[i]
   end
end

  def  tradechargefast
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @commoditys=CommodityT.all()
    @usercommoditys=UsercommodityT.find_all_by_userid(@webuser.name)

    @hash_commoditys=Hash.new
    @commoditys.each do |commodity|
      @hash_commoditys.store(commodity.commodityid,commodity.exchtradecharge)
    end

    if  params[:tardecharge_0]!=nil
      @usercommoditys.each do |usercommodity|
        if usercommodity.tradechargetype==0
          usercommodity.tradecharge=@hash_commoditys[usercommodity.commodityid]+params[:tardecharge_0].to_f
          usercommodity.save
        end
      end
      render :json=>"s".to_json
    end
    if  params[:tardecharge_1]!=nil
      @usercommoditys.each do |usercommodity|
        if usercommodity.tradechargetype==1
          usercommodity.tradecharge=@hash_commoditys[usercommodity.commodityid]+params[:tardecharge_1].to_f/1000
          usercommodity.save
        end
      end
    end
  end

  def  trademarginfast
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @usercommoditys=UsercommodityT.find_all_by_userid(@webuser.name)
    if  params[:tardemargin]!=nil
      @usercommoditys.each do |usercommodity|
          usercommodity.trademargingap=params[:tardemargin].to_f/100
          usercommodity.save
        end
      render :json=>"s".to_json
    end
  end

  def collection
    @pagetitle="收藏的策略"
    @webuser = Webuser.find(params[:id])
    @collect_stg=Array.new
    if @webuser!=nil
      if @webuser.collect!=nil
     @collect=@webuser.collect.split("|")
        if @collect!=nil
          for i in 0..@collect.size-1
            if @collect[i]!=nil
            @collect_stg[i]=Strategyweb.find_by_id(@collect[i])
            else
              break
            end
          end
        end
      end

    end
  end
end