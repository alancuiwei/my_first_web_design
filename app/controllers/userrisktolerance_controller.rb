#encoding: utf-8
class UserrisktoleranceController < ApplicationController
   def p3_userrisktolerance
       if session[:webusername]!=nil
         @webuser=Webuser.find_by_username(session[:webusername])
         @blog=Blog.find_by_id(461)
       else
         redirect_to(:controller=>"sales", :action=>"login", :p3_userrisk=>"1")
       end
   end

  def p3s1
    @blog=Blog.find_by_id(461)
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @assetsheet=User_asset_sheet.find_by_username(session[:webusername])
      @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @risk=User_risktolerance_qa.find_all_by_username(session[:webusername])
    else
      redirect_to(:controller=>"sales", :action=>"login", :p1_usersurvey=>"1")
    end
    @risktype=Admin_risktolerance_type.all
    @category1=Admin_asset_type_l2.find_all_by_risklevel(1)
    @category2=Admin_asset_type_l2.find_all_by_risklevel(2)
    @category3=Admin_asset_type_l2.find_all_by_risklevel(3)
    @category4=Admin_asset_type_l2.find_all_by_risklevel(4)
    @category5=Admin_asset_type_l2.find_all_by_risklevel(5)
    @hash={}
    @category=Admin_asset_type_l2.all
    for i in 0..@category.size-1
      @financial=Financial.find_all_by_classify(@category[i].classify)
      a=''
      for j in 0..@financial.size-1
        if j==0
          a=@financial[j].id
        else
          a=a.to_s+','+@financial[j].id.to_s
        end
      end
      @hash.store(i,[@category[i].id,@category[i].classify,a])
    end
    @financial2=Financial.all
  end
end