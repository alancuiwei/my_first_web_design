#encoding: utf-8
class WebusersController < ApplicationController
  # GET /webusers
  # GET /webusers.json
  def index
    @webusers = Webuser.order(:name)
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webuser }
    end
  end

  # GET /webusers/new
  # GET /webusers/new.json
  def new
    @webuser = Webuser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @webuser }
    end
  end

  # GET /webusers/1/edit
  def edit
    @webuser = Webuser.find(params[:id])
  end

  # POST /webusers
  # POST /webusers.json
  def create
    @webuser = Webuser.new(params[:webuser])

    respond_to do |format|
      if @webuser.save
	    session[:webuser_name] = @webuser.name

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
    @webuser.destroy

    respond_to do |format|
      format.html { redirect_to webusers_url }
      format.json { head :ok }
    end
  end
end
