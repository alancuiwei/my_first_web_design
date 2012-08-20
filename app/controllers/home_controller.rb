#encoding: utf-8
class HomeController < ApplicationController

  def oldpassword
    @webuser=Webuser.find_by_name(session[:webuser_name])
    if Webuser.authenticate(session[:webuser_name], params[:oldpassword])
      @webuser.update_attribute(:hashed_password,Webuser.encrypt_password(params[:password], @webuser.salt))
      render :json=>"s".to_json
    else
      render :json=>"f".to_json
    end
  end
  def index
    #UserMailer.forgetpassword("feifan_5223@163.com",1,1).deliver
    @versions=Versionstable.find(:all, :order =>"update_date DESC",:limit => 3)
    @versions_all=Versionstable.find(:all, :order =>"update_date DESC")
    if params[:name]!=nil
      if Webuser.authenticate(params[:name], params[:password])
        session[:webuser_name] =params[:name]
          render :json =>params[:name].to_json
      else
        @test='您的用户名或者密码输入错误！'.to_json
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
