#encoding: utf-8
require 'rexml/document'
#require 'rexml/streamlistener'
include REXML
#include StreamListener

class UsercommodityTsController < ApplicationController
layout 'usermanagement'

  def showtc
    @usercommodity_t = UsercommodityT.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
  end

  def showtm
    @usercommodity_t = UsercommodityT.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
  end

  def showlr
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
   end

def edittc
  @usercommodity_t = UsercommodityT.find(params[:id])
  @webuser = Webuser.find_by_name(session[:webuser_name])

  if  params[:tradecharge_p]!=nil
    @usercommodity_t.update_attribute(:tradecharge,params[:tradecharge_p].to_f)
   redirect_to :controller=>"usercommodity_ts" ,:action=>"showtc" ,:id=>params[:id]
  end

  end

def edittm
    @usercommodity_t = UsercommodityT.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
   #xml读取操作
   @doc = Document.new(File.new('public/commodity.xml'))
   @exchtrademargin=Array.new
   @commodityid=Array.new
   for i in 0..@usercommodity.size-1
   @commodityid[i] = @doc.elements.to_a("//commodityid")[i].text
   @exchtrademargin[i] = @doc.elements.to_a("//exchtrademargin")[i].text
   end

    for i in 0..@usercommodity.size-1
       if @commodityid[i]==@usercommodity_t.commodityid
         @usernum=i
         break
       end
    end

  if  params[:trademargingap_p]!=nil
    params[:trademargingap_p]=params[:trademargingap_p].to_f/100-session[:exchtrademargin].to_f
    @usercommodity_t.update_attribute(:trademargingap,params[:trademargingap_p])
   redirect_to :controller=>"usercommodity_ts" ,:action=>"showtm" ,:id=>params[:id]
  end
  end

def editlr
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
    redirect_to :controller=>"usercommodity_ts" ,:action=>"showlr", :id=>@usercommodity[0].id
    end
  end

end
