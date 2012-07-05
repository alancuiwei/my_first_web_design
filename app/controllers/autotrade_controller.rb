#encoding: utf-8
require 'openssl'
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

    if params[:account]!=nil&&params[:password]!=nil &&  (@webuser.ctp_account==nil||@webuser.ctp_account=="" )
      #@decode = decode(@encode).slice(@webuser.salt.size,decode(@encode).size)
      @webuser.update_attribute(:ctp_account,params[:account])
      @webuser.update_attribute(:ctp_password,encode(@webuser.salt+params[:password],@webuser.email.slice(0,8),@webuser.hashed_password.slice(0,8)))
      @webuser.update_attribute(:ctp_brokerid ,'2030')
      @webuser.update_attribute(:ctp_frontaddr ,'tcp://asp-sim2-dx-front1.financial-trading-platform.com:26205')
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
    if @webuser!=nil
      if @webuser.ctp_account!=nil&& @webuser.ctp_account!=""
    ctp_account=@webuser.ctp_account
    ctp_password=decode(@webuser.ctp_password,@webuser.email.slice(0,8),@webuser.hashed_password.slice(0,8)).slice(@webuser.salt.size,decode(@webuser.ctp_password,@webuser.email.slice(0,8),@webuser.hashed_password.slice(0,8)).size)
    ctp_brokerid =@webuser.ctp_brokerid
    ctp_frontaddr=@webuser.ctp_frontaddr
      end
    end

    if params[:gettime_p]!=nil
        @gettime_p=Time.now
        puts @gettime_p
        render :json => @gettime_p
        end
    if params[:name]!=nil
      puts "##########"
      puts params[:name]
      puts params[:disprice]
      begin
	l_trader = Ctrader::CTrader.new()
        l_rtn = l_trader.ExtOrderinsert(params[:name],-(params[:disprice].to_i))
        l_str = ""
	if l_rtn<0
	   puts "insertorder error:#{l_trader.rspinfo.ErrorMsg}"
           l_str = Iconv.iconv('UTF-8','GB2312', l_trader.rspinfo.ErrorMsg)
		     render:js => "alert('insertorder error:#{l_str}\\n#{params[:name]},#{params[:disprice]}')"
	else
	    if l_trader.isrsperror && l_trader.orderinfo.OrderStatus != nil
		puts " order process error:#{l_trader.rspinfo.ErrorMsg}"
                l_str = Iconv.iconv('UTF-8','GB2312', l_trader.rspinfo.ErrorMsg)
		         render:js => "alert('order process error:#{l_trader.rspinfo.ErrorMsg}\\n#{params[:name]},#{params[:disprice]}')"
	    else
		puts "orderinsert successful!"
		         render:js => "alert('orderinsert successful!ordestatus:#{l_trader.orderinfo.OrderStatus}\\n#{params[:name]},#{params[:disprice]}')"
	    end
	    puts "ordestatus:#{l_trader.orderinfo.OrderStatus}"
	end
	      puts "ordestatus:#{l_trader.orderinfo.OrderStatus}"

      rescue => e
        render:js => "alert('failed:#{e}')"
      end
    end

    if params[:name_s]!=nil
      puts "##########"
      puts params[:name_s]
     begin
	    l_trader = Ctrader::CTrader.new()
	    l_trader.StartTrader()

	    l_orderqury=Ctrader::CThostFtdcQryOrderField.new
	    l_orderqury.InstrumentID = params[:name_s]
	    l_orderqury.InsertTimeStart = ""
	    l_orderqury.InsertTimeEnd = ""

	    #sleep(1)
	    l_rtn = l_trader.ExtQryOrder(l_orderqury)
	    l_orderarray = Array.new
	    if l_rtn<0
           l_str = Iconv.iconv('UTF-8','GB2312', l_trader.rspinfo.ErrorMsg)
	       puts "queryorder error:#{l_str}"
	    else
	        if l_trader.isrsperror
               l_str = Iconv.iconv('UTF-8','GB2312', l_trader.rspinfo.ErrorMsg)
		       puts " queryorder process error:#{l_str }"
	        else
		       puts "queryorder successful!"
	        end
	    end

	    #sleep(1)
	    l_order = Ctrader::CThostFtdcOrderField.new
	    l_ordernum = l_trader.ExtGetQryOrderNum()
        l_lines = Array.new
	    if l_ordernum > 0
	        for l_id in 0..l_ordernum-1 do
	           l_orderarray[l_id] = Array.new
	           l_order = l_trader.ExtGetQryOrder(l_id)
	           #l_orderarray[l_id] = l_order
		       l_orderarray[l_id][0] = l_order.InstrumentID
		        puts "l_orderarray[l_id].OrderStatus:#{l_order.OrderStatus}"
			    case l_order.OrderStatus
			      when '0'
				      l_orderarray[l_id][1] = '成交'
				      l_orderarray[l_id][6] = '1'
				      l_orderarray[l_id][7] = l_order.LimitPrice.to_s
			      else
				      l_orderarray[l_id][1] = '未成交'
				      l_orderarray[l_id][6] = '0'
		          l_orderarray[l_id][7] = '0'
			    end

		        l_orderarray[l_id][2] = '买'
			    l_orderarray[l_id][3] = '开'
		        l_orderarray[l_id][4] = '1'
		        l_orderarray[l_id][5] = l_order.LimitPrice.to_s
                l_lines[l_id] = l_orderarray[l_id].join("  ")
	        end

            puts l_lines.join("\n")
            l_msgstr = l_lines.join('\n')
            render:js => "alert('#{l_msgstr}')"
        else
            puts "results:#{l_ordernum}"
            render:js => "alert('results:#{l_ordernum}')"
	    end

      rescue => e
        #l_str = Iconv.iconv('UTF-8','GB2312', e)
        render:js => "alert('failed:#{e}')"
      end
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
      @userflag=1
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
      @dbnum=@usercommodity.size
   for i in 0..@usercommodity.size-1 do
        @db[i]=db.new(@usercommodity[i].commodityid,@usercommodity[i].lendrate,@usercommodity[i].tradecharge,@usercommodity[i].trademargingap,@usercommodity[i].tradechargetype)
          end
      if @webuser.level==99
        @days=(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@webuser.leveldate.to_s(:db),"%Y-%m-%d").to_i)/86400
        if @days<=60
          @webuser.level=1
          @trynotice="您是试用用户，还有"+(60-@days).to_s+"天的试用！"
        else
          @webuser.level=0
          @trynotice="该帐号试用期限已满，如果您想继续使用的话，需要缴费，请邮件联系 alan_cuiwei@yahoo.com.cn 或电话 13451936496！"
        end
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
    redirect_to :controller=>"strategy" ,:action=>"showror"
    end
  end
  #protected
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
