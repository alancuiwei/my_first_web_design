#encoding: utf-8
class WebusersController < ApplicationController
  layout "application"  ,:except=>[:edit]
  #layout "webusers"  ,:only=>[:show]
  # GET /webusers
  # GET /webusers.json
  def index
    @webusers = Webuser.order(:name)
    @hash_level= Hash[0,"普通用户",1,"收费用户",99,"试用用户"]
	if session[:webuser_name]=="administrator"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @webusers }
    end
	else
	redirect_to(:controller=>"home", :action=>"index")
	end
  end

  # GET /webusers/1
  # GET /webusers/1.json
  def show
    @webuser = Webuser.find(params[:id])
    @hash_level= Hash[0,"普通用户",1,"收费用户",99,"试用用户"]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webuser }
    end
  end

  # GET /webusers/new
  # GET /webusers/new.json
  def new
    @webuser = Webuser.new
#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @webuser }
#    end
  end

  # GET /webusers/1/edit
  def edit
    @webuser = Webuser.find(params[:id])
    render:layout=>'webusers'
  end

  # POST /webusers
  # POST /webusers.json
  def create
    @webuser = Webuser.new(params[:webuser])
    @webuser.level=0
    @webuser.collect=""
    respond_to do |format|
      if @webuser.save
	    session[:webuser_name] = @webuser.name

      StrategyparamT.new do |s|
        s.strategyid="010001"
        s.paramname="returnrate"
        s.paramvalue=0.1
        s.username=session[:webuser_name]
        s.save
      end
      #new usercommodiy
      @usercommodity=UsercommodityT.find_all_by_userid("tester1")
      i=0
      while @usercommodity[i]!=nil
      UsercommodityT.new do |u|
       u.commodityid = @usercommodity[i].commodityid
       u.userid=@webuser.name
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

        format.html { redirect_to(:controller=>"home", :action=>"index")}
        format.json { render json: @webuser, status: :created, location: @webuser }
      else
        format.html { render action: "new" }
        format.json { render json: @webuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /webusers/1
  # PUT /webusers/1.json
  def update
    @webuser = Webuser.find(params[:id])

    respond_to do |format|
      if @webuser.update_attributes(params[:webuser])
        format.html { redirect_to(webuser_url, :notice => "用户 #{@webuser.name} 的个人信息修改成功！") }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @webuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webusers/1
  # DELETE /webusers/1.json
  def destroy
    @webuser = Webuser.find(params[:id])
    @usercommoditys=UsercommodityT.find_all_by_userid(@webuser.name)
    @stg010001s=Stg010001.find_all_by_username(@webuser.name)
    @strategyparam = StrategyparamT.find_by_username(@webuser.name)

    for i in 0..@usercommoditys.size-1
      @usercommoditys[i].destroy
    end
    for i in 0..@stg010001s.size-1
      @stg010001s[i].destroy
    end
    if @strategyparam!=nil
   @strategyparam.destroy
   end
    @webuser.destroy
    respond_to do |format|
      format.html { redirect_to webusers_url }
      format.json { head :ok }
    end
  end

  def leveledit
    @webuser = Webuser.find(params[:id])
    @hash_level= Hash[0,"普通用户",1,"收费用户",99,"试用用户"]
    if params[:level]!=nil
      @webuser.update_attribute(:level,params[:level])
      @webuser.update_attribute(:leveldate,Time.now.to_s(:db))
      redirect_to(:controller=>"webusers", :action=>"index")
    end
  end
end
