#encoding: utf-8
class PersonmanagementController < ApplicationController
  def  personinfo
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @personal=[]
      if params[:id]!="0"
        @personalfinance=Personalfinance.find_by_username(session[:webusername])
        if @personalfinance
        @personal[0]=@personalfinance.age
        @personal[1]=@personalfinance.trade
        @personal[3]=@personalfinance.email
        @personal[4]=@personalfinance.investamount
        @personal[5]=@personalfinance.investcycle
        @personal[6]=@personalfinance.returnrate
        @personal[7]=@personalfinance.riskrate
        @personal[8]=@personalfinance.investvarieties
        @personal[9]=@personalfinance.wbreedinfo
        @personal[10]=@personalfinance.name
        @personal[11]=@personalfinance.contact
        @personal[12]=@personalfinance.myfavorite
        @personal[13]=@personalfinance.tel
        @personal[14]=@personalfinance.memberlevel
      end
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def selectproduct
    @webuser = Webuser.find_by_username(params[:username])
    @webuser.update_attributes(:selection=>params[:selection])
    render :json => "s".to_json
  end

   def movablewall
     @activity=Activity.find_by_sql("select * from activity order by id desc")
   end

   def activity
    if params[:id]!=nil
      @activity=Activity.find_by_id(params[:id])
      @enroll=Enroll.find_all_by_aid_and_ischarge(params[:id],0)
    else
      redirect_to(:controller=>"personmanagement", :action=>"movablewall")
    end
   end

  def enroll
    @enroll=Enroll.find_by_name_and_username(params[:name],params[:username])
    if @enroll==nil
      Enroll.new do |b|
        b.name=params[:name]
        b.username=params[:username]
        b.ischarge=1
        b.aid=params[:aid]
        b.save
      end
    elsif params[:ischarge]=='0'
      @enroll.update_attributes(:ischarge=>0,:name=>params[:name],:username=>params[:username],:aid=>params[:aid]);
    end
  end

  def enrollapprove
    @enroll=Enroll.find_by_id(params[:aid])
    @enroll.update_attributes(:ischarge=>0);
    render :json => "s".to_json
  end

  def zhifubao
    @webuser = Webuser.find_by_username(session[:webusername])
    Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
    @subsribe_id=Time.now.to_s(:stamp)+'-'+@webuser.username
    if session[:webusername]=='tester'
      @tester='0.01'
    else
      @tester=params[:scharge]
    end
    parameters = {
        'service' => 'create_partner_trade_by_buyer',
        'partner' => '2088801189204575',
        '_input_charset' => 'utf-8',
        'return_url' => 'http://www.tongtianshun.com/personmanagement/activity/'+params[:aid]+'?username='+session[:webusername],
        'seller_email' => 'zhongrensoft@gmail.com',
        'out_trade_no' => @subsribe_id,
        'subject' => '活动报名',
        'price' => @tester,
        'quantity' => '1',
        'payment_type' => '1',
        'logistics_type'=>'EMS',
        'logistics_fee' => '0',
        'logistics_payment'=>'BUYER_PAY',
        'logistics_type_1'=>'POST',
        'logistics_fee_1' => '0',
        'logistics_payment_1'=>'BUYER_PAY',
        'logistics_type_2'=>'EXPRESS',
        'logistics_fee_2' => '0',
        'logistics_payment_2'=>'BUYER_PAY'
    }
    values = {}
    # 支付宝要求传递的参数必须要按照首字母的顺序传递，所以这里要sort
    parameters.keys.sort.each do |k|
      values[k] = parameters[k];
    end
    # 一定要先unescape后再生成sign，否则支付宝会报ILLEGAL SIGN
    sign = Digest::MD5.hexdigest(CGI.unescape(values.to_query) + 'xf1fj8kltbbc766co0ziulq1wowejpzm')
    gateway = 'https://mapi.alipay.com/gateway.do?'
    @alipy_url= gateway + values.to_query + '&sign=' + sign + '&sign_type=MD5'
    render :json => @alipy_url.to_json
  end

  def organfinance
    if session[:webusername]==nil &&  params[:id]==nil
      redirect_to(:controller=>"home")
    else
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
        @comments=Comments.find_all_by_wid(params[:id])
        @webusers=Webuser.find_all_by_organusername(@webuser.username)
      else
        @webusers=Webuser.find_all_by_organusername(session[:webusername])
        @webuser=Webuser.find_by_username(session[:webusername])
        @comments=Comments.find_all_by_wid(@webuser.id)
      end
      if session[:webusername]!=nil
        @webuser2=Webuser.find_by_username(session[:webusername])
      else
        @webuser2=Webuser.find_by_username(@webuser.username)
      end
      @bankfinances=Bankfinance.find_all_by_isorgan_and_name(1,@webuser.username)
      @personinvestinfo=Personinvestinfo.all
      @hash={}
      for i in 0..@webusers.size-1
        @provide=Provide.find_by_username_and_managename(@webusers[i].username,session[:webusername])
        if @provide!=nil
        @hash.store(@webusers[i].username,[1,@webusers[i].exeitdeposit,@provide.stock,@provide.debt,@provide.bankfinance,@provide.insure,@provide.trust])
        else
          @hash.store(@webusers[i].username,[0,@webusers[i].exeitdeposit,nil,nil,nil,nil,nil])
        end
      end
    end
  end

  def commentconfigajax
    Comments.new do |b|
      b.username=params[:username]
      b.email=params[:email]
      b.comments=params[:comment]
      b.cid=params[:cid]
      b.time=params[:time]
      b.memberlevel=params[:memberlevel]
      b.company=params[:company]
      b.wid=params[:wid]
      b.save
    end
    if  params[:email2]=='1'
      Thread.new{
        UserMailer.comments(params[:username],params[:company],params[:comment],params[:accept],params[:aid]).deliver
      }
    end
    render :json => "s1".to_json
  end


  def comment2configajax
    Comments.new do |b|
      b.username=params[:username]
      b.email=params[:email]
      b.comments=params[:comment]
      b.cid=params[:cid]
      b.time=params[:time]
      b.memberlevel=params[:memberlevel]
      b.company=params[:company]
      b.wid=params[:wid]
      b.save
    end
    if  params[:email2]=='1'
      Thread.new{
        UserMailer.comments2(params[:username],params[:company],params[:comment],params[:accept],params[:aid]).deliver
      }
    end
    render :json => "s1".to_json
  end

  def comment3configajax
    Comments.new do |b|
      b.username=params[:username]
      b.email=params[:email]
      b.comments=params[:comments]
      b.time=params[:time]
      b.company=params[:company]
      b.pid=params[:pid]
      b.save
    end
    if  params[:email2]=='1'
      Thread.new{
        UserMailer.comments2(params[:username],params[:company],params[:comment],params[:accept],params[:aid]).deliver
      }
    end
    render :json => "s1".to_json
  end

  def investor
    @webuser=Webuser.find_by_sql("select * from webuser where id<>3 and id<>54 and (organuser='0' || organuser is null) and scharge is not null")
   if  session[:webusername]!=nil
    @webusers=Webuser.find_by_username(session[:webusername])
   else
     @webusers=Webuser.find_by_username('admin')
    end
    @hash_reference=Hash.new
    @webuser.each do |webuser|
        @hash_reference.store(webuser.id,[webuser.exeitdeposit,webuser.username,webuser.province,webuser.city])
    end
    @hash={}
    @webuser2=Webuser.find_by_sql("select * from webuser where organusername is not null");
    for i in 0..@webuser2.size-1
      @provide=Provide.find_by_username(@webuser2[i].username)
      if @provide!=nil
        date=1
      else
        date=nil
      end
      @hash.store(@webuser2[i].username,[date])
    end
  end

  def share
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

  def stasus
    @webuser=Webuser.find_by_id(params[:oid])
    @webuser.update_attributes(:organusername=>session[:webusername])
    @webuser2=Webuser.find_by_username(session[:webusername])
    Thread.new{
      UserMailer.handling(session[:webusername],@webuser2.company,@webuser.username,@webuser.email).deliver
    }
    render :json => "s".to_json
  end

  def personconfigajax
    if params[:id]=="0"
      if session[:webusername]==nil
      @personalfinance=Personalfinance.find_by_username(params[:username])
      else
        @webuser=Webuser.find_by_username(session[:webusername])
        @personalfinance=Personalfinance.find_by_username(session[:webusername])
        @webuser.update_attributes(:risktolerance=>params[:risktolerance]);
      end
      if @personalfinance==nil
        Personalfinance.new do |b|
          b.username=params[:username]
          b.email=params[:email]
          b.investamount=params[:investamount]
          b.investcycle=params[:investcycle]
          b.returnrate=params[:returnrate]
          b.age=params[:age]
          b.riskrate=params[:riskrate]
          b.investvarieties=params[:investvarieties]
          b.wbreedinfo=params[:wbreedinfo]
          b.name=params[:name]
          b.contact=params[:contact]
          b.myfavorite=params[:myfavorite]
          b.tel=params[:tel]
          b.memberlevel=params[:memberlevel]
          b.trade=params[:trade]
          b.fluctuation=params[:fluctuation]
          b.quota=params[:quota]
          b.save
        end
        session[:personname]=params[:username]
        render :json => "s1".to_json
      else
        @personalfinance.update_attributes(:age=>params[:age],:email=>params[:email],:fluctuation=>params[:fluctuation],
                                           :quota=>params[:quota],:investamount=>params[:investamount],:returnrate=>params[:returnrate],
                                           :investcycle=>params[:investcycle],:wbreedinfo=>params[:wbreedinfo],:trade=>params[:trade],
                                           :riskrate=>params[:riskrate])
        if  params[:tel]!=nil
          @personalfinance.update_attributes(:tel=>params[:tel])
        end
        session[:personname]=params[:username]
        render :json => "s2".to_json
      end
    else
      @personalfinance=Personalfinance.find_by_username(session[:webusername])
      @personalfinance.update_attributes(:username=>params[:username],:email=>params[:email],:investamount=>params[:investamount],
                                         :investcycle=>params[:investcycle],:returnrate=>params[:returnrate],:trade=>params[:trade],
                                         :age=>params[:age],:riskrate=>params[:riskrate],:investvarieties=>params[:investvarieties],
                                         :wbreedinfo=>params[:wbreedinfo],:name=>params[:name],:contact=>params[:contact],:bank=>params[:bank],
                                         :myfavorite=>params[:myfavorite],:tel=>params[:tel],:memberlevel=>params[:memberlevel])
      render :json => "sd".to_json
    end
  end

  def myfavoriteconfigajax
    @personalfinance=Personalfinance.find_by_username(session[:webusername])
    @personalfinance.update_attributes(:myfavorite=>params[:myfavorite])
    render :json => "s1".to_json
  end

  def profileconfigajax
    @personalfinance=Personalfinance.find_by_username(session[:webusername])
    @personalfinance.update_attributes(:title=>params[:title],:article=>params[:article])
    render :json => "s1".to_json
  end

  def personinfoconfigajax
    if params[:id]=="0"
      Personinvestinfo.new do |b|
        b.username=params[:username]
        b.producttype=params[:producttype]
        b.percentage=params[:percentage]
        b.investamount=params[:investamount]
        b.purchasproducts=params[:purchasproducts]
        b.collectperiod=params[:collectperiod]
        b.save
      end
      render :json => "s1".to_json
    else
      @person=Personinvestinfo.find_by_id(params[:id])
      @person.update_attributes(:username=>params[:username],:producttype=>params[:producttype],:percentage=>params[:percentage],
                                :investamount=>params[:investamount],:purchasproducts=>params[:purchasproducts],:collectperiod=>params[:collectperiod])
      render :json => "s2".to_json
    end
  end

  def record
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
        @record=Record.find_all_by_username(@webuser.username)
      elsif session[:webusername]!=nil
        @record=Record.find_all_by_username(session[:webusername])
      else
         redirect_to(:controller=>"home")
      end
  end

  def personinformation
    if session[:webusername]!=nil
      @personalfinance=Personalfinance.find_by_username(session[:webusername])
      @personalinfo2=Personinvestinfo.find_all_by_username(session[:webusername])
      @personal=[]
      if params[:id]!="0"
        @personalinfo=Personinvestinfo.find_by_id(params[:id])
        @personal[0]=@personalinfo.producttype
        @personal[1]=@personalinfo.percentage
        @personal[2]=@personalinfo.investamount
        @personal[3]=@personalinfo.purchasproducts
        @personal[4]=@personalinfo.collectperiod
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def recordconfigajax
    Record.new do |r|
      r.username=params[:username]
      r.date=params[:date]
      r.pname=params[:pname]
      r.amount=params[:amount]
      r.nature=params[:nature]
      r.save
    end
    render :json => "s1".to_json
  end

  def personfinance
    @financial=Financial.all
    @finance=Financial.find_by_sql("select * from financial where person is not null and person<>''")
    @hash3={}
    for i in 0..@finance.size-1
      @hash3.store(@finance[i].person,[@finance[i].pname,@finance[i].id,@finance[i].classify])
    end
    @hash3.store('风险1',['定期存款','','定期存款'])
    if  session[:webusername]!=nil
      @webusers=Webuser.find_by_username(session[:webusername])
    else
      @webusers=Webuser.find_by_username('admin')
    end
    if  params[:id]!=nil
      @webuser=Webuser.find_by_id(params[:id])
      @record=Record.find_all_by_username(@webuser.username)
      @finances=Financial.find_by_selection(@webuser.selection)
      if @finances!=nil
      @hash3.store(@finances.person,[@finances.pname,@finances.id,@finances.classify])
      end
      @examination=Examination.find_by_username(@webuser.username)
      @record=Record.find_all_by_username(@webuser.username)
      @comments=Comments.find_all_by_pid(params[:id])
      @provides=Provide.find_by_username(@webuser.username)
      if @webuser.organusername!=nil
        @webuser2=Webuser.find_by_username(@webuser.organusername)
      else
        @webuser2=Webuser.find_by_username("admin")
      end
      @hash2=Hash.new
      if @provides!=nil
        @hash2.store(0,[@provides.company,@provides.managename,@provides.id,@provides.stock,@provides.debt,@provides.insure,@provides.bankfinance,@provides.filename,@provides.trust])
      else
        @hash2.store(0,[nil,nil,nil,nil,nil,nil,nil,nil,nil])
      end

      @hash=Hash.new
      @add=Personalfinance.find_by_username(@webuser.username)
      if @add!=nil
        @hash.store(0,[@add.investamount,@add.wbreedinfo,@add.age,@add.investcycle,@add.trade,@add.returnrate,@add.riskrate,@add.fluctuation,@add.quota,@add.bank])
      else
        @hash.store(0,[0,nil,nil,nil,nil,nil,nil,nil,nil,nil])
      end
    elsif session[:webusername]!=nil
        @webuser=Webuser.find_by_username(session[:webusername])
        @record=Record.find_all_by_username(session[:webusername])
        @finances=Financial.find_by_pname(@webuser.selection)
        if @finances!=nil
        @hash3.store(@finances.pname,[@finances.pname,@finances.id,@finances.classify])
        end
        @examination=Examination.find_by_username(@webuser.username)
        @record=Record.find_all_by_username(@webuser.username)
        @comments=Comments.find_all_by_pid(@webuser.id)
        if @webuser.organusername!=nil
          @webuser2=Webuser.find_by_username(@webuser.organusername)
        else
          @webuser2=Webuser.find_by_username("admin")
        end
      @provides=Provide.find_by_username(@webuser.username)
      @hash2=Hash.new
      if @provides!=nil
        @hash2.store(0,[@provides.company,@provides.managename,@provides.id,@provides.stock,@provides.debt,@provides.insure,@provides.bankfinance,@provides.filename,@provides.trust])
      else
        @hash2.store(0,[nil,nil,nil,nil,nil,nil,nil,nil,nil])
      end

      @hash=Hash.new
      @add=Personalfinance.find_by_username(@webuser.username)
      if @add!=nil
        @hash.store(0,[@add.investamount,@add.wbreedinfo,@add.age,@add.investcycle,@add.trade,@add.returnrate,@add.riskrate,@add.fluctuation,@add.quota,@add.bank])
      else
        @hash.store(0,[0,nil,nil,nil,nil,nil,nil,nil,nil,nil])
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def upload_file(file)
    if !file.original_filename.empty?
      @filename=get_file_name(file.original_filename)
      File.open("#{Rails.root}/app/assets/download/#{@filename}", "wb") do |f|
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
    @photo.url="/download/#{@filename}"   #保存文件路径字段
    @photo.name=@filename   #保存文件名字段
    if @photo.save
      @provides=Provide.find_by_username_and_managename(params[:username],params[:managename])
     if @provides==nil
      Provide.new do |b|
        b.username=params[:username]
        b.managename=params[:managename]
        b.stock=params[:stock]
        b.debt=params[:debt]
        b.insure=params[:insure]
        b.bankfinance=params[:bankfinance]
        b.trust=params[:trust]
        b.company=params[:company]
        b.filename= @filename
        b.save
      end
     else
       flag = FileTest::exist?("#{Rails.root}/app/assets/download/"+@provides.filename)
       if flag==true
       File.delete("#{Rails.root}/app/assets/download/"+@provides.filename)
       end
       @provides.update_attributes(:stock=>params[:stock],:debt=>params[:debt],:insure=>params[:insure],:bankfinance=>params[:bankfinance],:trust=>params[:trust],:filename=>@filename)
     end
      @webuser=Webuser.find_by_username(session[:webusername])
      @webuser2=Webuser.find_by_username(params[:username])
      Thread.new{
        UserMailer.notify(params[:username],@webuser2.email,@webuser2.id,'理财师为您提供理财规划方案').deliver
      }
      flash[:notice] = 'Photo was successfully created.'
      redirect_to(:controller=>"personmanagement", :action=>"organfinance", :id=>@webuser.id)
    else
      render :action => 'investor'
    end
  end
end