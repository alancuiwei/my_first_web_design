#encoding: utf-8
 class AdminController < ApplicationController
  def index
    @webusers=Webuser.all
    @products=Product.all
    @hash_password={}
    @webusers.each do |w|
      @hash_password.store(w.id,decode(w.password))
    end
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

  def productconfig
    @productinfo=[]
    if params[:id]!="0"
      @product=Product.find_by_id(params[:id])
      @productinfo[0]=@product.pname
      @productinfo[1]=@product.description
      @productinfo[2]=@product.lastprofits
      @productinfo[3]=@product.todayprofit
      @productinfo[4]=@product.date
    end
  end

  def  productconfigajax
    @product=Product.find_by_pname(params[:pname])

    if params[:id]=="0"
      if @product==nil
        Product.new do |p|
          p.pname=params[:pname]
          p.description=params[:description]
          p.lastprofits=params[:lastprofits].to_f
          p.todayprofit=params[:todayprofit].to_f
          p.date=params[:date]
          p.save
        end
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end

    else
      @product.update_attributes(:pname=>params[:pname],:description=>params[:description],
                                 :lastprofits=>params[:lastprofits].to_f,:todayprofit=>params[:todayprofit].to_f,
                                 :date=>params[:date])
      if Productrecord.find_by_pname_and_date(params[:pname],params[:date])==nil
        @invest_f=Investrecord.find_all_by_pid_and_recordtype(params[:id],"fund")
        @invest_i=Investrecord.find_all_by_pid_and_recordtype(params[:id],"interest")
        funds=0
        @invest_f.each do |i|
          funds=funds+i.recordvalue
        end
        interest=0
        @invest_i.each do |i|
          interest=interest+i.recordvalue
        end
       Productrecord.new do |pr|
        pr.pname=params[:pname]
        pr.total=params[:lastprofits].to_f+params[:todayprofit].to_f+interest
        pr.yreturnrate=1
        pr.allprofits=params[:lastprofits].to_f+params[:todayprofit].to_f+interest-funds
        pr.capital=funds
        pr.lastprofits=params[:lastprofits].to_f
        pr.todayprofit=params[:todayprofit].to_f
        pr.date=params[:date]
        pr.save
       end
      end

      render :json => "s2".to_json
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

   def productdeleteajax
     @product=Product.find_by_id(params[:id])
     if @product.destroy
     render :json => "s".to_json
     else
       render :json => "f".to_json
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