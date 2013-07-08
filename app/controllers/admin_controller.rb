#encoding: utf-8
class AdminController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
  def index
    if session[:webusername]=="admin" || session[:webusername]=="blog"
      @webusers=Webuser.find_by_sql('select * from webuser where address is not null and organuser<>"1"')
      @organuser=Webuser.find_by_sql('select * from webuser where address is not null and organuser="1"')
      @bankfinances=Bankfinance.all
      @bankfinance2=Bankfinance.find_all_by_isorgan(1)
      @blogs=Blog.all
      @activity=Activity.all
      @enroll=Enroll.all
      @salescompany=Salescompany.all
      @category1=Category_1.all
      @category2=Category_2.all
      @financial=Financial.all
      @products=Product.all
      @reserves=Reserve.all
      @bankproducts=Bankproducts_t.all
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

  def category1config
      if params[:id]!="0"
        @category1=Category_1.find_by_id(params[:id])
      else
        @category1=Category_1.limit(1)
      end
  end

  def category1configajax
    if params[:id]=="0"
      Category_1.new do |b|
        b.category=params[:category]
        b.save
      end
      render :json => "s1".to_json
    else
      @category1=Category_1.find_by_id(params[:id])
      @category1.update_attributes(:category=>params[:category])
      render :json => "s2".to_json
    end
  end

  def category1deleteajax
    @category1=Category_1.find_by_id(params[:id])
    if @category1!=nil
      if @category1.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def category2config
      @category1=Category_1.all
      if params[:id]!="0"
        @category2=Category_2.find_by_id(params[:id])
      else
        @category2=Category_2.limit(1)
      end
  end

  def category2configajax
    if params[:id]=="0"
      Category_2.new do |b|
        b.category=params[:category]
        b.risklevel=params[:risklevel]
        b.classify=params[:classify]
        b.save
      end
      render :json => "s1".to_json
    else
      @category2=Category_2.find_by_id(params[:id])
      @category2.update_attributes(:category=>params[:category],:risklevel=>params[:risklevel],:classify=>params[:classify])
      render :json => "s2".to_json
    end
  end

  def category2deleteajax
    @category2=Category_2.find_by_id(params[:id])
    if @category2!=nil
      if @category2.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def financialconfig
      if params[:id]!="0"
        @financial=Financial.find_by_id(params[:id])
      else
        @financial=Financial.limit(1)
      end
      @hash={}
      @category=Category_2.find_by_sql("select distinct category from category_2")
      for i in 0..@category.size-1
         @category2=Category_2.find_all_by_category(@category[i].category)
         for j in 0..@category2.size-1
           if j==0
             @cate='|'+@category2[j].classify
           else
             @cate=@cate+'|'+@category2[j].classify
           end
         end
         @hash.store(@category2[0].category,[i+1,@cate])
      end
  end

  def financialconfigajax
    @category2=Category_2.find_by_category_and_classify(params[:category],params[:classify])
    @risklevel=@category2.risklevel
    if params[:id]=="0"
      Financial.new do |b|
        b.category=params[:category]
        b.pname=params[:pname]
        b.classify=params[:classify]
        b.trusts=params[:trusts]
        b.rate=params[:rate]
        b.startvalue=params[:startvalue]
        b.risklevel=@risklevel
        b.risktip=params[:risktip]
        b.pintroduction=params[:pintroduction]
        b.link=params[:link]
        b.investperiod=params[:investperiod]
        b.poundage=params[:poundage]
        b.save
      end
      render :json => "s1".to_json
    else
      @financial=Financial.find_by_id(params[:id])
      @financial.update_attributes(:category=>params[:category],:pname=>params[:pname],:classify=>params[:classify],:trusts=>params[:trusts],:link=>params[:link],
             :rate=>params[:rate],:startvalue=>params[:startvalue],:risklevel=>@risklevel,:risktip=>params[:risktip],:pintroduction=>params[:pintroduction],:investperiod=>params[:investperiod],:poundage=>params[:poundage])
      render :json => "s2".to_json
    end
  end

  def financialdeleteajax
    @financial=Financial.find_by_id(params[:id])
    if @financial!=nil
      if @financial.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def companyconfig
      if params[:id]!="0"
        @salescompany=Salescompany.find_by_id(params[:id])
      else
        @salescompany=Salescompany.limit(1)
      end
  end

  def companyconfigajax
    if params[:id]=="0"
      Salescompany.new do |b|
        b.fundname=params[:fundname]
        b.company=params[:company]
        b.capital=params[:capital]
        b.profile=params[:profile]
        b.introduced=params[:introduced]
        b.save
      end
      render :json => "s1".to_json
    else
      @salescompany=Salescompany.find_by_id(params[:id])
      @salescompany.update_attributes(:fundname=>params[:fundname],:company=>params[:company],:capital=>params[:capital],:profile=>params[:profile],:introduced=>params[:introduced])
      render :json => "s2".to_json
    end
  end

  def companydeleteajax
    @salescompany=Salescompany.find_by_id(params[:id])
    if @salescompany!=nil
      if @salescompany.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def organapprove
    @webuser=Webuser.find_by_id(params[:id])
    @webuser.update_attributes(:approve=>nil)
    Thread.new{
      UserMailer.organuser(@webuser.username,@webuser.email).deliver
    }
    render :json => "s".to_json
  end

  def userconfig
    @userinfo=[]
    if params[:id]!="0"
      @webuser=Webuser.find_by_id(params[:id])
    end
  end

  def userlogout
    session[:webusername]=nil
    session[:qq]=nil
    render :json => "s".to_json
  end

  def productconfig
    if session[:webusername]!=nil
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
    else
      redirect_to(:controller=>"home")
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
    @personalfinance=Personalfinance.find_by_username(params[:username])
    if params[:password]!=nil
    password=encode(params[:password])
   end
    if params[:id]=="0"
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
        if params[:organuser]=='1'
          @organizationname=Organizationname.find_by_company(params[:company])
          if @organizationname==nil
            Organizationname.new do |w|
              w.company=params[:company]
              w.save
            end
          end
        end
       if params[:investamount]!=nil && params[:risk]==nil
        Personalfinance.new do |w|
          w.username=params[:username]
          w.investamount=params[:investamount]
          w.email=params[:email]
          w.save
        end
        end
#      session[:webusername]=params[:username]
        Thread.new{
          if params[:ulogin]=="1"
            UserMailer.confirm(params[:username],params[:email],params[:tel],"新投资人首页注册").deliver
          elsif  params[:ulogin]=="2"
            UserMailer.confirm(params[:username],params[:email],params[:tel],"新理财师首页注册").deliver
          else
            if params[:apply]!='1'
              if params[:risktolerance]!=nil && params[:issend]!='1'
                UserMailer.risktolerance(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
                UserMailer.login(params[:username],params[:asset_allocation],params[:wbreedinfo],"新用户注册&保存理财规划方案").deliver
              else
                UserMailer.login(params[:username],params[:asset_allocation],params[:wbreedinfo],"新用户注册&保存理财规划方案").deliver
              end
            else
              UserMailer.apply(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
              UserMailer.applyuser(params[:username],params[:tel],params[:asset_allocation],params[:wbreedinfo],"新用户注册&申请理财师服务").deliver
            end
          end
        }
        render :json => "s".to_json
      else
        if session[:webusername]!=nil
          Thread.new{
            if params[:apply]=='1'
              UserMailer.apply(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
              UserMailer.applyuser(params[:username],params[:tel],params[:asset_allocation],params[:wbreedinfo],params[:title]).deliver
            else
              UserMailer.login(params[:username],params[:asset_allocation],params[:wbreedinfo],"用户投资规划方案保存").deliver
              UserMailer.risktolerance(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
            end
          }
          @webuser=Webuser.find_by_username(session[:webusername])
          if params[:apply]!='1'
            @webuser.update_attributes(:email=>params[:email],:risktolerance=>params[:risktolerance])
          else
            @webuser.update_attributes(:tel=>params[:tel],:email=>params[:email],:risktolerance=>params[:risktolerance])
          end
          @personalfinance=Personalfinance.find_by_username(session[:webusername])
          if @personalfinance!=nil
            @personalfinance.update_attributes(:tel=>params[:tel],:email=>params[:email])
          end
          render :json => "f".to_json
        else
         if @webuser.approve!=1
          if params[:apply]=='1'
            @webuser=Webuser.find_by_username(params[:username])
            if @webuser.password==encode(params[:password])
              Thread.new{
                UserMailer.apply(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
                UserMailer.applyuser(params[:username],params[:tel],params[:asset_allocation],params[:wbreedinfo],params[:title]).deliver
              }
              @webuser.update_attributes(:tel=>params[:tel],:email=>params[:email],:risktolerance=>params[:risktolerance])
              @personalfinance=Personalfinance.find_by_username(session[:webusername])
              if @personalfinance!=nil
                @personalfinance.update_attributes(:tel=>params[:tel])
              end
              render :json => "r1".to_json
            else
              render :json => "r2".to_json
            end
          else
            @webuser=Webuser.find_by_username(params[:username])
            if @webuser.password==encode(params[:password])
              Thread.new{
                UserMailer.login(params[:username],params[:asset_allocation],params[:wbreedinfo],"保存理财规划方案").deliver
                UserMailer.risktolerance(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
              }
              @webuser.update_attributes(:tel=>params[:tel],:email=>params[:email],:risktolerance=>params[:risktolerance])
              @personalfinance=Personalfinance.find_by_username(session[:webusername])
              if @personalfinance!=nil
                @personalfinance.update_attributes(:tel=>params[:tel],:email=>params[:email])
              end
              render :json => "r3".to_json
            else
              render :json => "r4".to_json
            end
          end
         else
           render :json => "organ2".to_json
         end
        end
      end

    else
      if params[:update]!='1'
      @webuser.update_attributes(:password=>password,:tel=>params[:tel],:name=>params[:name],
                                 :address=>params[:address],:postcode=>params[:postcode],:email=>params[:email],:company=>params[:company],:memberlevel=>params[:memberlevel])
      @personalfinance.update_attributes(:name=>params[:name],:tel=>params[:tel],
                                         :company=>params[:company],:post=>params[:post],:email=>params[:email],:memberlevel=>params[:memberlevel])
      else
        @webuser.update_attributes(:email=>params[:email],:tel=>params[:tel],:dream=>params[:dream],:isauto=>params[:isauto],:confirm=>params[:confirm],:exeitdeposit=>params[:exeitdeposit],
                                   :amount=>params[:amount],:realizetime=>params[:realizetime],:monthpay=>params[:monthpay],:scharge=>params[:scharge],:remark=>params[:remark],
                                   :bankfinancep=>params[:bankfinancep],:deptp=>params[:deptp],:stockp=>params[:stockp],:trustp=>params[:trustp],:insurep=>params[:insurep])
      end
      render :json => "s2".to_json
    end
  end

  def  applyconfigajax
    @webuser=Webuser.find_by_username(params[:username])
    @personalfinance=Personalfinance.find_by_username(params[:username])
    password=encode(params[:password])
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
        w.save
      end
      Thread.new{
          UserMailer.risktolerance(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
          UserMailer.applyuser(params[:username],params[:tel],params[:asset_allocation],params[:wbreedinfo],"新用户注册&申请理财师服务").deliver
      }
      session[:webusername]=params[:username]
      render :json => "s".to_json
    else
      if session[:webusername]!=nil
        @webuser=Webuser.find_by_username(session[:webusername])
        @webuser.update_attributes(:email=>params[:email],:risktolerance=>params[:risktolerance])
        if @webuser.organuser=='1'
          Thread.new{
            UserMailer.apply(params[:username],params[:risktolerance],params[:email],"理财师申请额外服务").deliver
            UserMailer.applyuser(params[:username],params[:tel],params[:asset_allocation],params[:wbreedinfo],"理财师申请额外服务").deliver
          }
          render :json => "organ".to_json
        else
        Thread.new{
            UserMailer.apply(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
            UserMailer.applyuser(params[:username],params[:tel],params[:asset_allocation],params[:wbreedinfo],params[:title]).deliver
        }
        render :json => "f".to_json
        end
      else
        @webuser=Webuser.find_by_username(params[:username])
        if @webuser.password==encode(params[:password])
          if @webuser.organuser=='1'
            Thread.new{
              UserMailer.apply(params[:username],params[:risktolerance],params[:email],"理财师申请额外服务").deliver
              UserMailer.applyuser(params[:username],params[:tel],params[:asset_allocation],params[:wbreedinfo],"理财师申请额外服务").deliver
            }
          else
          Thread.new{
            UserMailer.apply(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
            UserMailer.applyuser(params[:username],params[:tel],params[:asset_allocation],params[:wbreedinfo],params[:title]).deliver
          }
          end
          @webuser.update_attributes(:tel=>params[:tel],:email=>params[:email],:risktolerance=>params[:risktolerance])
          session[:webusername]=params[:username]
          render :json => "r1".to_json
        else
          render :json => "r2".to_json
        end
      end
    end
  end


  def personajax
    @webuser=Webuser.find_by_username(session[:webusername])
    @webuser.update_attributes(:tel=>params[:tel])
    @personalfinance=Personalfinance.find_by_username(session[:webusername])
    @personalfinance.update_attributes(:tel=>params[:tel])
    render :json => "s".to_json
  end

  def userajax
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      render :json => "f".to_json
    else
      render :json => "s".to_json
    end
  end

  def risktoleranceajax
    if  session[:userlog]==1
      session[:userlog]=2
      Thread.new{
        UserMailer.risktolerance(params[:username],params[:risktolerance],params[:email],params[:title]).deliver
      }
      @webuser=Webuser.find_by_username(params[:username])
      @webuser.update_attributes(:risktolerance=>params[:risktolerance])
    end
    render :json => "f".to_json
  end

  # def email
  #     UserMailer.confirm(params[:username]).deliver
  #  end

  def emptykeyword
    @bankfinance=Bankfinance.find_by_productkeywords("newproduct")
    if @bankfinance!=nil
      Thread.new{
        UserMailer.emptykeyword.deliver
      }
    end
  end

  def reserve
    Thread.new{
      UserMailer.reserve(params[:username],params[:tel],params[:email],params[:bname],params[:trustee],
                         params[:btype],params[:startvalue],params[:investamount],params[:returnrate],
                         params[:investperiod],params[:sailsstart],params[:collectperiod]).deliver
    }
    render :json => "s".to_json
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
      @personalfinance=Personalfinance.find_all_by_username(@webuser.username)
      @personinvestinfo=Personinvestinfo.find_all_by_username(@webuser.username)
    end
    if @webuser.destroy
      if @investrecords!=nil
        @investrecords.each do |i|
          i.destroy
        end
      end
      if @personalfinance!=nil
        @personalfinance.each do |i|
          i.destroy
        end
      end
      if @personinvestinfo!=nil
        @personinvestinfo.each do |i|
          i.destroy
        end
      end
      render :json => "s".to_json
    else
      render :json => "f".to_json
    end
  end

  def userlogin
    if params[:login]!='qq'
      session[:qq]=1
    end
    @webuser=Webuser.find_by_username(params[:username])
    @personalfinance=Personalfinance.find_by_username(params[:username])
    if @personalfinance
      session[:personname]=@personalfinance.username
    else
      session[:personname]=0
    end
    if @webuser!=nil
      if @webuser.password==encode(params[:password])
        if @webuser.approve!=1
        if params[:organ]=='3'|| params[:organ]=='4'
          if  @webuser.organuser=='1'
            session[:webusername]=@webuser.username
            session[:organuser]=@webuser.organuser
              render :json => "organ".to_json
          elsif  @webuser.username=="admin" || @webuser.username=="blog"
            session[:webusername]=@webuser.username
            session[:organuser]='0'
            render :json => "admin".to_json
          elsif @webuser.risktolerance!=nil
            session[:webusername]=@webuser.username
            session[:organuser]='0'
            render :json => "g1".to_json
          else
            session[:webusername]=@webuser.username
            session[:organuser]='0'
            render :json => "g2".to_json
          end
        elsif  @personalfinance
          session[:webusername]=@webuser.username
          session[:organuser]='0'
          render :json => "s1".to_json
        else
          session[:webusername]=@webuser.username
          session[:organuser]='0'
          render :json => "s2".to_json
        end
      else
        render :json => "organ2".to_json
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
    @organizationname=Organizationname.all
    if session[:webusername]!=nil
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
        @bankfinanceinfo[13]=@bankfinance.productkeywords
        @bankfinanceinfo[14]=@bankfinance.invsetsubject
        @bankfinanceinfo[15]=@bankfinance.formula
        @bankfinanceinfo[16]=@bankfinance.risktip
        @bankfinanceinfo[17]=@bankfinance.ischosen
        @bankfinanceinfo[18]=@bankfinance.tong10
        @bankfinanceinfo[19]=@bankfinance.tong100
        @bankfinanceinfo[20]=@bankfinance.tong500
        @bankfinanceinfo[21]=@bankfinance.bank10
        @bankfinanceinfo[22]=@bankfinance.bank100
        @bankfinanceinfo[23]=@bankfinance.bank500
        @bankfinanceinfo[24]=@bankfinance.rate1
        @bankfinanceinfo[25]=@bankfinance.rate2
        @bankfinanceinfo[26]=@bankfinance.rate3
        @bankfinanceinfo[27]=@bankfinance.incometype
      else
        @bankfinance=Bankfinance.limit(1)
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def bankfinanceconfigajax
    if params[:id]=="0"
      Bankfinance.new do |b|
        b.bname=params[:bname]
        b.currencytype=params[:currencytype]
        b.btype=params[:btype]
        b.incometype=params[:incometype]
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
        b.productkeywords=params[:productkeywords]
        b.isorgan=params[:isorgan]
        b.name=params[:name]
        b.invsetsubject=params[:invsetsubject]
        b.formula=params[:formula]
        b.risktip=params[:risktip]
        b.ischosen=params[:ischosen]
        b.tong10=params[:tong10]
        b.tong100=params[:tong100]
        b.tong500=params[:tong500]
        b.bank10=params[:bank10]
        b.bank100=params[:bank100]
        b.bank500=params[:bank500]
        b.rate1=params[:rate1]
        b.rate2=params[:rate2]
        b.rate3=params[:rate3]
        b.save
      end
      render :json => "s1".to_json

    else
      @bankfinance=Bankfinance.find_by_id(params[:id])
      @bankfinance.update_attributes(:bname=>params[:bname],:currencytype=>params[:currencytype],:btype=>params[:btype],:incometype=>params[:incometype],
                                     :collectperiod=>params[:collectperiod],:startvalue=>params[:startvalue],
                                     :sailsstart=>params[:sailsstart],:distributionarea=>params[:distributionarea],
                                     :investperiod=>params[:investperiod],:returnrate=>params[:returnrate],
                                     :trustee=>params[:trustee],:status=>params[:status],:ispickout=>params[:ispickout],
                                     :ispatent=>params[:ispatent],:productkeywords=>params[:productkeywords],
                                     :isorgan=>params[:isorgan],:name=>params[:name],:invsetsubject=>params[:invsetsubject],
                                     :formula=>params[:formula],:risktip=>params[:risktip],:ischosen=>params[:ischosen],
                                     :tong10=>params[:tong10],:tong100=>params[:tong100],:tong500=>params[:tong500],
                                     :bank10=>params[:bank10],:bank100=>params[:bank100],:bank500=>params[:bank500],
                                     :rate1=>params[:rate1],:rate2=>params[:rate2],:rate3=>params[:rate3])
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

  def activityconfig
    if session[:webusername]!=nil
      @bloginfo=[]
      if params[:id]!="0"
        @activity=Activity.find_by_id(params[:id])
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def activityconfigajax
    if params[:id]=="0"
      Activity.new do |b|
        b.name=params[:name]
        b.naturef=params[:naturef]
        b.natures=params[:natures]
        b.organizer=params[:organizer]
        b.begintime=params[:begintime]
        b.endtime=params[:endtime]
        b.introduce=params[:introduce]
        b.result=params[:result]
        b.charge=params[:charge]
        b.address=params[:address]
        b.link=params[:link]
        b.reward=params[:reward]
        b.video=params[:video]
        b.save
      end
      render :json => "s1".to_json

    else
      @activity=Activity.find_by_id(params[:id])
      @activity.update_attributes(:name=>params[:name],:naturef=>params[:naturef],:natures=>params[:natures],
                              :organizer=>params[:organizer],:begintime=>params[:begintime],:endtime=>params[:endtime],
                              :introduce=>params[:introduce],:result=>params[:result],:charge=>params[:charge],
                              :address=>params[:address],:link=>params[:link],:reward=>params[:reward],:video=>params[:video])
      render :json => "s2".to_json
    end
  end

   def activitydeleteajax
     @activity=Activity.find_by_id(params[:id])
     if @activity!=nil
       if @activity.destroy
         render :json => "s".to_json
       else
         render :json => "f".to_json
       end
     end
   end

  def blogconfig
    if session[:webusername]!=nil
      @bloginfo=[]
      if params[:id]!="0"
        @blog=Blog.find_by_id(params[:id])
        @bloginfo[0]=@blog.btitle
        @bloginfo[1]=@blog.blname
        @bloginfo[2]=@blog.publishdate
        @bloginfo[3]=@blog.barticle
        @bloginfo[4]=@blog.bcolumn
        @bloginfo[5]=@blog.imagepath
        @bloginfo[6]=@blog.tag
      end
    else
      redirect_to(:controller=>"home")
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
        b.tag=params[:tag]
        b.save
      end
      render :json => "s1".to_json

    else
      @blog=Blog.find_by_id(params[:id])
      @blog.update_attributes(:btitle=>params[:btitle],:blname=>params[:blname],:publishdate=>params[:publishdate],
                              :barticle=>params[:barticle],:bcolumn=>params[:bcolumn],:imagepath=>params[:imagepath],:tag=>params[:tag])
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
      redirect_to "/assets/"+@filename
    else
      render :action => 'index'
    end
  end

  def reserveconfig
    if session[:webusername]!=nil
      @reserveinfo=[]
      if params[:id]!="0"
        @reserve=Reserve.find_by_id(params[:id])
        @reserveinfo[0]=@reserve.bname
        @reserveinfo[1]=@reserve.trustee
        @reserveinfo[2]=@reserve.btype
        @reserveinfo[3]=@reserve.bankbranch
        @reserveinfo[4]=@reserve.collectperiod
        @reserveinfo[5]=@reserve.investperiod
        @reserveinfo[6]=@reserve.returnrate
        @reserveinfo[7]=@reserve.investamount
        @reserveinfo[8]=@reserve.username
        @reserveinfo[9]=@reserve.tel
        @reserveinfo[10]=@reserve.managername
        @reserveinfo[11]=@reserve.managertel
        @reserveinfo[12]=@reserve.state
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def reserveconfigajax

    if params[:id]=="0"
      Reserve.new do |b|
        b.bname=params[:bname]
        b.trustee=params[:trustee]
        b.btype=params[:btype]
        b.bankbranch=params[:bankbranch]
        b.collectperiod=params[:collectperiod]
        b.investperiod=params[:investperiod]
        b.returnrate=params[:returnrate]
        b.investamount=params[:investamount]
        b.username=params[:username]
        b.tel=params[:tel]
        b.managername=params[:managername]
        b.managertel=params[:managertel]
        b.state=params[:state]
        b.email=params[:email]
        b.isuser=params[:isuser]
        b.bankcardnum=params[:bankcardnum]
        b.save
      end
      render :json => "s1".to_json

    else
      @reserve=Reserve.find_by_id(params[:id])
      @reserve.update_attributes(:bname=>params[:bname],:trustee=>params[:trustee],:btype=>params[:btype],
                                 :bankbranch=>params[:bankbranch],:collectperiod=>params[:collectperiod],
                                 :investperiod=>params[:investperiod],:returnrate=>params[:returnrate],
                                 :investamount=>params[:investamount],:username=>params[:username],
                                 :tel=>params[:tel],:managername=>params[:managername],:managertel=>params[:managertel],
                                 :state=>params[:state])
      render :json => "s2".to_json
    end
  end

  def reservedeleteajax
    @reserve=Reserve.find_by_id(params[:id])
    if @reserve!=nil
      if @reserve.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
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