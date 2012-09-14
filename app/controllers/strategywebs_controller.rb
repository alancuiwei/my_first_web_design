#encoding: utf-8
class StrategywebsController < ApplicationController

  def index
    @pagetitle="策略集合"
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

    if params[:shownum]==nil
    @strategywebs = Strategyweb.find(:all, :limit => 5,:order =>"updated_at DESC")
    else
      @strategywebs = Strategyweb.find(:all, :limit =>params[:shownum].to_i,:order =>"updated_at DESC")
    end

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
      profit=Profitchart.find(:all,:conditions =>["strategyid=? and userid=? and ordernum=? and id%20=?",strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,0], :order =>"dateint ASC")

    if  profit!=nil
      @profitchart_arr=[]
      @profitchart_arr_day=[]
    for i in 0..profit.size-1
    @profitchart_arr[i]=profit[i].profit+@strat_profit
    @profitchart_arr_day[i]=Time.at(profit[i].dateint/1000).to_s(:stamp)
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
  
  def stgwebdata
    @commoditys=CommodityT.all
    @hash_commoditys={}
    @hash_commodityid=Hash["ag","白银","CF","棉花","ER","早籼稻(改名前)","RI","早籼稻(改名后)","ME","甲醇","RO","菜籽油(改名前)","OI","菜籽油(改名后)","SR","白糖","TA","精对苯二甲酸","WS","强麦(改名前)","WH","强麦(改名后)",
         "WT","硬麦","PM","普麦","IF","股指","a","黄大豆","al","铝","au","黄金","b","黄豆二","c","玉米",
         "cu","铜","fu","燃料油","j","焦炭","l","聚乙烯","m","豆粕","p","棕榈油","pb","铅","rb","螺纹钢",
         "ru","橡胶","v","聚氯乙烯","wr","线材","y","豆油","zn","锌"]
    @hash_city=Hash["DL","大连","ZZ","郑州","SH","上海","ZJS","中金所"]
    for i in 0..@commoditys.size-1
      if FileTest::exist?'app/assets/historydatadownload/'+@commoditys[i].commodityid+'.zip'
        date=File::mtime('app/assets/historydatadownload/'+@commoditys[i].commodityid+'.zip').to_s(:db)
      else
        date=nil
      end
      @hash_commoditys.store(@commoditys[i].commodityid,[@hash_city[@commoditys[i].exchangeid],date])
    end

  end

  def stgwebtable
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @strategywebs = Strategyweb.find(:all,:order =>"updated_at DESC")
    @allmaxreturnrate=ArbcostmaxreturnrateT.find(:all, :order =>"returnrate DESC",:limit => 1)

    @hash_reference=Hash.new
    @reference=Array.new
    @reference_title=["minmarginaccount","totalnetprofit","grossprofit","grossloss",
                "avemonthreturn","aveyearreturn","toaltradingdays","totaltrades",
                "avedaytrades","numwintrades","numlosstrades","percentprofitable",
                "largestwintrade","largestlosstrade","avewintrade","avelosstrade",
                "avetrade","expectvalue", "maxdrawdown","maxdrawdowndays"]
    i=0
    @strategywebs.each do |strategyweb|
      if strategyweb.strategyid.size>6
        @reference[i]= StrategyreferenceT.find_by_strategyid_and_userid_and_ordernum_and_rightid(strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,strategyweb.strategyid.slice(0,6)+"000000-"+strategyweb.strategyid.slice(7,6)+"000000")
      else
      @reference[i]= StrategyreferenceT.find_by_strategyid_and_userid_and_ordernum_and_rightid(strategyweb.strategyid,strategyweb.userid,strategyweb.ordernum,strategyweb.strategyid+"000000")
      end
      if @reference[i]!=nil
       @hash_reference.store(strategyweb.strategyid.to_s+strategyweb.userid.to_s+strategyweb.ordernum.to_s,
           [@reference[i].minmarginaccount,@reference[i].totalnetprofit,@reference[i].grossprofit,@reference[i].grossloss,
            @reference[i].avemonthreturn,@reference[i].aveyearreturn,@reference[i].toaltradingdays,@reference[i].totaltrades,
            @reference[i].avedaytrades,@reference[i].numwintrades,@reference[i].numlosstrades,@reference[i].percentprofitable,
            @reference[i].largestwintrade,@reference[i].largestlosstrade,@reference[i].avewintrade,@reference[i].avelosstrade,
            @reference[i].avetrade,@reference[i].expectvalue, @reference[i].maxdrawdown,@reference[i].maxdrawdowndays])
      else
        @hash_reference.store(strategyweb.strategyid.to_s+strategyweb.userid.to_s+strategyweb.ordernum.to_s,[nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil])
      end
      i=i+1
    end
    @hash_reference.store("01000100",["无","无",@allmaxreturnrate[0].returnrate,"无","无","无","无","无","无","无","无","无","无","无","无","无","无","无","无","无"])
  end

  def download
    send_file "app/assets/historydatadownload/"+params[:filename] unless params[:filename].blank?
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
      render :json=>"success".to_json
    end

  end

  def  cancelcollect
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil
      @collect=@webuser.collect.split("|")
      if @collect.size==1
        @webuser.update_attribute(:collect,"")
      else
        @collect=@collect-[params[:id]]
          temp=@collect[0]
          for i in 1..@collect.size-1
          temp=temp+"|"+@collect[i]
          end
          @webuser.update_attribute(:collect,temp)
      end
      render :json=>"success".to_json
    end
  end


end
