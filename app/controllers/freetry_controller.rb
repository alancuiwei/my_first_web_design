#encoding: utf-8

class FreetryController < ApplicationController

def index
  @allmaxreturnrate_d=ArbcostmaxreturnrateV.find(:all,:order =>"returnrate DESC",:limit => 5)
  if params[:returnrate]!=nil
    @allmaxreturnrate=ArbcostmaxreturnrateV.find(:all, :conditions =>["returnrate>? ",params[:returnrate].to_f/100],:order =>"returnrate DESC",:limit => 5)
    render :json => @allmaxreturnrate
  end
end

def tryapply
  pid=decode(params[:pid].gsub(/ /,"+"))
  params=pid.split("&")
  @name=params[0].split("=")[1].force_encoding("utf-8")
  @email=params[1].split("=")[1]
  @tel=params[2].split("=")[1]
  @mail_serverurl=@email.slice(@email.index("@")+1,@email.size-@email.index("@"))
  @hash_fp_url=Hash["163.com","http://mail.163.com","126.com","http://mail.126.com","gmail.com","https://mail.google.com"]
  if @hash_fp_url[@mail_serverurl]==nil
    @fp_url="http://"+@mail_serverurl
  else
    @fp_url=@hash_fp_url[@mail_serverurl]
  end
end

def applysuccess
  pid=decode(params[:pid].gsub(/ /,"+").force_encoding("utf-8"))
  paramst=pid.split("&")
  @name=paramst[0].split("=")[1].force_encoding("utf-8")
  @email=paramst[1].split("=")[1]
  @tel=paramst[2].split("=")[1]
  @inc=paramst[3].split("=")[1]
  if @inc!="zhongrensoft"
    redirect_to("/freetry/applyerr")
  else
  @url="http://www.tongtianshun.com/freetry/apply?pid="+params[:pid].gsub(/ /,"+").force_encoding("utf-8")

  @webuser = Webuser.find_by_name(@name)
  if @webuser==nil
    Webuser.new do |w|
      w.name=@name
      w.email=@email
      w.salt=Webuser.object_id.to_s + rand.to_s
      w.hashed_password=Webuser.encrypt_password(@tel, w.salt)
      w.level=0
      w.save
    end
    @strategyparam=StrategyparamT.find_by_username(@name)
    if @strategyparam==nil
      StrategyparamT.new do |s|
        s.strategyid="010001"
        s.paramname="returnrate"
        s.paramvalue=0.1
        s.username=@name
        s.save
      end
    else
      @strategyparam.strategyid="010001"
      @strategyparam.paramname="returnrate"
      @strategyparam.paramvalue=0.1
      @strategyparam.username=@name
      @strategyparam.save
    end
    #new usercommodiy
    @usercommodity=UsercommodityT.find_all_by_userid("tester1")
    i=0
    while @usercommodity[i]!=nil
      UsercommodityT.new do |u|
        u.commodityid = @usercommodity[i].commodityid
        u.userid=@name
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
    session[:webuser_name] =@name
  end

  end

end

def apply
  pid=decode(params[:pid].gsub(/ /,"+").force_encoding("utf-8"))
  paramst=pid.split("&")
  @name=paramst[0].split("=")[1].force_encoding("utf-8")
  @email=paramst[1].split("=")[1]
  @tel=paramst[2].split("=")[1]
  @inc=paramst[3].split("=")[1]
  if @inc!="zhongrensoft"
    redirect_to("/freetry/applyerr")
  else
    sid=1
  @strategy=Strategyweb.find(sid)
  @webuser = Webuser.find_by_name(@name)
  if @webuser!=nil
    @pretry=@webuser.tryid
    if @pretry==nil
      @webuser.update_attribute(:tryid,"")
    end
    if @webuser.tryid.index(sid.to_s)==nil
      if @pretry==nil||@pretry==''
        @webuser.update_attribute(:tryid,sid.to_s)
      else
        @webuser.update_attribute(:tryid,@pretry+"|"+sid.to_s)
      end
    end
    if  @webuser.trydate==nil
      @webuser.update_attribute(:trydate,Time.now.to_s(:db))
      #@days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.trydate.to_s(:db),"%Y-%m-%d").to_i)/86400
      # @notice_try="您成功试用"+@strategy.name+"策略!您还有"+(@strategy.trydays-@days).to_i.to_s+"的试用天数！"
      # else
      #  @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.trydate.to_s(:db),"%Y-%m-%d").to_i)/86400
      #if (@strategy.trydays-@days)<=0
      #   @notice_try="您的试用期已过！"
      # else
      #  @notice_try="您正在试用"+@strategy.name+"策略!您还有"+(@strategy.trydays-@days).to_i.to_s+"天的试用天数！"
      #end
    end
  end
  end
end

def applyerr

end

def preregedit
  if Webuser.find_by_name(params[:name])!=nil
    render :json=>'name'.to_json
  elsif  Webuser.find_by_email(params[:email])!=nil
    render :json=>'email'.to_json
  else
    if params[:name]!=nil&&params[:email]!=nil&&params[:tel]!=nil

      pid=encode("name=#{params[:name]}&email=#{params[:email]}&tel=#{params[:tel]}&inc=zhongrensoft")
      Thread.new {
        UserMailer.tryapply(params[:email],"http://www.tongtianshun.com/freetry/applysuccess?pid="+pid,params[:name]).deliver
      }
      url="/freetry/tryapply?pid="+pid
      render :json=>url.to_json
    end
  end

end
protected
ALG = 'DES-EDE3-CBC'
KEY = "liliy925"
DES_KEY = "feifany5"
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