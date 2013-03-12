#encoding: utf-8
class SalesController < ApplicationController
  def index
    @banfinance=Bankfinance.find_by_id(params[:bid])
    if @banfinance==nil
      redirect_to(:controller=>"bankinvest", :action=>"index")
    end
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

  def myorder
      @reserve=Reserve.find_all_by_username(session[:webusername])
    end

  def confirm
    @banfinance=Bankfinance.find_by_id(params[:bid])
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
        session[:webusername]=nil
      end
    end

  end

  def revise

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