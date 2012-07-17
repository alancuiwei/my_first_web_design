#encoding: utf-8
require 'openssl'
#require 'ctrader'
require 'iconv'
require 'yaml'
class AutotradeController < ApplicationController
  
  def index
    @profitchart_arr=Array.new
    for i in 0..23
    @profitchart_arr[23-i]=Profitchart.find(:all, :order =>"dateint DESC",:limit => 730)[i*30].profit+200000
    end

    @strategy_free=Strategyweb.find_all_by_price(0)

    @strategy_subscribe=Strategyweb.find(:all,:conditions =>["price>0"])
  end

  def autotrade_s1
    session[:login]="autotrade_s1"
    @strategy=Strategyweb.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])

    if params[:account]!=nil&&params[:password_s]!=nil &&  (@webuser.ctp_account==nil||@webuser.ctp_account=="" )
      #@decode = decode(@encode).slice(@webuser.salt.size,decode(@encode).size)
      @webuser.update_attribute(:ctp_account,params[:account])
      @webuser.update_attribute(:ctp_password,encode(@webuser.salt+params[:password_s],@webuser.email.slice(0,8),@webuser.hashed_password.slice(0,8)))
      @webuser.update_attribute(:ctp_brokerid ,'8080')
      @webuser.update_attribute(:ctp_frontaddr ,'tcp://gwf-front1.financial-trading-platform.com:41205')
    end

    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")

    if  params[:paramvalue]!=nil && params[:paramvalue].to_f > @strategyparam.paramvalue.to_f
      @stg010001s=Stg010001.find_all_by_username(session[:webuser_name])
      for i in 0..@stg010001s.size-1
            @stg010001s[i].destroy
      end
    end

    if  params[:paramvalue]!=nil
    @strategyparam.update_attribute(:paramvalue,params[:paramvalue].to_d/100)
    redirect_to :controller=>"autotrade" ,:action=>"personaltrading"
    end

    #@decode = decode(@webuser.ctp_password,@webuser.email.slice(0,8),@webuser.hashed_password.slice(0,8)).slice(@webuser.salt.size,decode(@webuser.ctp_password,@webuser.email.slice(0,8),@webuser.hashed_password.slice(0,8)).size)
  end

  def showror
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")
  end
  def personaltrading
    #gettime for ajax refresh
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @strategy_norisk=Strategyweb.find_by_strategyid_and_name("010001","无风险套利")
    if @webuser!=nil
      if @webuser.ctp_account!=nil&& @webuser.ctp_account!=""
    ctp_account=@webuser.ctp_account
    ctp_password=decode(@webuser.ctp_password,@webuser.email.slice(0,8),@webuser.hashed_password.slice(0,8)).slice(@webuser.salt.size,decode(@webuser.ctp_password,@webuser.email.slice(0,8),@webuser.hashed_password.slice(0,8)).size)
    ctp_brokerid =@webuser.ctp_brokerid
    ctp_frontaddr=@webuser.ctp_frontaddr
      end
    end
    @stg010001s_isorder_out=Stg010001.find_all_by_username_and_isorder(session[:webuser_name],1)
    if params[:gettime_p]!=nil
        @gettime_p=Time.now
        puts @gettime_p
        render :json => @gettime_p
        end
    if params[:name]!=nil
      puts "##########"
      puts params[:name]
      puts params[:disprice]
      pairname=params[:name].slice(params[:name].index(" ")+1,params[:name].size).tr("&","-")
      @stg010001=Stg010001.find_by_username_and_pairname(session[:webuser_name],pairname)
      @stg010001.update_attribute(:isorder,1)
      @stg010001s_isorder=Stg010001.find_all_by_username_and_isorder(session[:webuser_name],1)
      render :json=>@stg010001s_isorder
	    end
    if params[:isorder_show]!=nil
      @stg010001s= Stg010001.find_all_by_username(session[:webuser_name])
      render :json=> @stg010001s
    end
    if params[:name_s]!=nil
      puts "##########"
      puts params[:name_s]
    end
    #skip saved redirect back(session)
    session[:login]="personaltrading"
    #webuser
    @webuser = Webuser.find_by_name(session[:webuser_name])
    #stg010001
    @stg010001 = Stg010001.find_all_by_username(session[:webuser_name])
        if params[:pairname_p]!=nil
      Stg010001.new do |stg|
        stg.username=session[:webuser_name]
            stg.pairname=params[:pairname_p]
            stg.returnrate=params[:returnrate_p].to_f
        stg.time=Time.now.to_s(:db)
            stg.firstprice=params[:firstprice_p]
            stg.secondprice=params[:secondprice_p]
            stg.firstmarginrate=params[:firstmarginrate_p]
            stg.secondmarginrate=params[:secondmarginrate_p]
        stg.vatfee=params[:vatfee_p]
        stg.storageday=params[:storageday_p]
        stg.storagedailyfee=params[:storagedailyfee_p]
        stg.storagefee=params[:storagefee_p]
        stg.deliverchargebyhand=params[:deliverchargebyhand_p]
        stg.deliverfee=params[:deliverfee_p]
        stg.tradecharge=params[:tradecharge_p]
        stg.computetransfee=params[:computetransfee_p]
        stg.lendrate=params[:lendrate_p]
        stg.D1=params[:D1_p]
        stg.tradeunit=params[:tradeunit_p]
        stg.trademarginfee=params[:trademarginfee_p]
        stg.delivermarginfee=params[:delivermarginfee_p]
        stg.vatrate=params[:vatrate_p]
        stg.save
      end
    end
    #strategyparam
    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")
    #db (struct)
    db=Struct.new(:commodityid,:lendrate,:tradecharge,:trademargingap,:tradechargetype)
    @db=Array.new
    if @webuser==nil
      @userflag=0
    @defaultusercommodity=UsercommodityT.find_all_by_userid("tester1")
      @dbnum=@defaultusercommodity.size
    for i in 0..@defaultusercommodity.size-1 do
        @db[i]=db.new(@defaultusercommodity[i].commodityid,@defaultusercommodity[i].lendrate,@defaultusercommodity[i].tradecharge,@defaultusercommodity[i].trademargingap,@defaultusercommodity[i].tradechargetype)
    end
    else
      @subscribe=Subscribetable.find(:all,:conditions =>["subscribe_userid=?",@webuser.id],:order =>"subscribedate DESC",:limit=>1)[0]
      @userflag=1
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
      @dbnum=@usercommodity.size
   for i in 0..@usercommodity.size-1 do
        @db[i]=db.new(@usercommodity[i].commodityid,@usercommodity[i].lendrate,@usercommodity[i].tradecharge,@usercommodity[i].trademargingap,@usercommodity[i].tradechargetype)
          end
      if @webuser.level==99 && @webuser.leveldate!=nil
        @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.leveldate.to_s(:db),"%Y-%m-%d").to_i)/86400
        if @days<=@strategy_norisk.trydays
          @webuser.level=1
          @trynotice="您是试用用户，还有"+(@strategy_norisk.trydays-@days).to_i.to_s+"天的试用！"
        else
          @webuser.level=0
          @trynotice="该帐号试用期限已满，如果您想继续使用的话，需要缴费，请邮件联系 alan_cuiwei@yahoo.com.cn 或电话 13451936496！"
        end
      elsif @webuser.level==1
        @sub_days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@subscribe.subscribedate.to_s(:db),"%Y-%m-%d").to_i)/86400
        @trynotice="您是订阅用户，还有"+(@subscribe.subscribedays-@sub_days).to_i.to_s+"天的使用天数！"
      end
    end

  end


  def userreturnrate
    @strategyparam = StrategyparamT.find_by_username_and_strategyid_and_paramname(session[:webuser_name],"010001","returnrate")

    if  params[:paramvalue]!=nil && params[:paramvalue].to_f > @strategyparam.paramvalue.to_f
      @stg010001s=Stg010001.find_all_by_username(session[:webuser_name])
      for i in 0..@stg010001s.size-1
            @stg010001s[i].destroy
      end
    end

    if  params[:paramvalue]!=nil
    @strategyparam.update_attribute(:paramvalue,params[:paramvalue].to_d/100)
    redirect_to :controller=>"autotrade" ,:action=>"showror"
    end
  end

  def aboutautotrade

  end

  protected
    ALG = 'DES-EDE3-CBC'
    #KEY = "lili_925"
    #DES_KEY = "feifan_5"
  def encode(str,key,des_key)
      des = OpenSSL::Cipher::Cipher.new(ALG)
      des.pkcs5_keyivgen(key, des_key)
      des.encrypt
      cipher = des.update(str)
      cipher << des.final
      return Base64.encode64(cipher) #Base64编码，才能保存到数据库
    end

    #解密
    def decode(str,key,des_key)
      str = Base64.decode64(str)
      des = OpenSSL::Cipher::Cipher.new(ALG)
      des.pkcs5_keyivgen(key, des_key)
      des.decrypt
      des.update(str) + des.final
    end

end
