class SessionsController < ApplicationController
  def new
  end

  def create
	if webuser = Webuser.authenticate(params[:name], params[:password])
		session[:webuser_name] = webuser.name
    uri = session[:original_uri]
    session[:original_uri] = nil
    if uri then
      redirect_to uri
    else
      redirect_to webuserstrategies_url
    end
#		redirect_to {uri||webuserstrategies_url}
#		redirect_to webuserstrategies_url
	else
		redirect_to login_url, :alert =>"Invalid user/password combination"
	end
  end

  def destroy
	session[:webuser_id] = nil
	session[:webuser_name] = nil
	redirect_to login_url, :notice =>"Logged out"
  end
end
