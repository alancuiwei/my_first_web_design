#encoding: utf-8
class HomeController < ApplicationController
  def index
    @personfinance=Personalfinance.all
    @username=Personalfinance.find_by_sql('select distinct username from personalfinance')
    @num=@username.length
  end

  def questions
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
    end
    @category1=Category_2.find_all_by_risklevel(1)
    @category2=Category_2.find_all_by_risklevel(2)
    @category3=Category_2.find_all_by_risklevel(3)
    @category4=Category_2.find_all_by_risklevel(4)
    @category5=Category_2.find_all_by_risklevel(5)
    @hash={}
    @category=Category_2.all
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

  def scheme
    @comments=Comments.find_by_sql('select * from comments where pid is not null order by id desc')
    @hash={}
    @comments.each do |b|
      @add=Webuser.find_by_username(b.username)
      if @add!=nil
        @hash.store(b.id,[@add.dream,@add.realizetime,@add.exeitdeposit])
      else
        @hash.store(b.id,[nil,nil,nil])
      end
    end
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

  def apply
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
    else
      @webuser=Webuser.find_by_username("admin")
    end
  end

  def plan
    if session[:webusername]!=nil
      @personalfinance=Personalfinance.find_by_username(session[:webusername])
      @webuser2=Webuser.find_by_username(session[:webusername])
      if @personalfinance!=nil
        session[:personname]=@personalfinance.username
      end
      if @webuser2.risktolerance==nil && params[:username]==nil && cookies[:asset_allocation]==nil
        redirect_to(:controller=>"home", :action=>"questions")
      end
      if @webuser2.risktolerance==nil && params[:username]==session[:webusername]
        redirect_to(:controller=>"home", :action=>"questions")
      end
    elsif cookies[:asset_allocation]==nil && params[:username]==nil
      redirect_to(:controller=>"home", :action=>"questions")
    else
      @webuser2=Webuser.find_by_username('admin')
    end
    if params[:user]!=nil && cookies[:asset_allocation]!=nil && session[:webusername]!=nil
        @provides=Provide.find_all_by_username(session[:webusername])
        @invest=cookies[:asset_allocation].split('|')[5].to_f
    elsif params[:username]!=nil
      @provides=Provide.find_all_by_username(params[:username])
      @personal=Personalfinance.find_by_username(params[:username])
      if @personal!=nil
        @invest=@personal.investamount.to_f
      else
        @invest=50000
      end
    elsif session[:webusername]!=nil
      @provides=Provide.find_all_by_username(session[:webusername])
      @personal=Personalfinance.find_by_username(session[:webusername])
      if @personal!=nil
        @invest=@personal.investamount.to_f
      else
        @invest=50000
      end
    else
      @provides=Provide.find_all_by_username('admin')
      if cookies[:asset_allocation]!=nil
        @invest=cookies[:asset_allocation].split('|')[5].to_f
      else
        @invest=50000
      end
    end
    if params[:username]!=nil
      @webuser=Webuser.find_by_username(params[:username])
      if @webuser==nil
        redirect_to(:controller=>"home", :action=>"questions")
      end
    elsif session[:webusername]!=nil  && cookies[:asset_allocation]==nil
      @webuser=Webuser.find_by_username(session[:webusername])
    else
      @webuser=Webuser.find_by_username('admin')
    end
  end

  def download
    send_file "app/assets/download/"+params[:filename] unless params[:filename].blank?
  end

  def guide
    @number=Downloadnum.find_by_id(1);
    @pdfnumber=@number.pdfnumber
    @jpgnumber=@number.jpgnumber
  end

  def downloadconfigajax
    @number=Downloadnum.find_by_id(1);
    @number.update_attributes(:pdfnumber=>params[:pdfnumber],:jpgnumber=>params[:jpgnumber])
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
        w.address=params[:address]
        w.postcode=params[:postcode]
        w.name=params[:name]
        w.email=params[:email]
        w.company=params[:company]
        w.trade=params[:trade]
        w.organuser=params[:organuser]
        w.securitiesnum=params[:securitiesnum]
        w.memberlevel=params[:memberlevel]
        w.risktolerance=params[:risktolerance]
        w.contact=params[:contact]
        w.scharge=params[:scharge]
        w.realizetime=params[:realizetime]
        w.monthpay=params[:monthpay]
        w.city=params[:city]
        w.dream=params[:dream]
        w.amount=params[:amount]
        w.remark=params[:remark]
        w.province=params[:province]
        w.certificate=params[:certificate]
        w.exeitdeposit=params[:exeitdeposit]
        if params[:investamount]!=nil
          w.isauto=0
        end
        if params[:organuser]=='1'
          w.approve=1
        end
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
