#encoding: utf-8
 class AdminController < ApplicationController
   Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
  def index
    if session[:webusername]=="admin"
    @webusers=Webuser.all
    @bankfinances=Bankfinance.all
    @blogs=Blog.all
    @products=Product.all
    @investfunds=Investrecord.find_all_by_recordtype("fund")
    @adminremind={}
    @adminconfirm={}
    @products.each do |p|
      date=Investrecord.find(:all,:conditions =>["recordtype=? and pname=?","fund",p.pname],:order =>"date ASC")

      if date[0]!=nil

        admininterests=Investrecord.find(:all,:conditions =>["recordtype=? and username=? and pname=?","interest","admin",p.pname],:order =>"date DESC")

        if admininterests[0]==nil
          startdate=Date.parse(date[0].date.to_s(:db)) >> p.period
        else
          startdate=Date.parse(admininterests[0].date.to_s(:db))>> p.period
        end
        if startdate!=nil
          if (startdate-Date.today)> 0
            @adminremind.store(startdate.to_s+p.pname,[p.pname,startdate.to_s,"无法预估(需要当日基金值)"])
          else

          while (startdate-Date.today)<0
            profit=Productrecord.find_by_date(startdate)
            if profit==nil
              #abort("Productrecord中没有#{p.pname}|#{startdate}的基金记录！")
              @adminconfirm.store(startdate.to_s+p.pname,[p.pname,startdate.to_s,"没有#{p.pname}|#{startdate}的基金记录！"])
            else
            if p.dividendtype=="fix"
              #interests
              investfunds=Investrecord.find(:all,:conditions =>["pname=? and recordtype=? and date<?",p.pname,"fund",startdate])
              interests=0
              investfunds.each do |i|
                  interests=interests+i.recordvalue*p.dividendvalue*p.period/12
                end
             @adminconfirm.store(startdate.to_s+p.pname,[p.pname,startdate.to_s,format("%.0f",profit.lastprofits+profit.todayprofit-profit.capital-interests)])
            else
              @adminconfirm.store(startdate.to_s+p.pname,[p.pname,startdate.to_s,format("%.0f",(profit.lastprofits+profit.todayprofit-profit.capital)*(1-p.dividendvalue))])
            end

            end
            startdate=startdate>>p.period
            end

          end
        end

      end

    end

    #user
    @hash_password={}
    @hash_remind={}
    @hash_confirm={}

    @webusers.each do |w|
      @hash_password.store(w.id,decode(w.password))

      @products.each do |p|
        firstfund=Investrecord.find(:all,:conditions =>["recordtype=? and pname=?","fund",p.pname],:order =>"date ASC")
        if firstfund[0]!=nil
          firstfunddate=firstfund[0].date
      funds=Investrecord.find(:all,:conditions =>["username=? and recordtype=? and pname=?",w.username,"fund",p.pname],:order =>"date DESC")
          for i in 0..funds.size-1

            userinterest=Investrecord.find(:all,:conditions =>["username=? and recordtype=? and pname=? and ordernum=?",w.username,"interest",p.pname,funds[i].ordernum],:order =>"date DESC")
            if userinterest[0]==nil
              paydate= Date.parse(firstfunddate.to_s(:db)) >> p.period
            else
              paydate= Date.parse(userinterest[0].date.to_s(:db)) >> p.period
      end

            if paydate!=nil
              if (paydate-Date.today)> 0
        if p.dividendtype=="fix"
        interestvalue=format("%.0f",funds[i].recordvalue*p.dividendvalue*p.period/12)
          else
                   interestvalue="无法预估(需要当日基金值)"
        end
                @hash_remind.store(paydate.to_s+w.username+p.pname+funds[i].ordernum.to_s,[w.username,p.pname,funds[i].ordernum,paydate,interestvalue])
          else
            while (paydate-Date.today)< 0
                  if p.dividendtype=="fix"
                    interestvalue=format("%.0f",funds[i].recordvalue*p.dividendvalue*p.period/12)
                  else
                    profituser=Productrecord.find_by_date(paydate)
                    if profituser!=nil
                    oldfundsnum=Investrecord.find(:all,:conditions =>["recordtype=? and pname=? and date<?","fund",p.pname,paydate],:order =>"date DESC").size
                    interestvalue=format("%.0f",(profituser.lastprofits+profituser.todayprofit-profituser.capital)*p.dividendvalue/oldfundsnum)
                    else
                      #abort("Productrecord中没有#{p.pname}|#{paydate}的基金记录！(user)")
                      interestvalue="没有#{p.pname}|#{paydate}的基金记录！"
                    end
                  end
                  @hash_confirm.store(paydate.to_s+w.username+p.pname+funds[i].ordernum.to_s,[w.username,p.pname,funds[i].ordernum,paydate,interestvalue])
              paydate=paydate>>p.period

            end
          end
        end

      end
      end
      end

      end

    else
      redirect_to(:controller=>"home")
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
    end
  end

   def userlogout
     session[:webusername]=nil
     render :json => "s".to_json
   end

  def productconfig
    @productinfo=[]
    if params[:id]!="0"
      @product=Product.find_by_id(params[:id])
      @productinfo[0]=@product.pname
      @productinfo[1]=@product.description
      @productinfo[2]=@product.founddate
      @productinfo[3]=@product.dividendtype
      @productinfo[4]=@product.dividendvalue
      @productinfo[5]=@product.period
      @productinfo[6]=@product.riskvalue
      @productinfo[7]=@product.descriptions
    end
  end

  def  productconfigajax
    @product=Product.find_by_id(params[:id])
    if params[:optype]=="update"
      lastdate=Productrecord.find(:all,:conditions =>["pname=?",@product.pname],:order =>"date DESC")[0].date
      if params[:date].to_date-lastdate>=0
      @product.update_attributes(:lastprofits=>params[:lastprofits].to_f,:todayprofit=>params[:todayprofit].to_f,
                                 :date=>params[:date])
      end
      @invest_f=Investrecord.find(:all,:conditions =>["pname=? and recordtype=? and date<?",@product.pname,"fund",Date.parse(params[:date])])
      @invest_i=Investrecord.find(:all,:conditions =>["pname=? and recordtype=? and date<?",@product.pname,"interest",Date.parse(params[:date])])
      funds=0
      @invest_f.each do |i|
        funds=funds+i.recordvalue
      end
      interest=0
      @invest_i.each do |i|
        interest=interest+i.recordvalue
      end
      productrecord=Productrecord.find_by_pname_and_date(@product.pname,params[:date])
      if productrecord==nil
        Productrecord.new do |pr|
          pr.pname=@product.pname
          pr.total=params[:lastprofits].to_f+params[:todayprofit].to_f+interest
          pr.allprofits=params[:lastprofits].to_f+params[:todayprofit].to_f+interest-funds
          pr.capital=funds
          pr.predividend=interest
          pr.lastprofits=params[:lastprofits].to_f
          pr.todayprofit=params[:todayprofit].to_f
          pr.date=params[:date]
          pr.save
        end
        render :json => "us1".to_json
      else
        productrecord.update_attributes(:total=>params[:lastprofits].to_f+params[:todayprofit].to_f+interest,
                                        :allprofits=>params[:lastprofits].to_f+params[:todayprofit].to_f+interest-funds,
                                        :capital=>funds,:lastprofits=>params[:lastprofits].to_f,:todayprofit=>params[:todayprofit].to_f,
                                        :date=>params[:date],:predividend=>interest)
        render :json => "us2".to_json
      end

    else  #edit
      if params[:id]=="0"
        if @product==nil
          Product.new do |p|
            p.pname=params[:pname]
            p.description=params[:description]
            p.descriptions=params[:descriptions]
            p.founddate=params[:founddate]
            p.dividendtype=params[:dividendtype]
            p.dividendvalue=params[:dividendvalue].to_f
            p.period=params[:period].to_f
            p.riskvalue=params[:riskvalue].to_f
            p.save
          end
          render :json => "es".to_json
        else
          render :json => "ef".to_json
        end

      else  #edit edit
        pname=@product.pname
        if pname!=params[:pname]
          @o_precords=Productrecord.find_all_by_pname(pname)
          @o_precords.each do |o|
            o.update_attributes(:pname=>params[:pname])
          end
        end
        @product.update_attributes(:pname=>params[:pname],:description=>params[:description],:descriptions=>params[:descriptions],:founddate=>params[:founddate],
                                   :dividendtype=>params[:dividendtype],:dividendvalue=>params[:dividendvalue].to_f,
            :period=>params[:period].to_f,:riskvalue=>params[:riskvalue].to_f)
        render :json => "es2".to_json
      end


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
        w.save
      end
    render :json => "s".to_json
    else
      render :json => "f".to_json
    end

    else
      @webuser.update_attributes(:password=>password,:tel=>params[:tel],
                                 :address=>params[:address],:postcode=>params[:postcode])
      render :json => "s2".to_json
    end
  end

   def create
       UserMailer.confirm.deliver
       redirect_to users_path
   end

   def productdeleteajax
     @product=Product.find_by_id(params[:id])
     if @product!=nil
       @productrecords=Productrecord.find_all_by_pname(@product.pname)
     end
     if @product.destroy
       if @productrecords!=nil
         @productrecords.each do |p|
           p.destroy
         end
       end
     render :json => "s".to_json
     else
       render :json => "f".to_json
     end
   end

   def userdeleteajax
     @webuser=Webuser.find(params[:id])
     if @webuser!=nil
       @investrecords=Investrecord.find_all_by_username(@webuser.username)
     end
     if @webuser.destroy
       if @investrecords!=nil
         @investrecords.each do |i|
           i.destroy
         end
       end
     render :json => "s".to_json
     else
       render :json => "f".to_json
     end
   end

  def userlogin
     @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      if @webuser.password==encode(params[:password])
        if @webuser.username=="admin"
        session[:webusername]=@webuser.username
        render :json => "admin".to_json
        else
          session[:webusername]=@webuser.username
          render :json => "s".to_json
        end
      else
        render :json => "f".to_json
      end
    else
      render :json => "f2".to_json
    end
  end

  def fundconfig
    @fundinfo=[]
    @webusers=Webuser.all
    if params[:id]!="0"
      @investfund=Investrecord.find_by_id(params[:id])
      @fundinfo[0]=@investfund.username
      @fundinfo[1]=@investfund.pname
      @fundinfo[2]=@investfund.date.to_s(:stamp)
      @fundinfo[3]=@investfund.recordvalue
    end
  end

  def  fundconfigajax
    @investfund=Investrecord.find_by_id(params[:id])
    @fundordernum=Investrecord.find(:all,:conditions =>["username=? and recordtype=? and pname=?",params[:username],"fund",params[:pname]],:order =>"ordernum DESC")

    if @fundordernum[0]!=nil
      ordernum=@fundordernum[0].ordernum+1
    else
      ordernum=1
    end

    if params[:id]=="0"
      if Webuser.find_by_username(params[:username])==nil
        render :json => "nouser".to_json
      elsif Product.find_by_pname(params[:pname])==nil
        render :json => "noproduct".to_json
      elsif @investfund==nil
        Investrecord.new do |i|
          i.username=params[:username]
          i.pname=params[:pname]
          i.date=params[:date]
          i.recordtype="fund"
          i.ordernum=ordernum
          i.recordvalue=params[:recordvalue].to_f
          i.save
        end
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end

    else
      if Webuser.find_by_username(params[:username])==nil
        render :json => "nouser".to_json
        else
          @investfund.update_attributes(:username=>params[:username],:date=>params[:date],
                                 :recordvalue=>params[:recordvalue].to_f)
      render :json => "s2".to_json
    end
  end
  end

  def funddeleteajax
    @investfund=Investrecord.find_by_id(params[:id])
    if @investfund!=nil
      @investinterests=Investrecord.find_all_by_username_and_recordtype_and_ordernum(@investfund.username,"interest",@investfund.ordernum)
    end
    if @investfund.destroy
      if @investinterests!=nil
        @investinterests.each do |i|
          i.destroy
        end
      end
      render :json => "s".to_json
    else
      render :json => "f".to_json
    end
  end

   def interestconfirm
     @interest=Investrecord.find_by_username_and_ordernum_and_date_and_pname(params[:username],params[:ordernum],params[:date],params[:pname])
     if @interest==nil
       Investrecord.new do |i|
         i.username=params[:username]
         i.date=params[:date]
         i.recordtype="interest"
         i.ordernum=params[:ordernum]
         i.recordvalue=params[:recordvalue].to_f
         i.pname=params[:pname]
         i.save
       end
       render :json => "s".to_json
     else
       render :json => "f".to_json
     end

   end

   def productrecords
     @product=Product.find_by_id(params[:id])
     @productrecords=Productrecord.find(:all,:conditions =>["pname=?",@product.pname], :order =>"date DESC")
   end

   def productrecordajax
     if params[:type]=="edit"
       @productrecord=Productrecord.find_by_id(params[:id])
       @product=Product.find_by_pname(@productrecord.pname)
       lastdate=Productrecord.find(:all,:conditions =>["pname=?",@productrecord.pname],:order =>"date DESC")[0].date
       if  @productrecord.date.to_date-lastdate>=0
         @product.update_attributes(:lastprofits=>params[:lastprofits].to_f,:todayprofit=>params[:todayprofit].to_f,
                                    :date=>@productrecord.date)
       end
       @invest_f=Investrecord.find(:all,:conditions =>["pname=? and recordtype=? and date<?",@productrecord.pname,"fund",@productrecord.date])
       @invest_i=Investrecord.find(:all,:conditions =>["pname=? and recordtype=? and date<?",@productrecord.pname,"interest",@productrecord.date])
       funds=0
       @invest_f.each do |i|
         funds=funds+i.recordvalue
       end
       interest=0
       @invest_i.each do |i|
         interest=interest+i.recordvalue
       end
       jsondate=[]
       jsondate[0]=params[:lastprofits].to_f+params[:todayprofit].to_f+interest
       jsondate[1]=funds
       jsondate[2]=interest
       jsondate[3]=params[:lastprofits].to_f+params[:todayprofit].to_f+interest-funds
     if @productrecord.update_attributes(:total=>params[:lastprofits].to_f+params[:todayprofit].to_f+interest,
                                       :allprofits=>params[:lastprofits].to_f+params[:todayprofit].to_f+interest-funds,
                                       :capital=>funds,:lastprofits=>params[:lastprofits].to_f,:todayprofit=>params[:todayprofit].to_f,
                                       :predividend=>interest)

       render :json => jsondate
     else
       render :json => "f".to_json
     end

     elsif params[:type]=="delete"
       if Productrecord.find_by_id(params[:id]).destroy
         render :json => "s".to_json
       else
         render :json => "f".to_json
        end
     end

     end

   def interestrecords
     @pname=Product.find_by_id(params[:id]).pname
     @interests=Investrecord.find_all_by_recordtype_and_pname("interest",@pname)
   end

   def interestrecordajax
     if params[:type]=="edit"
     @interestrecord=Investrecord.find_by_id(params[:id])
     if @interestrecord.update_attributes(:recordvalue=>params[:recordvalue].to_f)
       render :json => "s".to_json
     else
       render :json => "f".to_json
     end

     elsif params[:type]=="new"
       @interest=Investrecord.find_by_username_and_ordernum_and_date_and_pname(params[:username],params[:ordernum],params[:date],params[:pname])
       if @interest==nil
         Investrecord.new do |i|
           i.username=params[:username]
           i.date=params[:date]
           i.recordtype="interest"
           i.ordernum=params[:ordernum]
           i.recordvalue=params[:recordvalue].to_f
           i.pname=params[:pname]
           i.save
         end
         render :json => "s".to_json
       else
         render :json => "f".to_json
       end

       elsif  params[:type]=="delete"
         @interestrecord=Investrecord.find_by_id(params[:id])
       if  @interestrecord.destroy
         render :json => "s".to_json
       else
         render :json => "f".to_json
       end
     end

   end

   def bankfinanceconfig
     @bankfinanceinfo=[]
     if params[:id]!="0"
       @bankfinance=Bankfinance.find_by_id(params[:id])
       @bankfinanceinfo[0]=@bankfinance.bname
       @bankfinanceinfo[1]=@bankfinance.currencytype
       @bankfinanceinfo[2]=@bankfinance.btype
       @bankfinanceinfo[3]=@bankfinance.collectperiod
       @bankfinanceinfo[4]=@bankfinance.startvalue
       @bankfinanceinfo[5]=@bankfinance.investperiod
       @bankfinanceinfo[6]=@bankfinance.returnrate
       @bankfinanceinfo[7]=@bankfinance.trustee
       @bankfinanceinfo[8]=@bankfinance.status
       @bankfinanceinfo[9]=@bankfinance.sailsstart
       @bankfinanceinfo[10]=@bankfinance.distributionarea
       @bankfinanceinfo[11]=@bankfinance.ispickout
       @bankfinanceinfo[12]=@bankfinance.ispatent
     end
   end

   def bankfinanceconfigajax

     if params[:id]=="0"
         Bankfinance.new do |b|
           b.bname=params[:bname]
           b.currencytype=params[:currencytype]
           b.btype=params[:btype]
           b.collectperiod=params[:collectperiod]
           b.startvalue=params[:startvalue]
           b.investperiod=params[:investperiod]
           b.returnrate=params[:returnrate]
           b.trustee=params[:trustee]
           b.status=params[:status]
           b.sailsstart=params[:sailsstart]
           b.distributionarea=params[:distributionarea]
           b.ispickout=params[:ispickout]
           b.ispatent=params[:ispatent]
           b.save
         end
         render :json => "s1".to_json

     else
       @bankfinance=Bankfinance.find_by_id(params[:id])
       @bankfinance.update_attributes(:bname=>params[:bname],:currencytype=>params[:currencytype],:btype=>params[:btype],
                                      :collectperiod=>params[:collectperiod],:startvalue=>params[:startvalue],
                                      :sailsstart=>params[:sailsstart],:distributionarea=>params[:distributionarea],
                                      :investperiod=>params[:investperiod],:returnrate=>params[:returnrate],
                                      :trustee=>params[:trustee],:status=>params[:status],:ispickout=>params[:ispickout],
                                      :ispatent=>params[:ispatent])
       render :json => "s2".to_json
     end

   end

   def bankfinancedeleteajax
     @bankfinance=Bankfinance.find_by_id(params[:id])
     if @bankfinance!=nil
     if @bankfinance.destroy
       render :json => "s".to_json
     else
       render :json => "f".to_json
     end
     end
     end

   def blogconfig
     @bloginfo=[]
     if params[:id]!="0"
       @blog=Blog.find_by_id(params[:id])
       @bloginfo[0]=@blog.btitle
       @bloginfo[1]=@blog.blname
       @bloginfo[2]=@blog.publishdate
       @bloginfo[3]=@blog.barticle
       @bloginfo[4]=@blog.bcolumn
       @bloginfo[5]=@blog.imagepath
     end
   end

   def blogconfigajax

     if params[:id]=="0"
       Blog.new do |b|
         b.btitle=params[:btitle]
         b.blname=params[:blname]
         b.publishdate=params[:publishdate]
         b.barticle=params[:barticle]
         b.bcolumn=params[:bcolumn]
         b.imagepath=params[:imagepath]
         b.save
       end
       render :json => "s1".to_json

     else
       @blog=Blog.find_by_id(params[:id])
       @blog.update_attributes(:btitle=>params[:btitle],:blname=>params[:blname],:publishdate=>params[:publishdate],
                                      :barticle=>params[:barticle],:bcolumn=>params[:bcolumn],:imagepath=>params[:imagepath])
       render :json => "s2".to_json
     end

   end

   def blogdeleteajax
     @blog=Blog.find_by_id(params[:id])
     if @blog!=nil
       if @blog.destroy
         render :json => "s".to_json
       else
         render :json => "f".to_json
       end
     end
   end

   def upload_file(file)
     if !file.original_filename.empty?
       @filename=file.original_filename
       File.open("#{Rails.root}/app/assets/images/#{@filename}", "wb") do |f|
         f.write(file.read)
       end
       return @filename
     end
   end

   def get_file_name(filename)
     if !filename.nil?
       Time.now.strftime("%Y%m%d%H%M%S") + '_' + filename
     end
   end

   def save_file
     unless request.get?
       if filename=upload_file(params[:file]['file'])
         return filename
       end
     end
   end
   #==============================
   # 修改create方法：
   def create
     @photo = Photo.new(params[:photo])
     @filename=save_file   #调用save_file方法，返回文件名
     @photo.url="/images/#{@filename}"   #保存文件路径字段
     @photo.name=@filename   #保存文件名字段
     if @photo.save
       flash[:notice] = 'Photo was successfully created.'
       redirect_to :action => 'index'
     else
       render :action => 'index'
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