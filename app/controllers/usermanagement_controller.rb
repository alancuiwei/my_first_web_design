require 'rexml/document'
#require 'rexml/streamlistener'
include REXML
#include StreamListener

class UsermanagementController < ApplicationController
def index
   @webuser = Webuser.find_by_name(session[:webuser_name])
  @flag=0
end
def usertradecharge
  $commodity_form=0
  #session
   @webuser = Webuser.find_by_name(session[:webuser_name])
   #取得默认值
   @usercommodity=UsercommodityT.find_all_by_userid(session[:webuser_name])

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
     usercommodity_t.save
   end
   end
end

def usertrademargin
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