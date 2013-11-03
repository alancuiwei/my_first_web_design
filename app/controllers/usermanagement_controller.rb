#encoding: utf-8
class UsermanagementController < ApplicationController

  def login
    if params[:weixincode]!=nil
      @webuser=Webuser.find_by_weixincode(params[:weixincode])
      if @webuser!=nil && session[:webusername]==nil
        session[:webusername]=@webuser.username
      end
    end
  end

   def family_asset_table
     @hash={}
     @hash1={}
     @assettype=Admin_asset_type.all
     for i in 0..@assettype.size-1
       @hash1.store(@assettype[i].asset_typeid.to_i,[@assettype[i].asset_typename])
     end
     if session[:webusername]!=nil
       @userassetsheet=User_asset_sheet.find_all_by_username(session[:webusername])
       @total=0
       for i in 0..@userassetsheet.size-1
         @total=@total+@userassetsheet[i].asset_value
          if @userassetsheet[i].asset_product_code!=nil
            a=0
            @fundquote=Monetary_fund_quote.find_by_product_code(@userassetsheet[i].asset_product_code)       #million_income
            if @fundquote!=nil && @fundquote.million_income!=nil
              @hash.store(@userassetsheet[i].asset_typeid,[@fundquote.productname,@fundquote.million_income])
              a=1
            end
            @fundquote=General_fund_quote.find_by_product_code(@userassetsheet[i].asset_product_code)
            if @fundquote!=nil && @fundquote.today_value!=nil
              @hash.store(@userassetsheet[i].asset_typeid,[@fundquote.product_name,@fundquote.today_value])
              a=1
            end
            if a==0
              @hash.store(@userassetsheet[i].asset_typeid,[@hash1[@userassetsheet[i].asset_typeid][0],"-"])
            end
          else
            @hash.store(@userassetsheet[i].asset_typeid,[@hash1[@userassetsheet[i].asset_typeid][0],"-"])
          end
       end
     else
       redirect_to(:controller=>"usermanagement", :action=>"login", :familyassettable=>"1")
     end
   end
end