#encoding: utf-8
class SessionsController < ApplicationController
  def new
  end

  def create
	if webuser = Webuser.authenticate(params[:name], params[:password])
     @url=request.fullpath
	   if webuser.name=="administrator"
		session[:webuser_name] = webuser.name
		redirect_to(:controller=>"admin", :action=>"index")
	  else
		session[:webuser_name] = webuser.name
    if session[:login]=="shownorisk"
      redirect_to(:controller=>"strategy", :action=>"shownorisk")
    elsif session[:login]=="personaltrading"
      redirect_to(:controller=>"autotrade", :action=>"personaltrading")
    elsif session[:login]="autotrade_s1"
      redirect_to(:controller=>"autotrade", :action=>"autotrade_s1",:id=>Strategyweb.find_by_name("无风险套利").id)
    elsif session[:login]=="userrateofreturn"
      redirect_to(:controller=>"autotrade", :action=>"personaltrading")
    elsif session[:login]=="usermanagement"
      redirect_to(:controller=>"usermanagement", :action=>"index")
    else
      redirect_to(:controller=>"usermanagement", :action=>"index")
    end
	  end
	else
    if request.post?
      if params[:commit]!=nil
		redirect_to login_url, :alert =>"用户名或密码错误！"
      else
        redirect_to login_url
      end
    else
      redirect_to login_url, :alert =>"用户名或密码错误！"
    end

	end
  end

  def destroy
	session[:webuser_id] = nil
	session[:webuser_name] = nil
	redirect_to login_url, :notice =>"Logged out"
  end
end
