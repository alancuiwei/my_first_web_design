#encoding: utf-8
class SessionsController < ApplicationController
  def new
  end

  def create
	if webuser = Webuser.authenticate(params[:name], params[:password])
     @url=request.fullpath
	   if webuser.name=="feifan"
		session[:webuser_name] = webuser.name
		redirect_to(:controller=>"admin", :action=>"index")
	  else
		session[:webuser_name] = webuser.name
    if $login==1
      redirect_to(:controller=>"strategy", :action=>"show",:id=>1)
    else
      redirect_to(:controller=>"usermanagement", :action=>"index")
    end
	  end
	else
		redirect_to login_url, :alert =>"用户名或密码错误！"
	end
  end

  def destroy
	session[:webuser_id] = nil
	session[:webuser_name] = nil
	redirect_to login_url, :notice =>"Logged out"
  end
end
