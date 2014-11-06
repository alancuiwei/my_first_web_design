class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers

#  before_filter :authorize
#  protect_from_forgery
  protected
#	def authorize
#		unless Webuser.find_by_id(session[:webuser_id])
#		redirect_to login_url, :notice => "Please Log in!"
#		end
#	end
end
