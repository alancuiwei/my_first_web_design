#encoding: utf-8
 class AdminController < ApplicationController
  def index
    @webusers=Webuser.all
  end

  def userconfig
    @userinfo=[]
    if params[:id]!="0"
    @webuser=Webuser.find_by_id(params[:id])
      @userinfo[0]=@webuser.username
      @userinfo[1]=decode(@webuser.password)
      @userinfo[2]=@webuser.tel
      @userinfo[3]=@webuser.address
      @userinfo[4]=@webuser.postcode
      @userinfo[5]=@webuser.period
      @userinfo[6]=@webuser.returnrate
    end
  end

  def  userconfigajax
    @webuser=Webuser.find_by_username(params[:username])
    password=encode(params[:password])
    if params[:id]=="0"
    if @webuser==nil
      Webuser.new do |w|
        w.username=params[:username]
        w.password=password
        w.tel=params[:tel]
        w.address=params[:address]
        w.postcode=params[:postcode]
        w.period=params[:period].to_f
        w.returnrate=params[:returnrate].to_f
        w.save
      end
    render :json => "s".to_json
    else
      render :json => "f".to_json
    end

    else
      @webuser.update_attributes(:password=>password,:tel=>params[:tel],
                                 :address=>params[:address],:postcode=>params[:postcode],:period=>params[:period].to_f,
      :returnrate=>params[:returnrate].to_f)
      render :json => "s2".to_json
    end
  end

   def userdeleteajax
     @webuser=Webuser.find(params[:id])
     if @webuser.destroy
     render :json => "s".to_json
     else
       render :json => "f".to_json
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