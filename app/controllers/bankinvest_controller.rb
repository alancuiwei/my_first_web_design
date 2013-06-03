#encoding: utf-8
require 'date'
class BankinvestController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'

  def agentproducts
 #   @bankfinances=Bankfinance.find_all_by_isorgan(1)
 #   @bankfinance2=Bankfinance.find_all_by_isorgan_and_ischosen(1,'1')
    @bankfinances=Bankfinance.find_by_sql("SELECT * FROM bankfinance where collectperiod>NOW() AND isorgan=1")
    @bankfinance2=Bankfinance.find_by_sql("SELECT * FROM bankfinance where collectperiod>NOW() AND isorgan=1 and ischosen='1'")
  end

  def organ
    @webuser=Webuser.find_by_username(session[:webusername])
    @bankfinances=Bankfinance.find_all_by_isorgan_and_name(1,session[:webusername])
  end

  def details
    @banfinance=Bankfinance.find_by_id(params[:bid])
    @reserve=Reserve.find_all_by_bname(@banfinance.bname)
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
    for i in 0..@compareid.size-1
      @compareobj[i]= Bankfinance.find(@compareid[i]);
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

  def index
    if params[:category_all]=='xtcp'
      @bankfinances=Bankfinance.find_by_sql('SELECT * FROM bankfinance WHERE productstate="xtcp"')
    elsif  params[:category_all]!=nil
      @bankfinances=Bankfinance.find_by_sql('SELECT * FROM bankfinance WHERE (collectperiod>=NOW() OR collectperiod IS NULL) AND productstate="'+params[:category_all]+'"')
    else
    @bankfinances=Bankfinance.find_by_sql('SELECT * FROM bankfinance WHERE collectperiod>=NOW() OR collectperiod IS NULL OR productstate="xtcp"')
    end
    #   @bankfinances=Bankfinance.all
  end

  def specialfinance
    @specialfinances=Bankfinance.find_by_sql('select * from bankfinance where ispickout=1')
  end

  def fourthpickout
    if params[:deficit]=="0"
      if params[:deadline]=="90"
         @bankfinances=Bankfinance.find_by_sql('select * from bankfinance where startvalue<='+params[:amount]+' and investperiod<=90 and (btype="保本" or btype>0 or btype is null)')
      elsif  params[:deadline]=="365"
        @bankfinances=Bankfinance.find_by_sql('select * from bankfinance where startvalue<='+params[:amount]+' and investperiod<=365 and investperiod>30 and (btype="保本" or btype>0 or btype is null)')
      else
        @bankfinances=Bankfinance.find_by_sql('select * from bankfinance where startvalue<='+params[:amount]+' and investperiod>365 and (btype="保本" or btype>0 or btype is null)')
      end
    else
      if params[:deadline]=="90"
        @bankfinances=Bankfinance.find_by_sql('select * from bankfinance where startvalue<='+params[:amount]+' and investperiod<=90 and (btype="不保本" or btype="0") and returnrate*100>'+ params[:returnrate])
      elsif  params[:deadline]=="365"
        @bankfinances=Bankfinance.find_by_sql('select * from bankfinance where startvalue<='+params[:amount]+' and investperiod<=365 and investperiod>30 and (btype="不保本" or btype="0") and returnrate*100>'+ params[:returnrate])
      else
        @bankfinances=Bankfinance.find_by_sql('select * from bankfinance where startvalue<='+params[:amount]+' and investperiod>365 and (btype="不保本" or btype="0") and returnrate*100>'+ params[:returnrate])
      end
    end
    if @bankfinances==nil
      redirect_to(:controller=>"bankinvest", :action=>"fourthpickout")
    end
  end

  def investrecord

    if session[:webusername]=="admin"
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
      else
        @webuser=Webuser.find_by_username(session[:webusername])
      end
    else
      @webuser=Webuser.find_by_username(session[:webusername])
    end

    if @webuser!=nil
      @products=Product.all
      @product=Product.find_by_id(@products[0].id)

      @username=@webuser.username
      @funds=Investrecord.find(:all,:conditions =>["username=? and recordtype=?",@username,"fund"],:order =>"date DESC")
      @interests=Investrecord.find(:all,:conditions =>["username=? and recordtype=?",@username,"interest"],:order =>"date ASC")
      @hash_interest={}
      @interests.each do |i|
        @hash_interest.store(i.ordernum,[i.date.to_s(:db),i.recordvalue])
      end

      @allfund=0
      @funds.each do |f|
        @allfund=@allfund+f.recordvalue
      end
      @allinterest=0
      @interests.each do |i|
        @allinterest=@allinterest+i.recordvalue
      end
      @allinvest=@allfund+@allinterest

    end
  end

  def  userconfigajax
    @webuser=Webuser.find_by_username(params[:username])
    if session[:webusername]==nil
      password=encode(params[:password])
      if @webuser==nil
        Webuser.new do |w|
          w.username=params[:username]
          w.password=password
          w.tel=params[:tel]
          w.email=params[:email]
          w.organuser=params[:organuser]
          w.memberlevel=params[:memberlevel]
          w.company=params[:company]
          w.division=params[:division]
          w.address=params[:address]
          w.postcode=params[:postcode]
          w.name=params[:name]
          w.securitiesnum=params[:securitiesnum]
          w.save
        end
        Thread.new{
            UserMailer.capply(params[:username],params[:tel],params[:email],"新用户注册&申请理财规划服务").deliver
            UserMailer.application(params[:username],params[:email],params[:title]).deliver
        }
        session[:webusername]=params[:username]
        render :json => "s".to_json
      else
        if @webuser.password==encode(params[:password])
          Thread.new{
            UserMailer.capply(params[:username],params[:tel],params[:email],params[:title]).deliver
            UserMailer.application(params[:username],params[:email],params[:title]).deliver
          }
          @webuser.update_attributes(:tel=>params[:tel],:email=>params[:email])
          session[:webusername]=params[:username]
          render :json => "r1".to_json
        else
          render :json => "r2".to_json
        end
      end
    else
      Thread.new{
         UserMailer.capply(params[:username],params[:tel],params[:email],params[:title]).deliver
         UserMailer.application(params[:username],params[:email],params[:title]).deliver
      }
      render :json => "s".to_json
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