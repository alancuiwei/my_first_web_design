class UsermanagementController < ApplicationController
def index
   @webuser = Webuser.find_by_name(session[:webuser_name])
  @flag=0
end
def usertradecharge
  #session
   @webuser = Webuser.find_by_name(session[:webuser_name])
   #取得默认值
   @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)

end

end