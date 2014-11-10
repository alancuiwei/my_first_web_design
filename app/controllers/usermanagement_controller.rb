#encoding: utf-8
class UsermanagementController < ApplicationController

  def login
    if params[:weixincode]!=nil
      @webuser=Webuser.find_by_sql("select * from webuser where weixincode like '%"+params[:weixincode]+"%'")
      if @webuser.size>0 && session[:webusername]==nil
        @webuser=Webuser.find_by_username(@webuser[0].username)
        session[:webusername]=@webuser.username
      else
        @webuser=nil
      end
    end
  end

  def getpassword
    @webuser=Webuser.find_by_username(params[:username])
    if  @webuser==nil
      render :json => "s".to_json
    else
      password=decode(@webuser.password)
      password2=encode(params[:password2])
      if params[:password]!=password
        render :json => "s1".to_json
      else
        @webuser.update_attributes(:password=>password2)
        render :json => "s2".to_json
      end
    end
  end

  def personalinfo
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @targets=User_targets.find_by_username(@webuser.username)
      @userfinancedata=User_finance_data.find_by_username(@webuser.username)
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :personalinfo=>"1")
    end
  end

  def family_asset_table
    t = Time.new
    @date = t.strftime("%Y-%m-%d")
     @hash={}
     @hash1={}
     @assettype=Admin_asset_type.all
     for i in 0..@assettype.size-1
       @hash1.store(@assettype[i].asset_typeid.to_i,[@assettype[i].asset_typename])
     end
    if session[:webusername]!=nil || params[:username]!=nil
      if params[:username]!=nil
        @webuser=Webuser.find_by_username(params[:username])
      else
        @webuser=Webuser.find_by_username(session[:webusername])
      end
      if @webuser!=nil
        @userassetdaily=User_assets_daily.where(username:@webuser.username)
        @userfinancedata=User_finance_data.find_by_username(@webuser.username)
        @userbalancesheet=User_balance_sheet.find_by_username(@webuser.username)
        @targets=User_targets.find_by_username(@webuser.username)
        @userasset=User_asset_sheet.where(username:@webuser.username)
        @userassetsheet=User_asset_sheet.find_by_sql("select * from user_asset_sheet where username='"+@webuser.username+"' and asset_typeid<>401 && asset_typeid<>402")
        @total=0
        for i in 0..@userassetsheet.size-1
          @total=@total+@userassetsheet[i].asset_value
          if @userassetsheet[i].asset_product_code!=nil && @userassetsheet[i].asset_product_code!=''
            a=0
            @fundquote=Monetary_fund_quote.find_by_product_code(@userassetsheet[i].asset_product_code)       #million_income
            if @fundquote!=nil && @fundquote.million_income!=nil
              @hash.store(@userassetsheet[i].id,[@fundquote.productname,@fundquote.million_income])
              a=1
            end
            @fundquote=General_fund_quote.find_by_product_code(@userassetsheet[i].asset_product_code)
            if @fundquote!=nil && @fundquote.today_value!=nil
              @hash.store(@userassetsheet[i].id,[@fundquote.product_name,@fundquote.today_value])
              a=1
            end
            if a==0
              @hash.store(@userassetsheet[i].id,[@hash1[@userassetsheet[i].asset_typeid][0],"-"])
            end
          else
            if @userassetsheet[i].asset_typeid==308
              @adminassettype=Admin_asset_type.find_by_asset_typeid("308")
              @hash.store(@userassetsheet[i].id,[@hash1[@userassetsheet[i].asset_typeid][0],@adminassettype.asset_value])
            else
              @hash.store(@userassetsheet[i].id,[@hash1[@userassetsheet[i].asset_typeid][0],"-"])
            end
          end
        end
      else
        redirect_to(:controller=>"usermanagement", :action=>"login", :familyassettable=>"1")
      end
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :familyassettable=>"1")
    end
   end
end


require 'openssl'
require 'base64'
ALG = 'DES-EDE3-CBC'  #算法
KEY = "mZ4Wjs6L"  #8位密钥
DES_KEY = "nZ4wJs6L"

#加密
def encode(str)
  des = OpenSSL::Cipher::Cipher.new(ALG)
  des.pkcs5_keyivgen(KEY, DES_KEY)
  des.encrypt
  cipher = des.update(str)
  cipher << des.final
  return Base64.encode64(cipher) #Base64编码，才能保存到数据库
end

#解密
def decode(str)
  str = Base64.decode64(str)
  des = OpenSSL::Cipher::Cipher.new(ALG)
  des.pkcs5_keyivgen(KEY, DES_KEY)
  des.decrypt
  des.update(str) + des.final
end