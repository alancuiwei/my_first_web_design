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
        @hash.store(@webusers[i].username,[1,@webusers[i].exeitdeposit,@provide.stock,@provide.debt,@provide.bankfinance,@provide.insure])
        else
          @hash.store(@webusers[i].username,[0,@webusers[i].exeitdeposit,nil,nil,nil,nil])
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

  def investor
    @webuser=Webuser.find_by_sql("select * from webuser where id<>3 and id<>54 and organuser<>'2' and (organuser='0' || organuser is null) and scharge is not null")
   if  session[:webusername]!=nil
    @webusers=Webuser.find_by_username(session[:webusername])
   else
     @webusers=Webuser.find_by_username('admin')
    end
    @hash_reference=Hash.new
    @webuser.each do |webuser|
      @add=Personalfinance.find_by_username(webuser.username)
      if @add!=nil
        @hash_reference.store(webuser.id,[@add.investamount,webuser.username,webuser.province,webuser.city])
      else
        @hash_reference.store(webuser.id,[nil,webuser.username,webuser.province,webuser.city])
      end
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
          b.bank=params[:bank]
          b.save
        end
        session[:personname]=params[:username]
        render :json => "s1".to_json
      else
        @personalfinance.update_attributes(:age=>params[:age],:email=>params[:email],:fluctuation=>params[:fluctuation],
                                           :quota=>params[:quota],:investamount=>params[:investamount],:returnrate=>params[:returnrate],
                                           :investcycle=>params[:investcycle],:wbreedinfo=>params[:wbreedinfo],:trade=>params[:trade],
                                           :riskrate=>params[:riskrate],:bank=>params[:bank])
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

  def personfinance
    if  session[:webusername]!=nil
      @webusers=Webuser.find_by_username(session[:webusername])
    else
      @webusers=Webuser.find_by_username('admin')
    end
    if  params[:id]!=nil
      @webuser=Webuser.find_by_id(params[:id])

      @provides=Provide.find_by_username(@webuser.username)
      if @webuser.organusername!=nil
        @webuser2=Webuser.find_by_username(@webuser.organusername)
      else
        @webuser2=Webuser.find_by_username("admin")
      end
      @hash2=Hash.new
      if @provides!=nil
        @hash2.store(0,[@provides.company,@provides.managename,@provides.id,@provides.stock,@provides.debt,@provides.insure,@provides.bankfinance,@provides.filename])
      else
        @hash2.store(0,[nil,nil,nil,nil,nil,nil,nil,nil])
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
        if @webuser.organusername!=nil
          @webuser2=Webuser.find_by_username(@webuser.organusername)
        else
          @webuser2=Webuser.find_by_username("admin")
        end
      @provides=Provide.find_by_username(@webuser.username)
      @hash2=Hash.new
      if @provides!=nil
        @hash2.store(0,[@provides.company,@provides.managename,@provides.id,@provides.stock,@provides.debt,@provides.insure,@provides.bankfinance,@provides.filename])
      else
        @hash2.store(0,[nil,nil,nil,nil,nil,nil,nil,nil])
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
        b.company=params[:company]
        b.filename= @filename
        b.save
      end
     else
       flag = FileTest::exist?("#{Rails.root}/app/assets/download/"+@provides.filename)
       if flag==true
       File.delete("#{Rails.root}/app/assets/download/"+@provides.filename)
       end
       @provides.update_attributes(:stock=>params[:stock],:debt=>params[:debt],:insure=>params[:insure],:bankfinance=>params[:bankfinance],:filename=>@filename)
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