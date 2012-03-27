class UsermanagementController < ApplicationController
def index
   @webuser = Webuser.find_by_name(session[:webuser_name])
end
end