#encoding: utf-8
require 'rexml/document'
#require 'rexml/streamlistener'
include REXML
#include StreamListener

class UsermanagementController < ApplicationController
def index
  @webuser = Webuser.find_by_name(session[:webuser_name])
  if @webuser==nil
   redirect_to :controller=>"sessions" ,:action=>"new"
   end
  @flag=0
end
def trademanageindex
   @webuser = Webuser.find_by_name(session[:webuser_name])
end
def usertradecharge
  $commodity_form=0
  #session
   @webuser = Webuser.find_by_name(session[:webuser_name])
   #取得默认值
   @usercommodity=UsercommodityT.find_all_by_userid(session[:webuser_name])
  #
  @hash_commodityid=Hash["CF","棉花","ER","早籼稻","ME","甲醇","RO","菜籽油","SR","白糖","TA","精对苯二甲酸","WS","强麦",
       "WT","硬麦","PM","普麦","IF","股指","a","黄大豆","al","铝","au","黄金","b","黄豆二","c","玉米",
       "cu","铜","fu","燃料油","j","焦炭","l","聚乙烯","m","豆粕","p","棕榈油","pb","铅","rb","螺纹钢",
       "ru","橡胶","v","聚氯乙烯","wr","线材","y","豆油","zn","锌"]
   @hash_tradechargetype=Hash[0,"每手",1,"成交金额比例"]
end
def userlendrate
  #session
   @webuser = Webuser.find_by_name(session[:webuser_name])
   #取得默认值
   @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
   #params[:lendrate_p]=@usercommodity[0].lendrate

   if  params[:lendrate_p]!=nil
   @usercommodity.each do |usercommodity_t|
     usercommodity_t.lendrate=params[:lendrate_p]
     usercommodity_t.lendrate=usercommodity_t.lendrate/100
     usercommodity_t.save
   end
    redirect_to :controller=>"usercommodity_ts" ,:action=>"showlr", :id=>@usercommodity[1].id
   end
end

def usertrademargin
  @hash_commodityid=Hash["CF","棉花","ER","早籼稻","ME","甲醇","RO","菜籽油","SR","白糖","TA","精对苯二甲酸","WS","强麦",
       "WT","硬麦","PM","普麦","IF","股指","a","黄大豆","al","铝","au","黄金","b","黄豆二","c","玉米",
       "cu","铜","fu","燃料油","j","焦炭","l","聚乙烯","m","豆粕","p","棕榈油","pb","铅","rb","螺纹钢",
       "ru","橡胶","v","聚氯乙烯","wr","线材","y","豆油","zn","锌"]
  $commodity_form=1
  #session
   @webuser = Webuser.find_by_name(session[:webuser_name])
   #取得默认值
   @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)

  #xml读取操作
   @doc = Document.new(File.new('public/commodity.xml'))
   @exchtrademargin=Array.new
   @commodityid=Array.new
   for i in 0..@usercommodity.size-1
   @commodityid[i] = @doc.elements.to_a("//commodityid")[i].text
   @exchtrademargin[i] = @doc.elements.to_a("//exchtrademargin")[i].text.to_d+@usercommodity[i].trademargingap.to_d
   #@exchtrademargin[i]=@exchtrademargin[i].to_d
   #@exchtrademargin[i]=@exchtrademargin[i]+@usercommodity[i]
   end
end

end