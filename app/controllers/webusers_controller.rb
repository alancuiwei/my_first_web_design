#encoding: utf-8
require 'openssl'
class WebusersController < ApplicationController
  # GET /webusers
  # GET /webusers.json
  def user_lr
    if params[:name]!=nil
      if Webuser.authenticate(params[:name], params[:password])
        session[:webuser_name] =params[:name]
        render :json =>(params[:name]+"|"+Webuser.find_by_name(session[:webuser_name]).id.to_s).to_json
      else
        @test='您的用户名或者密码输入错误！'.to_json
      render :json => @test
  end
    end

    if params[:regedit_name]!=nil
      if  params[:regedit_name]==""
        puts params[:regedit_name]
        render :json=>'用户名为空！'.to_json
      elsif  params[:regedit_email]==""
          render :json=>'电子邮箱为空！'.to_json
      elsif  params[:regedit_password]==""
          render :json=>'密码为空！'.to_json
      elsif  params[:regedit_password_confirmation]==""
            render :json=>'密码确认为空！'.to_json
      elsif  params[:regedit_password_confirmation]!=params[:regedit_password]
            render :json=>'密码不一致！'.to_json
      elsif /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.match(params[:regedit_email])==nil
        render :json=>'请输入正确的电子邮箱！'.to_json
      elsif Webuser.find_by_name(params[:regedit_name])!=nil
        render :json=>'用户名已注册！'.to_json
      elsif  Webuser.find_by_email(params[:regedit_email])!=nil
        render :json=>'电子邮箱已注册！'.to_json
      else
        render :json=>params[:regedit_name].to_json
      end
    end

    if params[:logout]!=nil
      session[:webuser_name] =nil
      render :json=>params[:logout].to_json
    end
  end

  def oldpassword
    @webuser=Webuser.find_by_name(session[:webuser_name])
    if Webuser.authenticate(session[:webuser_name], params[:oldpassword])
      @webuser.update_attribute(:hashed_password,Webuser.encrypt_password(params[:password], @webuser.salt))
      render :json=>"s".to_json
    else
      render :json=>"f".to_json
    end
  end

  def regeditconfirm
    @mail_serverurl=params[:regedit_email].slice(params[:regedit_email].index("@")+1,params[:regedit_email].size-params[:regedit_email].index("@"))
    @hash_fp_url=Hash["163.com","http://mail.163.com","126.com","http://mail.126.com","gmail.com","https://mail.google.com"]
    if @hash_fp_url[@mail_serverurl]==nil
      @fp_url="http://"+@mail_serverurl
    else
      @fp_url=@hash_fp_url[@mail_serverurl]
    end
    if params[:regedit_flag]!=nil
    UserMailer.regeditconfirm(params[:regedit_email],params[:regedit_name],"http://localhost:3000/webusers/regedit/1?"+"regedit_name="+params[:regedit_name]+"&regedit_email="+(params[:regedit_email])+"&regedit_password="+params[:regedit_password]).deliver
  end
  end

  def regedit
    @webuser = Webuser.find_by_name(params[:regedit_name])
    if @webuser==nil
    Webuser.new do |w|
      w.name=params[:regedit_name]
      w.email=params[:regedit_email]
      w.salt=Webuser.object_id.to_s + rand.to_s
      w.hashed_password=Webuser.encrypt_password(params[:regedit_password], w.salt)
      w.level=0
      w.save
    end
    StrategyparamT.new do |s|
      s.strategyid="010001"
      s.paramname="returnrate"
      s.paramvalue=0.1
      s.username=params[:regedit_name]
      s.save
    end
    #new usercommodiy
    @usercommodity=UsercommodityT.find_all_by_userid("tester1")
    i=0
    while @usercommodity[i]!=nil
    UsercommodityT.new do |u|
     u.commodityid = @usercommodity[i].commodityid
     u.userid=params[:regedit_name]
     u.tradechargetype=@usercommodity[i].tradechargetype
     u.tradecharge=@usercommodity[i].tradecharge
     u.deliverchargebyunit=@usercommodity[i].deliverchargebyunit
     u.deliverchargebyhand=@usercommodity[i].deliverchargebyhand
     u.futuretocurrenchargebyunit=@usercommodity[i].futuretocurrenchargebyunit
     u.futuretocurrenchargebyhand=@usercommodity[i].futuretocurrenchargebyhand
     u.lendrate=@usercommodity[i].lendrate
     u.trademargingap=@usercommodity[i].trademargingap
     u.save
     i=i+1
    end
    end
    session[:webuser_name] =params[:regedit_name]
      end
  end

  def index
    @webusers = Webuser.order(:name)
    @hash_level= Hash[0,"普通用户",1,"收费用户",99,"试用用户"]
	if session[:webuser_name]=="administrator"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @webusers }
    end
	else
	redirect_to(:controller=>"home", :action=>"index")
	end
  end

  # GET /webusers/1
  # GET /webusers/1.json
  def show
    @webuser = Webuser.find(params[:id])
    @hash_level= Hash[0,"普通用户",1,"收费用户",99,"试用用户"]
  end

  # GET /webusers/1/edit
  def edit
    @webuser = Webuser.find(params[:id])
  end

  # DELETE /webusers/1
  # DELETE /webusers/1.json
  def destroy
    @webuser = Webuser.find(params[:id])
    @usercommoditys=UsercommodityT.find_all_by_userid(@webuser.name)
    @stg010001s=Stg010001.find_all_by_username(@webuser.name)
    @strategyparam = StrategyparamT.find_by_username(@webuser.name)

    for i in 0..@usercommoditys.size-1
      @usercommoditys[i].destroy
    end
    for i in 0..@stg010001s.size-1
      @stg010001s[i].destroy
    end
    if @strategyparam!=nil
   @strategyparam.destroy
   end
    @webuser.destroy
    respond_to do |format|
      format.html { redirect_to webusers_url }
      format.json { head :ok }
    end
  end

  def leveledit
    @webuser = Webuser.find(params[:id])
    @hash_level= Hash[0,"普通用户",1,"收费用户",99,"试用用户"]
    if params[:level]!=nil
      @webuser.update_attribute(:level,params[:level])
      @webuser.update_attribute(:leveldate,Time.now.to_s(:db))
      redirect_to(:controller=>"webusers", :action=>"index")
    end
  end

  def forgetpassword
    if params[:my_email]
      @webuser=Webuser.find_by_email(params[:my_email])
    if @webuser==nil
      @error=true
    else
      @error=false
      fp_id=encode(params[:id]+@webuser.id.to_s)
      if @webuser.fp_id!=fp_id
      @webuser.update_attribute(:fp_id,fp_id)
      @webuser.update_attribute(:fp_date,Time.now.to_s(:db))
      #UserMailer.forgetpassword(params[:my_email],"http://localhost:3000/webusers/resetpassword/"+params[:id]+"?fp_id="+fp_id,@webuser.name,params[:id]).deliver
      end
      @mail_serverurl=params[:my_email].slice(params[:my_email].index("@")+1,params[:my_email].size-params[:my_email].index("@"))
      @hash_fp_url=Hash["163.com","http://mail.163.com","126.com","http://mail.126.com","gmail.com","https://mail.google.com"]
      if @hash_fp_url[@mail_serverurl]==nil
        @fp_url="http://"+@mail_serverurl
      else
        @fp_url=@hash_fp_url[@mail_serverurl]
      end
      #@fp_url=
    end
  end
  end

  def forgetpassword_af
    if params[:my_email]
      @webuser=Webuser.find_by_email(params[:my_email])
    if @webuser==nil
      @error=true
    else
      @error=false
      fp_id=encode(params[:id]+@webuser.id.to_s)
      if @webuser.fp_id!=fp_id
      @webuser.update_attribute(:fp_id,fp_id)
      @webuser.update_attribute(:fp_date,Time.now.to_s(:db))
      UserMailer.forgetpassword(params[:my_email],"http://localhost:3000/webusers/resetpassword/"+params[:id]+"?fp_id="+fp_id,@webuser.name,params[:id]).deliver
      end
      @mail_serverurl=params[:my_email].slice(params[:my_email].index("@")+1,params[:my_email].size-params[:my_email].index("@"))
      @hash_fp_url=Hash["163.com","http://mail.163.com","126.com","http://mail.126.com","gmail.com","https://mail.google.com"]
      if @hash_fp_url[@mail_serverurl]==nil
        @fp_url="http://"+@mail_serverurl
      else
        @fp_url=@hash_fp_url[@mail_serverurl]
      end
      #@fp_url=
    end
  end
    render :json=>"s".to_json
  end

  def resetpassword
    id=decode(params[:fp_id]).slice(14,decode(params[:fp_id]).size)
   @webuser=Webuser.find_by_id(id)
    @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.fp_date.to_s(:db),"%Y-%m-%d").to_i)/86400
    if @webuser!=nil&&@webuser.fp_id!=nil&&@days<3&&@webuser.fp_id.slice(0,params[:fp_id].size)==params[:fp_id]
      session[:webuser_name]=@webuser.name
      redirect_to(:controller=>"webusers", :action=>"edit",:id=>@webuser.id)
    else
      @notice="链接已过期！"

    end
  end

  protected
    ALG = 'DES-EDE3-CBC'
    KEY = "lili_925"
    DES_KEY = "feifan_5"
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

end
