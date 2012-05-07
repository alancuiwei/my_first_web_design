class AdminController < ApplicationController
#  before_filter :authenticate

  def index
  @webuser = Webuser.find_by_name(session[:webuser_name])
   if @webuser.name!="administrator"
     redirect_to(:controller=>"usermanagement", :action=>"index")
   end
  end

  def usrctr
  end
  def strctr
  end

  protected

#  def authenticate
#    authenticate_or_request_with_http_basic do |username,password|
#      username == "admin" && password == "admin"
#    end

#  end

end
