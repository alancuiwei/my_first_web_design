#encoding: utf-8
class HomeController < ApplicationController
  def methodology
    @methodology=Methodology.all
  end

  def index
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
    end
  end

  def questions
    @blog=Blog.find_by_id(461)
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @assetsheet=User_asset_sheet.find_by_username(session[:webusername])
      @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
      @risk=User_risktolerance_qa.where(username:session[:webusername])
    end
    @risktype=Admin_risktolerance_type.all
    @category1=Admin_asset_type_l2.where(risklevel:1)
    @category2=Admin_asset_type_l2.where(risklevel:2)
    @category3=Admin_asset_type_l2.where(risklevel:3)
    @category4=Admin_asset_type_l2.where(risklevel:4)
    @category5=Admin_asset_type_l2.where(risklevel:5)
    @hash={}
    @category=Admin_asset_type_l2.all
    for i in 0..@category.size-1
      @financial=Financial.where(classify:@category[i].classify)
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

  def download
    send_file "app/assets/download/"+params[:filename] unless params[:filename].blank?
  end

  def userconfig
    @webuser=Webuser.find_by_username(params[:username])
    if params[:password]!=nil
      password=encode(params[:password])
    end
    if @webuser==nil
      Webuser.new do |w|
        w.username=params[:username]
        w.password=password
        w.tel=params[:tel]
        w.email=params[:email]
        w.save
      end
    end
    render :json => "s".to_json
  end

  def qquserconfigajax
     @qquser=Qquser.find_by_openid(params[:openid])
     if @qquser==nil
       Qquser.new do |i|
         i.username=params[:username]
         i.openid=params[:openid]
         i.accesstoken=params[:accesstoken]
         i.save
       end
     end
     render :json => "s".to_json
  end

  def riskconfig
    @risk=User_risktolerance_qa.find_by_username_and_question_id(session[:webusername],params[:num])
    if @risk==nil
      User_risktolerance_qa.new do |i|
        i.username=params[:username]
        i.question_id=params[:num]
        i.question_answer=params[:svalue]
        i.save
      end
    else
       @risk.update_attributes(:question_id=>params[:num],:question_answer=>params[:svalue])
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
