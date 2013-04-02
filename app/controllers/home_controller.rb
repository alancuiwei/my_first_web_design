#encoding: utf-8
class HomeController < ApplicationController
  def index
    @personinvestinfo=Personinvestinfo.all
    @username=Personalfinance.find_by_sql('select distinct username from personalfinance')
    @num=@username.length
  end
  def productindex
    if session[:webusername]=="admin"
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
      else
        @webuser=Webuser.find_by_username(session[:webusername])
      end
    else
      @webuser=Webuser.find_by_username(session[:webusername])
    end
  end
  def plan
    if session[:webusername]!=nil
      @personalfinance=Personalfinance.find_by_username(session[:webusername])
    elsif cookies[:asset_allocation]==nil
      redirect_to(:controller=>"home", :action=>"index")
    end
    if params[:username]!=nil
      @webuser=Webuser.find_by_username(params[:username])
    elsif session[:webusername]!=nil  && cookies[:asset_allocation]==nil
      @webuser=Webuser.find_by_username(session[:webusername])
    else
      @webuser=Webuser.find_by_username('admin')
    end
    if session[:webusername]!=nil
      @user=Webuser.find_by_username(session[:webusername])
      @hash_password=decode(@user.password)
      if @user.risktolerance==nil && cookies[:asset_allocation]==nil
        redirect_to(:controller=>"home", :action=>"questions")
      end
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