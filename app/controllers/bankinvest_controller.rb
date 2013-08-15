#encoding: utf-8
require 'date'
class BankinvestController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'

  def pace
    @pace=Pace.all
  end

  def classify
   if params[:id]!=nil
    @category=Category_2.find_by_id(params[:id])
   else
     redirect_to(:controller=>"home",:action=>"index")
   end
  end

  def press
    @press=Press.order("pdate desc").all
  end

  def products
    @financial=Financial.find_all_by_category("风险型资产");
    @hash={}
    for i in 0..@financial.size-1
      @category=Category_2.find_by_classify(@financial[i].classify)
      if @category!=nil
        @hash.store(@category.classify,[@category.id])
      else
        @hash.store(@category.classify,[nil])
      end
    end
    @hash3={}
    @financial2=Financial.find_all_by_classify('货币基金')
    for i in 0..@financial2.size-1
      @financial1=Financial.find_all_by_productcode(@financial2[i].productcode)
      @f1=@financial2[i].pname
      @f5=@financial2[i].rate
      @f6=@financial2[i].rank
      for j in 0..@financial1.size-1
        if @financial1[j].pname!=@financial2[i].pname
          @f1=@financial1[j].pname
          @f5=@financial1[j].rate
          @f6=@financial1[j].rank
        end
      end
      @f2='否'
      @f3='否'
      @f4='否'
      if @financial2[i].way!=nil
        if @financial2[i].way.include? "iphone"
          @f2='是'
        end
        if @financial2[i].way.include? "android"
          @f3='是'
        end
        if @financial2[i].way.include? "weixin"
          @f4='是'
        end
      end
      @hash3.store(@financial2[i].id,[@financial1.length,@f1,@f2,@f3,@f4,@f5,@f6])
    end
  end

  def buylinks
    if params[:id]!=nil
      @financial=Financial.find_by_id(params[:id])
      @productcompany=Productcompany.find_all_by_pname(@financial.pname)
      @hash={}
      for i in 0..@productcompany.size-1
        @salescompany=Salescompany.find_by_fundname(@productcompany[i].fundname)
        if @salescompany!=nil
          @hash.store(@productcompany[i].fundname,[@salescompany.logo,@salescompany.guide,@salescompany.time])
        else
          @hash.store(@productcompany[i].fundname,[nil,nil,nil])
        end
      end
    else
      redirect_to(:controller=>"bankinvest", :action=>"products")
    end
  end

  def salescompany
    if params[:id]!=nil
      @salescompany=Salescompany.find_by_id(params[:id])
      if @salescompany.assist!=nil
      @saleshelp=@salescompany.assist.split(",")
      end
      if params[:pid]!=nil
        @financial=Financial.find_by_id(params[:pid])
        @productcompany=Productcompany.find_by_pname_and_fundname(@financial.pname,@salescompany.fundname)
      end
    else
      redirect_to(:controller=>"home", :action=>"index")
    end
  end

  def productdetails
    if params[:id]!=nil
      @financial=Financial.find_by_id(params[:id])
      @category=Category_2.find_by_classify(@financial.classify)
      @productcompany=Productcompany.find_all_by_pname(@financial.pname)
      @hash={}
      for i in 0..@productcompany.size-1
        @salescompany=Salescompany.find_by_fundname(@productcompany[i].fundname)
        if @salescompany!=nil
          @hash.store(@productcompany[i].fundname,[@salescompany.id])
        else
          @hash.store(@productcompany[i].fundname,[nil,nil,nil])
        end
        if i==0
          @min=@productcompany[i].poundage
        elsif @min>@productcompany[i].poundage
          @min=@productcompany[i].poundage
        end
      end
    else
      redirect_to(:controller=>"bankinvest", :action=>"products")
    end
  end

  def compare
    @compareid=session[:compareid].split("|")
    @compareid.delete("")
    for i in 0..@compareid.size-1
        for j in i+1..@compareid.size-1
            if  @compareid[i]==@compareid[j]
              @compareid.delete_at(j)
            end
        end
    end
    @compareobj=[]
    @hash={}
    for i in 0..@compareid.size-1
      @compareobj[i]= Financial.find(@compareid[i]);
      @category=Category_2.find_by_classify(@compareobj[i].classify)
     if @category!=nil
       @hash.store(i,[@category.risk1,@category.return1,@category.prisk])
     else
       @hash.store(i,[nil,nil,nil])
     end
    end
  end
  def comparesession
    if params[:comparenum]=='0'
      session[:compareid]=""
    end
    if  params[:type]=="clearid"
      session[:compareid]=""
    else if params[:type]=="deleteid"
      session[:compareid]=session[:compareid].gsub(params[:compareid],"")
      else
     session[:compareid]=session[:compareid]+"|"+params[:compareid]
    end
   end
     render :json => "s".to_json
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