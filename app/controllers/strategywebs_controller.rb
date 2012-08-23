#encoding: utf-8
class StrategywebsController < ApplicationController

  def index
    @strat_profit=200000

    #@strategyreferences=StrategyreferenceT.where("rightid like '%000000' and strategyid is not null and ((avedaytrades > 0 and avedaytrades<0.05) or (avedaytrades>=0.2 and avedaytrades<1))").all.size

    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil
      #sub
      @sub_hash=Hash.new
      @subscribe=Subscribetable.find(:all,:conditions =>["subscribe_userid=? ",@webuser.id],:order =>"subscribedate ASC")
      for i in 0..@subscribe.size-1
        days=@subscribe[i].subscribedays-(DateTime.strptime(Time.now.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@subscribe[i].subscribedate.to_s(:db),"%Y-%m-%d").to_i)/86400
       @sub_hash.store(@subscribe[i].strategyid+@subscribe[i].ordernum.to_s+@subscribe[i].strategy_userid.to_s,days)
      end

    if @webuser.collect==nil
    @webuser.update_attribute(:collect,"")
    end
      if @webuser.name=='administrator'
        @show_flag=1
      end
      if @webuser.collect!=nil
     @collect=@webuser.collect.split("|")
     @hash_iscollect=Hash.new
      for i in 0..@collect.size-1
         @hash_iscollect.store(@collect[i].to_i,1)
      end
      end

    end

    @strategywebs = Strategyweb.all

    @allmaxreturnrate=ArbcostmaxreturnrateT.find(:all, :order =>"returnrate DESC",:limit => 1)

    @hash_reference=Hash.new
    @reference=Array.new
    i=0
    @strategywebs.each do |strategyweb|
      if strategyweb.strategyid.size>6
        @reference[i]= StrategyreferenceT.find_by_strategyid_and_userid_and_ordernum_and_rightid(strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,strategyweb.strategyid.slice(0,6)+"000000-"+strategyweb.strategyid.slice(7,6)+"000000")
      else
      @reference[i]= StrategyreferenceT.find_by_strategyid_and_userid_and_ordernum_and_rightid(strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,strategyweb.strategyid+"000000")
      end
      if @reference[i]!=nil
       @hash_reference.store(strategyweb.strategyid.to_s+strategyweb.userid.to_s+strategyweb.ordernum.to_s,[@reference[i].maxdrawdown,@reference[i].percentprofitable,@reference[i].aveyearreturn])
      else
        @hash_reference.store(strategyweb.strategyid.to_s+strategyweb.userid.to_s+strategyweb.ordernum.to_s,[nil,nil,nil])
      end
      i=i+1
    end
    @hash_reference.store("01000100",["无","无",@allmaxreturnrate[0].returnrate])
    Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'

    @profitchart_arr=Array.new
    @profitchart_arr_day=Array.new
    @profitchart_hash=Hash.new

    @strategywebs.each do |strategyweb|
      profit=Profitchart.find(:all,:conditions =>["strategyid=? and userid=? and ordernum=?",strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum], :order =>"dateint DESC",:limit => 730)
    if  profit.size==730
      @profitchart_arr=[]
      @profitchart_arr_day=[]
    for i in 0..23
    @profitchart_arr[23-i]=profit[i*30].profit+@strat_profit
    @profitchart_arr_day[23-i]=Time.at(profit[i*30].dateint/1000).to_s(:stamp)
    #DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000
    end
    @profitchart_hash.store(strategyweb.id,[@profitchart_arr,@profitchart_arr_day])
      end
    end

    @stg_hash=Hash.new

    @webuser_sub=Webuser.all
    @webuser_sub_id=Array.new
    @sub_id=Hash.new
    for i in 0..@webuser_sub.size-1
      @webuser_sub_id[i]=@webuser_sub[i].subid
    end
    @webuser_sub_id=@webuser_sub_id.compact
    for i in 0..@webuser_sub_id.size-1
      @webuser_sub_id[i]=@webuser_sub_id[i].split("|")
      for j in 0..@webuser_sub_id[i].size-1
        @sub_id.store(@webuser_sub_id[i][j],1)
      end
    end


    @strategywebs.each do |strategyweb|
      if strategyweb.strategyid.size>6
        temp=strategyweb.strategyid.split("-")
        rightid=temp[0]+"000000-"+temp[1]+"000000"
      else
        rightid=strategyweb.strategyid+"000000"
      end
      reference=StrategyreferenceT.find_by_rightid_and_strategyid_and_userid_and_ordernum(rightid,strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum)
      if reference!=nil
        avedaytrades=reference.avedaytrades
      else
        avedaytrades=nil
      end
      if @sub_id[strategyweb.id.to_s]==nil
        subid=nil
      else
        subid=@sub_id[strategyweb.id.to_s]
      end
      if strategyweb.strategytype=="期货"
        strategytype="future"
      else
        strategytype=strategyweb.strategytype
      end
      @stg_hash.store(strategyweb.id,[strategytype,avedaytrades,strategyweb.price,subid])
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

    @strategyparams = StrategyparamT.find_all_by_strategyid_and_userid_and_ordernum(@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum)
    @strategypositionrecords = StrategypositionrecordT.find_all_by_strategyid_and_userid_and_ordernum(@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum)
    @strategyreferences = StrategyreferenceT.find_all_by_strategyid_and_userid_and_ordernum(@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum)
    @strategyreturnrates = StrategyreturnrateT.find_all_by_strategyid_and_userid_and_ordernum(@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum)

    if @strategyparams!=nil
      for i in 0..@strategyparams.size-1
        @strategyparams[i].destroy
      end
    end
    if @strategypositionrecords!=nil
      for i in 0..@strategypositionrecords.size-1
        @strategypositionrecords[i].destroy
      end
    end
    if @strategyreferences!=nil
      for i in 0..@strategyreferences.size-1
        @strategyreferences[i].destroy
      end
    end
    if @strategyreturnrates!=nil
      for i in 0..@strategyreturnrates.size-1
        @strategyreturnrates[i].destroy
      end
    end
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
