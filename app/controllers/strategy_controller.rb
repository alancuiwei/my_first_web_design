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

    #default => no session
    default=Array.new
    @defaultcommodity=UsercommodityT.find_all_by_userid("tester1")
    for i in 0..@defaultcommodity.size-1 do
      default[i]=@defaultcommodity[i].tradecharge
    end

    session[:userflag]=0
    #初始化
    session[:num]=0
    session[:usercommodityid]=default
    session[:usertradecharge]=default
    #user
    if @webuser!=nil
    session[:userflag]=1
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)

    user_tradecharge=Array.new
    user_commodityid=Array.new
    #重组数组
    useredit_commodityid=Array.new
    usertc_session=Array.new
    userci_session=Array.new

   for i in 0..@usercommodity.size-1 do
      user_tradecharge[i]=@usercommodity[i].tradecharge
      user_commodityid[i]=@usercommodity[i].commodityid
   end

    for i in 0..@usercommodity.size-1 do
      useredit_commodityid[i]=-1
          if( user_tradecharge[i]!=default[i])
            useredit_commodityid[i]=user_commodityid[i]
          end
    end

    j=0
    for i in 0..@usercommodity.size-1 do

          if(useredit_commodityid[i]!=-1)
            userci_session[j]=useredit_commodityid[i]
            usertc_session[j]=user_tradecharge[i]
            j=j+1
          end
    end
    session[:num]=j
    session[:usercommodityid]=userci_session
    session[:usertradecharge]=usertc_session

    end #end if

  end

  def intronorisk
  end

end
