#encoding: utf-8
class StrategywebsController < ApplicationController

  def index
    @strat_profit=200000
    if params[:avedaytrades]==""
      params[:avedaytrades]=nil
    end
    if params[:strategytype]==""
      params[:strategytype]=nil
    end
    if params[:free]==""
      params[:free]=nil
    end
    if params[:havesub]==""
      params[:havesub]=nil
    end
    @hash_filter=Hash["0","avedaytrades>0 and avedaytrades<0.05","1","avedaytrades>=0.05 and avedaytrades<0.2",
    "2","avedaytrades>=0.2 and avedaytrades<1","3","avedaytrades>=1"]

    if params[:strategytype]!=nil&&params[:avedaytrades]!=nil
      @avedaytrades_arr=Array.new
      @avedaytrades=params[:avedaytrades].scan(/\d/)
      for i in 0..@avedaytrades.size-1
        @avedaytrades_arr[i]=@hash_filter[@avedaytrades[i]]
        if i==0
        @avedaytrades_sql="(("+@avedaytrades_arr[i]+")"
        else
          @avedaytrades_sql=@avedaytrades_sql+" or ("+@avedaytrades_arr[i]+")"
        end
        if i==@avedaytrades.size-1
          @avedaytrades_sql=@avedaytrades_sql+")"
        end

      end
      @strategyreferences=StrategyreferenceT.where("rightid like '%000000' and strategyid is not null and #{@avedaytrades_sql}").all
      @strategywebs=Array.new
      for i in 0..@strategyreferences.size-1
        @strategywebs[i] = Strategyweb.find_by_strategytype_and_strategyid_and_ordernum_and_userid(params[:strategytype],@strategyreferences[i].strategyid,@strategyreferences[i].ordernum,@strategyreferences[i].userid)
      end
      #@strategywebs = Strategyweb.find_all_by_id(2)

      elsif params[:strategytype]!=nil&&params[:avedaytrades]==nil
        @strategywebs= Strategyweb.find_all_by_strategytype(params[:strategytype])
      elsif params[:strategytype]==nil&&params[:avedaytrades]!=nil
        @avedaytrades_arr=Array.new
        @avedaytrades=params[:avedaytrades].scan(/\d/)
        for i in 0..@avedaytrades.size-1
          @avedaytrades_arr[i]=@hash_filter[@avedaytrades[i]]
          if i==0
          @avedaytrades_sql="(("+@avedaytrades_arr[i]+")"
          else
            @avedaytrades_sql=@avedaytrades_sql+" or ("+@avedaytrades_arr[i]+")"
          end
          if i==@avedaytrades.size-1
            @avedaytrades_sql=@avedaytrades_sql+")"
          end

        end
        @strategyreferences=StrategyreferenceT.where("rightid like '%000000' and strategyid is not null and #{@avedaytrades_sql}").all
        @strategywebs=Array.new
        for i in 0..@strategyreferences.size-1
          @strategywebs[i] = Strategyweb.find_by_strategyid_and_ordernum_and_userid(@strategyreferences[i].strategyid,@strategyreferences[i].ordernum,@strategyreferences[i].userid)
        end
    else
    @strategywebs = Strategyweb.all
    end
    @strategywebs=@strategywebs.compact
    if params[:free]!=nil
      for i in 0..@strategywebs.size-1
        if @strategywebs[i].price!=0
          @strategywebs[i]=nil
        end
      end
    end
    @strategywebs=@strategywebs.compact

    if params[:havesub]!=nil
      @webuser_sub=Webuser.all
      @webuser_sub_id=Array.new
      @sub_id=Hash.new
      for i in 0..@webuser_sub.size-1
        @webuser_sub_id[i]=@webuser_sub[i].subid
      end
      @webuser_sub_id=@webuser_sub_id.compact
      for i in 0..@webuser_sub_id.size-1
        @webuser_sub_id[i]=@webuser_sub_id[i].scan(/\d/)
        for j in 0..@webuser_sub_id[i].size-1
          @sub_id.store(@webuser_sub_id[i][j],0)
        end
      end
      @sub_id=@sub_id.keys
      for i in 0..@strategywebs.size-1
        flag=0
        for j in 0..@sub_id.size-1
        if @strategywebs[i].id.to_s!=@sub_id[j]
          flag=flag+1
        end
          if flag==@sub_id.size
            @strategywebs[i]=nil
          end
        end
      end

    end

    @strategywebs=@strategywebs.compact
    #@strategyreferences=StrategyreferenceT.where("rightid like '%000000' and strategyid is not null and ((avedaytrades > 0 and avedaytrades<0.05) or (avedaytrades>=0.2 and avedaytrades<1))").all.size

    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil
    if @webuser.collect==nil
    @webuser.update_attribute(:collect,"")
    end
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
    #updata returnrate
    @strategyweb_norisk = Strategyweb.find_by_name("无风险套利")
    @strategyweb_norisk.update_attributes(:anreturn=>@allmaxreturnrate[0].returnrate)

    @hash_reference=Hash.new
    @hash_reference.store("01000100",[0,0])
    @reference=Array.new
    i=0
    @strategywebs.each do |strategyweb|
      if strategyweb.strategyid.size>6
        @reference[i]= StrategyreferenceT.find_by_strategyid_and_userid_and_ordernum_and_rightid(strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,strategyweb.strategyid.slice(0,6)+"000000-"+strategyweb.strategyid.slice(7,6)+"000000")
      else
      @reference[i]= StrategyreferenceT.find_by_strategyid_and_userid_and_ordernum_and_rightid(strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,strategyweb.strategyid+"000000")
      end
      if @reference[i]!=nil
       @hash_reference.store(strategyweb.strategyid.to_s+strategyweb.userid.to_s+strategyweb.ordernum.to_s,[@reference[i].maxdrawdown,@reference[i].percentprofitable])
      else
        @hash_reference.store(strategyweb.strategyid.to_s+strategyweb.userid.to_s+strategyweb.ordernum.to_s,[nil,nil])
      end
      i=i+1
    end
    Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
    @profitchart_arr=Array.new
    @profitchart_arr_day=Array.new
    @profitchart_hash=Hash.new
    @strategywebs.each do |strategyweb|
    if  Profitchart.find(:all,:conditions =>["strategyid=? and userid=? and ordernum=?",strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum], :order =>"dateint DESC",:limit => 730).size==730
      @profitchart_arr=[]
      @profitchart_arr_day=[]
    for i in 0..23
    @profitchart_arr[23-i]=Profitchart.find(:all,:conditions =>["strategyid=? and userid=? and ordernum=?",strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum], :order =>"dateint DESC",:limit => 730)[i*30].profit+@strat_profit
    @profitchart_arr_day[23-i]=Time.at(Profitchart.find(:all,:conditions =>["strategyid=? and userid=? and ordernum=?",strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum], :order =>"dateint DESC",:limit => 730)[i*30].dateint/1000).to_s(:stamp)
    #DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000
    end
    @profitchart_hash.store(strategyweb.id,[@profitchart_arr,@profitchart_arr_day])
      end
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
