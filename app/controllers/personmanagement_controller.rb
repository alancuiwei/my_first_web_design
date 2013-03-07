class PersonmanagementController < ApplicationController
  def  personinfo
    if session[:webusername]!=nil
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
        @personal[10]=@personalfinance.wprecommend
        @personal[11]=@personalfinance.contact
        @personal[12]=@personalfinance.myfavorite
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def investor
    @personalfinance=Personalfinance.all
    @personinvestinfo=Personinvestinfo.all
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
      b.wprecommend=params[:wprecommend]
      b.post=params[:post]
      b.contact=params[:contact]
      b.myfavorite=params[:myfavorite]
      b.save
    end
    session[:personname]=session[:webusername]
    render :json => "s1".to_json
    else
      @personalfinance=Personalfinance.find_by_username(session[:webusername])
      @personalfinance.update_attributes(:username=>params[:username],:email=>params[:email],:investamount=>params[:investamount],
                                :investcycle=>params[:investcycle],:returnrate=>params[:returnrate],:company=>params[:company],
                                :age=>params[:age],:riskrate=>params[:riskrate],:investvarieties=>params[:investvarieties],
                                :wbreedinfo=>params[:wbreedinfo],:wprecommend=>params[:wprecommend],:post=>params[:post],
                                :contact=>params[:contact],:myfavorite=>params[:myfavorite])
      render :json => "s1".to_json
    end
  end

  def myfavoriteconfigajax
    @personalfinance=Personalfinance.find_by_username(session[:webusername])
    @personalfinance.update_attributes(:myfavorite=>params[:myfavorite])
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
    @personalfinance=Personalfinance.find_by_username(session[:webusername])
    @personalinfo=Personinvestinfo.find_all_by_username(session[:webusername])
  end
end