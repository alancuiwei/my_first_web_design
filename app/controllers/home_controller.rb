#encoding: utf-8
class HomeController < ApplicationController
  def index
    @versions=Versionstable.find(:all, :order =>"update_date DESC",:limit => 3)
    @versions_all=Versionstable.find(:all, :order =>"update_date DESC")
    if params[:name]!=nil
      if Webuser.authenticate(params[:name], params[:password])
        session[:webuser_name] =params[:name]
          render :json =>params[:name].to_json
      else
        @test='用户名或者密码错误！'.to_json
      render :json => @test
  end
    end

    if params[:regedit_name]!=nil
      if  params[:regedit_name]==""
        puts params[:regedit_name]
        render :json=>'用户名为空！'.to_json
      elsif  params[:regedit_email]==""
          render :json=>'电子邮箱为空！'.to_json
      elsif  params[:regedit_password]==""
          render :json=>'密码为空！'.to_json
      elsif  params[:regedit_password_confirmation]==""
            render :json=>'密码确认为空！'.to_json
      elsif  params[:regedit_password_confirmation]!=params[:regedit_password]
            render :json=>'密码不一致！'.to_json
      elsif /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.match(params[:regedit_email])==nil
        render :json=>'请输入正确的电子邮箱！'.to_json
      elsif Webuser.find_by_name(params[:regedit_name])!=nil
        render :json=>'用户名已注册！'.to_json
      elsif  Webuser.find_by_email(params[:regedit_email])!=nil
        render :json=>'电子邮箱已注册！'.to_json
      else
        Webuser.new do |w|
          w.name=params[:regedit_name]
          w.email=params[:regedit_email]
          w.salt=Webuser.object_id.to_s + rand.to_s
          w.hashed_password=Webuser.encrypt_password(params[:regedit_password], w.salt)
          w.level=0
          w.save
        end
        StrategyparamT.new do |s|
          s.strategyid="010001"
          s.paramname="returnrate"
          s.paramvalue=0.1
          s.username=params[:regedit_name]
          s.save
        end
        #new usercommodiy
        @usercommodity=UsercommodityT.find_all_by_userid("tester1")
        i=0
        while @usercommodity[i]!=nil
        UsercommodityT.new do |u|
         u.commodityid = @usercommodity[i].commodityid
         u.userid=params[:regedit_name]
         u.tradechargetype=@usercommodity[i].tradechargetype
         u.tradecharge=@usercommodity[i].tradecharge
         u.deliverchargebyunit=@usercommodity[i].deliverchargebyunit
         u.deliverchargebyhand=@usercommodity[i].deliverchargebyhand
         u.futuretocurrenchargebyunit=@usercommodity[i].futuretocurrenchargebyunit
         u.futuretocurrenchargebyhand=@usercommodity[i].futuretocurrenchargebyhand
         u.lendrate=@usercommodity[i].lendrate
         u.trademargingap=@usercommodity[i].trademargingap
         u.save
         i=i+1
        end
        end
        session[:webuser_name] =params[:regedit_name]
        render :json=>params[:regedit_name].to_json
      end
    end

    if params[:logout]!=nil
      session[:webuser_name] =nil
      render :json=>params[:logout].to_json
    end

  end

  def comingsoon
  end
end
