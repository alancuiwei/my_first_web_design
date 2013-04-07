class PersonmanagementController < ApplicationController
  def  personinfo
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @personal=[]
      if params[:id]!="0"
        @personalfinance=Personalfinance.find_by_username(session[:webusername])
        @personal[0]=@personalfinance.age
        @personal[1]=@personalfinance.company
        @personal[2]=@personalfinance.post
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
    else
      redirect_to(:controller=>"home")
    end
  end

  def organfinance
    @personalfinance=Personalfinance.all
    @personinvestinfo=Personinvestinfo.all
    @webuser=Webuser.find_by_id(params[:id])
    if session[:webusername]!=nil
      @webuser2=Webuser.find_by_username(session[:webusername])
    else
      @webuser2=Webuser.find_by_username(@webuser.username)
    end
    @bankfinances=Bankfinance.find_all_by_isorgan_and_name(1,@webuser.username)
    if  params[:id]!=nil
    @comments=Comments.find_all_by_wid(params[:id])
    else
    redirect_to(:controller=>"home")
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
    @personalfinance=Personalfinance.all
   # @personalfinance2=Personalfinance.find_all_by_memberlevel("1")
    @personinvestinfo=Personinvestinfo.all
    @webuser=Webuser.find_all_by_organuser("1")
  end

  def personconfigajax
    if params[:id]=="0"
    Personalfinance.new do |b|
      b.username=params[:username]
      b.email=params[:email]
      b.investamount=params[:investamount]
      b.investcycle=params[:investcycle]
      b.returnrate=params[:returnrate]
      b.company=params[:company]
      b.age=params[:age]
      b.riskrate=params[:riskrate]
      b.investvarieties=params[:investvarieties]
      b.wbreedinfo=params[:wbreedinfo]
      b.name=params[:name]
      b.post=params[:post]
      b.contact=params[:contact]
      b.myfavorite=params[:myfavorite]
      b.tel=params[:tel]
      b.memberlevel=params[:memberlevel]
      b.save
    end
    session[:personname]=params[:username]
    render :json => "s1".to_json
    else
      @personalfinance=Personalfinance.find_by_username(session[:webusername])
      @personalfinance.update_attributes(:username=>params[:username],:email=>params[:email],:investamount=>params[:investamount],
                                :investcycle=>params[:investcycle],:returnrate=>params[:returnrate],:company=>params[:company],
                                :age=>params[:age],:riskrate=>params[:riskrate],:investvarieties=>params[:investvarieties],
                                :wbreedinfo=>params[:wbreedinfo],:name=>params[:name],:post=>params[:post],
                                :contact=>params[:contact],:myfavorite=>params[:myfavorite],:tel=>params[:tel],:memberlevel=>params[:memberlevel])
      render :json => "s1".to_json
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

    if  params[:id]!=nil
        @comments=Comments.find_all_by_cid(params[:id])
      @personalfinance=Personalfinance.find_by_id(params[:id])
      @personalinfo=Personinvestinfo.find_all_by_username(@personalfinance.username)
      if session[:webusername]!=nil
         @webuser=Webuser.find_by_username(session[:webusername])
      else
         @webuser=Webuser.find_by_username(@personalfinance.username)
     end
    else
       if session[:webusername]!=nil
    @personalfinance=Personalfinance.find_by_username(session[:webusername])
    @personalinfo=Personinvestinfo.find_all_by_username(session[:webusername])
          @comments=Comments.find_all_by_cid(@personalfinance.id)
          @webuser=Webuser.find_by_username(session[:webusername])
       end
    end
    if @personalfinance==nil
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
      Provide.new do |b|
        b.username=params[:username]
        b.managename=params[:managename]
        b.stock=params[:stock]
        b.debt=params[:debt]
        b.trust=params[:trust]
        b.bankfinance=params[:bankfinance]
        b.filename= @filename
        b.save
      end
      @webuser=Webuser.find_by_username(session[:webusername])
      flash[:notice] = 'Photo was successfully created.'
      redirect_to(:controller=>"personmanagement", :action=>"organfinance", :id=>@webuser.id)
    else
      render :action => 'investor'
    end
  end
end