#encoding: utf-8
class StrategywebsController < ApplicationController

  def index
    @strategywebs = Strategyweb.all
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil
      if @webuser.name=='administrator'
        @show_flag=1
      end
      if @webuser.collect!=nil
     @collect=@webuser.collect.scan(/\d/)
     @hash_iscollect=Hash.new
      for i in 0..@collect.size-1
         @hash_iscollect.store(@collect[i].to_i,1)
      end
      end

    end
    @allmaxreturnrate=ArbcostmaxreturnrateT.find(:all, :order =>"returnrate DESC",:limit => 1)
    @strategyweb = Strategyweb.find_by_name("无风险套利")
   @strategyweb.update_attributes(:anreturn=>@allmaxreturnrate[0].returnrate)
    @reference=StrategyreferenceT.find_by_rightid("010603000000",0)
    @hash_reference=Hash.new
    @hash_reference.store("010603",[@reference.maxdrawdown,@reference.percentprofitable])
    @hash_reference.store("010001",[0,0])
    @hash_reference.store("040704",[0,0])
    @profitchart_arr=Array.new
    for i in 0..23
    @profitchart_arr[23-i]=Profitchart.find(:all, :order =>"dateint DESC",:limit => 730)[i*30].profit+200000
    end

    respond_to do |format|
      format.html
      format.json { render json: @strategywebs }
    end
  end
  
  # GET /strategywebs/1
  # GET /strategywebs/1.json
  def show
    @strategyweb = Strategyweb.find(params[:id])

    respond_to do |format|
      format.html
#      format.json { render json: @strategyweb }
    end
  end


  # GET /strategywebs/new
  # GET /strategywebs/new.json
  def new
    @strategyweb = Strategyweb.new

    respond_to do |format|
      format.html
      format.json { render json: @strategyweb }
    end
  end

  # GET /strategywebs/1/edit
  def edit
    @strategyweb = Strategyweb.find(params[:id])
#	render:layout => 'admin'
  end

  # POST /strategywebs
  # POST /strategywebs.json
  def create
    
	@strategyweb = Strategyweb.new(params[:strategyweb])
  @strategyweb.control="strategys"
  @strategyweb.action="show"
  @strategyweb.anreturn=1
    respond_to do |format|
      if @strategyweb.save
        format.html { redirect_to :action=>"index", notice: 'Strategyweb was successfully created.' }
        format.json { render json: @strategyweb, status: :created, location: @strategyweb }
      else
        format.html { render action: "new" }
        format.json { render json: @strategyweb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /strategywebs/1
  # PUT /strategywebs/1.json
  def update
    @strategyweb = Strategyweb.find(params[:id])

    respond_to do |format|
      if @strategyweb.update_attributes(params[:strategyweb])
        format.html { redirect_to :action=>"index", notice: 'Strategyweb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @strategyweb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategywebs/1
  # DELETE /strategywebs/1.json
  def destroy
    @strategyweb = Strategyweb.find(params[:id])
    @strategyweb.destroy

    respond_to do |format|
      format.html { redirect_to strategywebs_url }
      format.json { head :no_content }
    end
  end

  def collect
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil
      @precollect=@webuser.collect
      if @webuser.collect.index(params[:id].to_s)==nil
      if @precollect==nil||@precollect==''
        @webuser.update_attribute(:collect,params[:id].to_s)
      else
        @webuser.update_attribute(:collect,@precollect+"|"+params[:id].to_s)
      end
      end
    end
    redirect_to :action=>"index"
  end

  def  cancelcollect
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil
      @position= @webuser.collect.index(params[:id].to_s)
      if @position==0&&@webuser.collect.size==1
        @webuser.update_attribute(:collect,"")
      elsif @position==0
        @webuser.update_attribute(:collect, @webuser.collect[2..@position.size])
      else
        @webuser.update_attribute(:collect, @webuser.collect[0..@position-2]+@webuser.collect[@position+1..@position.size])
      end

    end
    redirect_to :action=>"index"
  end


end
