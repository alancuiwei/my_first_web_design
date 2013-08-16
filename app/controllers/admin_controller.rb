#encoding: utf-8
class AdminController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
  def index
    if session[:webusername]=="admin" || session[:webusername]=="blog"
      @webusers=Webuser.all
      @blogs=Blog.all
      @activity=Activity.all
      @pace=Pace.all
      @press=Press.all
      @methodology=Methodology.all
      @productcompany=Productcompany.all
      @salescompany=Salescompany.all
      @category1=Category_1.all
      @category2=Category_2.all
      @financial=Financial.all
      @expensetype=Admin_expense_type_month.all
      #user
      @hash_password={}
      @hash_remind={}
      @hash_confirm={}
      @webusers.each do |w|
        @hash_password.store(w.id,decode(w.password))
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def expenseconfig
      if params[:id]!="0"
        @expensetype=Admin_expense_type_month.find_by_id(params[:id])
      else
        @expensetype=Methodology.limit(1)
      end
  end

  def expenseconfigajax
    if params[:id]=="0"
      Admin_expense_type_month.new do |b|
        b.expense_id=params[:expense_id]
        b.expense_name=params[:expense_name]
        b.expense_intro=params[:expense_intro]
        b.expense_expect=params[:expense_expect]
        b.expense_type=params[:expense_type]
        b.save
      end
      render :json => "s1".to_json
    else
      @expensetype=Admin_expense_type_month.find_by_id(params[:id])
      @expensetype.update_attributes(:expense_id=>params[:expense_id],:expense_name=>params[:expense_name],:expense_intro=>params[:expense_intro],:expense_expect=>params[:expense_expect],:expense_type=>params[:expense_type])
      render :json => "s2".to_json
    end
  end

  def expensedeleteajax
    @expensetype=Admin_expense_type_month.find_by_id(params[:id])
    if @expensetype!=nil
      if @expensetype.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def methodconfig
      if params[:id]!="0"
        @methodology=Methodology.find_by_id(params[:id])
      else
        @methodology=Methodology.limit(1)
      end
  end

  def methodconfigajax
    if params[:id]=="0"
      Methodology.new do |b|
        b.mname=params[:mname]
        b.article=params[:article]
        b.picture=params[:picture]
        b.save
      end
      render :json => "s1".to_json
    else
      @methodology=Methodology.find_by_id(params[:id])
      @methodology.update_attributes(:mname=>params[:mname],:article=>params[:article],:picture=>params[:picture])
      render :json => "s2".to_json
    end
  end

  def methoddeleteajax
    @methodology=Methodology.find_by_id(params[:id])
    if @methodology!=nil
      if @methodology.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def pressconfig
      if params[:id]!="0"
        @press=Press.find_by_id(params[:id])
      else
        @press=Press.limit(1)
      end
  end

  def pressconfigajax
    if params[:id]=="0"
      Press.new do |b|
        b.pname=params[:pname]
        b.pdate=params[:pdate]
        b.pimg=params[:pimg]
        b.plink=params[:plink]
        b.save
      end
      render :json => "s1".to_json
    else
      @press=Press.find_by_id(params[:id])
      @press.update_attributes(:pname=>params[:pname],:pdate=>params[:pdate],:pimg=>params[:pimg],:plink=>params[:plink])
      render :json => "s2".to_json
    end
  end

  def pressdeleteajax
    @press=Press.find_by_id(params[:id])
    if @press!=nil
      if @press.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def paceconfig
      if params[:id]!="0"
        @pace=Pace.find_by_id(params[:id])
      else
        @pace=Pace.limit(1)
      end
  end

  def paceconfigajax
    if params[:id]=="0"
      Pace.new do |b|
        b.functionname=params[:functionname]
        b.introduce=params[:introduce]
        b.developtime=params[:developtime]
        b.ontime=params[:ontime]
        b.develop=params[:develop]
        b.auditor=params[:auditor]
        b.details=params[:details]
        b.save
      end
      render :json => "s1".to_json
    else
      @pace=Pace.find_by_id(params[:id])
      @pace.update_attributes(:functionname=>params[:functionname],:introduce=>params[:introduce],:developtime=>params[:developtime],:ontime=>params[:ontime],
                              :develop=>params[:develop],:auditor=>params[:auditor],:details=>params[:details])
      render :json => "s2".to_json
    end
  end

  def pacedeleteajax
    @pace=Pace.find_by_id(params[:id])
    if @pace!=nil
      if @pace.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
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
        b.ptype=params[:ptype]
        b.prisk=params[:prisk]
        b.returns=params[:returns]
        b.startvalue=params[:startvalue]
        b.risk1=params[:risk1]
        b.risk3=params[:risk3]
        b.risk5=params[:risk5]
        b.return1=params[:return1]
        b.return3=params[:return3]
        b.return5=params[:return5]
        b.rate12=params[:rate12]
        b.rate11=params[:rate11]
        b.rate10=params[:rate10]
        b.rate09=params[:rate09]
        b.rate08=params[:rate08]
        b.averagerate=params[:averagerate]
        b.save
      end
      render :json => "s1".to_json
    else
      @category2=Category_2.find_by_id(params[:id])
      @financial=Financial.find_all_by_category_and_classify(params[:category],params[:classify])
      for i in 0..@financial.size-1
        @financial[i].update_attributes(:risklevel=>params[:risklevel]);
      end
      @category2.update_attributes(:risk1=>params[:risk1],:risk3=>params[:risk3],:risk5=>params[:risk5],:return1=>params[:return1],:return3=>params[:return3],:return5=>params[:return5],
                                   :rate12=>params[:rate12],:rate11=>params[:rate11],:rate10=>params[:rate10],:rate09=>params[:rate09],:rate08=>params[:rate08],:averagerate=>params[:averagerate],
                                   :category=>params[:category],:risklevel=>params[:risklevel],:classify=>params[:classify],:ptype=>params[:ptype],:prisk=>params[:prisk],:returns=>params[:returns],:startvalue=>params[:startvalue])
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
        @productcompany=Productcompany.find_all_by_pname(@financial.pname)
      else
        @financial=Financial.limit(1)
        @productcompany=Productcompany.limit(1)
      end
      @salescompany=Salescompany.all
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
        b.rate1=params[:rate1]
        b.rate2=params[:rate2]
        b.rank=params[:rank]
        b.rank1=params[:rank1]
        b.rank2=params[:rank2]

        b.property=params[:property]
        b.bound=params[:bound]
        b.way=params[:way]

        b.startvalue=params[:startvalue]
        b.risklevel=@risklevel
        b.risktip=params[:risktip]
        b.pintroduction=params[:pintroduction]
        b.link=params[:link]
        b.investperiod=params[:investperiod]
        b.poundage=params[:poundage]
        b.productcode=params[:productcode]
        b.averrate=params[:averrate]
        b.level=params[:level]
        b.save
      end
      render :json => "s1".to_json
    else
      @financial=Financial.find_by_id(params[:id])
      @financial.update_attributes(:category=>params[:category],:pname=>params[:pname],:classify=>params[:classify],:trusts=>params[:trusts],:link=>params[:link],:productcode=>params[:productcode],:averrate=>params[:averrate],:level=>params[:level],
             :startvalue=>params[:startvalue],:risklevel=>@risklevel,:risktip=>params[:risktip],:pintroduction=>params[:pintroduction],:investperiod=>params[:investperiod],:poundage=>params[:poundage])
      if params[:classify]=='货币基金' && params[:property]=='互联网产品'
        @financial.update_attributes(:property=>params[:property],:bound=>params[:bound],:way=>params[:way])
      else
        @financial.update_attributes(:rate=>params[:rate],:rate1=>params[:rate1],:rate2=>params[:rate2],:rank=>params[:rank],:rank1=>params[:rank1],:rank2=>params[:rank2],:property=>'传统产品')
      end

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
        b.logo=params[:logo]
        b.license=params[:license]
        b.guide=params[:guide]
        b.time=params[:time]
        b.assist=params[:assist]
        b.save
      end
      render :json => "s1".to_json
    else
      @salescompany=Salescompany.find_by_id(params[:id])
      @salescompany.update_attributes(:fundname=>params[:fundname],:company=>params[:company],:capital=>params[:capital],:profile=>params[:profile],:introduced=>params[:introduced],
                                      :logo=>params[:logo],:license=>params[:license],:guide=>params[:guide],:time=>params[:time],:assist=>params[:assist])
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

  def poundageconfig
    if params[:id]!="0"
      @productcompany=Productcompany.find_by_id(params[:id])
    else
      @productcompany=Productcompany.limit(1)
    end
    @financial=Financial.all
    @salescompany=Salescompany.all
  end

  def poundageconfigajax
    if params[:id]=="0"
      Productcompany.new do |p|
        p.pname=params[:pname]
        p.fundname=params[:fundname]
        p.poundage=params[:poundage]
        p.link=params[:link]
        p.save
      end
      render :json => "s1".to_json
    else
      @productcompany=Productcompany.find_by_id(params[:id])
      @productcompany.update_attributes(:pname=>params[:pname],:fundname=>params[:fundname],:poundage=>params[:poundage],:link=>params[:link])
      render :json => "s2".to_json
    end
  end

  def poundagedeleteajax
    @productcompany=Productcompany.find_by_id(params[:id])
    if @productcompany!=nil
      if @productcompany.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def userconfig
    if params[:id]!="0"
      @webuser=Webuser.find_by_id(params[:id])
    end
  end

  def userlogout
    session[:webusername]=nil
    session[:qq]=nil
    render :json => "s".to_json
  end

  def  userconfigajax
    @webuser=Webuser.find_by_username(params[:username])
    if params[:password]!=nil
    password=encode(params[:password])
   end
    if params[:id]=="0"
      if @webuser==nil
        Webuser.new do |w|
          w.username=params[:username]
          w.password=password
          w.tel=params[:tel]
          w.email=params[:email]
          w.risktolerance=params[:risktolerance]
          w.save
        end

        Thread.new{
          if params[:ulogin]=="1"
            UserMailer.confirm(params[:username],params[:email],params[:tel],"新投资人首页注册").deliver
            UserMailer.welcome(params[:username],params[:email],"欢迎注册通天顺家庭理财").deliver
          end
        }
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    else
      @webuser.update_attributes(:email=>params[:email],:tel=>params[:tel])
      render :json => "s2".to_json
    end
  end

  def userajax
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      render :json => "f".to_json
    else
      render :json => "s".to_json
    end
  end

  def userdeleteajax
    @webuser=Webuser.find(params[:id])
    if @webuser.destroy
      render :json => "s".to_json
    else
      render :json => "f".to_json
    end
  end

  def userlogin
    if params[:login]!='qq'
      session[:qq]=1
    else
      session[:qq]=2
    end
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      if @webuser.password==encode(params[:password])
        if params[:organ]=='3'|| params[:organ]=='4'
          if  @webuser.username=="admin" || @webuser.username=="blog"
            session[:webusername]=@webuser.username
            render :json => "admin".to_json
          elsif @webuser.risktolerance!=nil
            session[:webusername]=@webuser.username
            render :json => "g1".to_json
          else
            session[:webusername]=@webuser.username
            render :json => "g2".to_json
          end
        else
          session[:webusername]=@webuser.username
          render :json => "s2".to_json
        end
      else
        render :json => "f".to_json
      end
    else
      render :json => "f2".to_json
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
        b.show=params[:show]
        b.save
      end
      render :json => "s1".to_json

    else
      @activity=Activity.find_by_id(params[:id])
      @activity.update_attributes(:name=>params[:name],:naturef=>params[:naturef],:natures=>params[:natures],
                              :organizer=>params[:organizer],:begintime=>params[:begintime],:endtime=>params[:endtime],
                              :introduce=>params[:introduce],:result=>params[:result],:charge=>params[:charge],
                              :address=>params[:address],:link=>params[:link],:reward=>params[:reward],:video=>params[:video],:show=>params[:show])
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