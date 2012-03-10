require 'rubygems'
gem "xml-simple"
require 'xmlsimple'
require 'builder'

class StrategywebsController < ApplicationController
    layout "rttabletemplate",:only=>:rtprice
  # GET /strategywebs
  # GET /strategywebs.json
  def rtprice
  end

  def strategyindex
      @strategywebs = Strategyweb.find(:all)

      respond_to do |format|
        format.html { render:layout => 'strategylib'}
        format.json { render json: @strategywebs }
      end

  end

  def strategyperformance
      @strategywebs = Strategyweb.find(:all)

      respond_to do |format|
        format.html { render:layout => 'strategylib'}
        format.json { render json: @strategywebs }
      end

  end


  def index
    @strategywebs = Strategyweb.all

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

  def strategyshow
    @strategyweb = Strategyweb.find(params[:id])
    commonpairid = "000000"
    strategy_id = @strategyweb.strategyid + commonpairid

    if(params[:id]=="2") then
		testrate = StrategyreturnrateT.all
		firstyear = testrate[0].yearid
		lastyear = testrate[-1].yearid
		@existyears = Array(firstyear..lastyear)
		@strate = Array.new
		firstyear.upto(lastyear) do |year|
			@strate[year] = StrategyreturnrateT.find_all_by_rightid_and_yearid(strategy_id,year)
		end
		@streference = StrategyreferenceT.find_all_by_rightid(strategy_id)
		
		@traderecord = StrategypositionrecordT.find(:all,:conditions =>"closeposdate>'2011-12-15'")
		
	end

    if(params[:id]=="1") then

    end

    render:layout => 'strategylib'

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

    respond_to do |format|
      if @strategyweb.save
        format.html { redirect_to @strategyweb, notice: 'Strategyweb was successfully created.' }
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
        format.html { redirect_to @strategyweb, notice: 'Strategyweb was successfully updated.' }
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
  def strconfig
    cperiod = params[:period]
    closses = params[:losses]
    cwins   = params[:wins]
    strxml = ''
    doc = Builder::XmlMarkup.new(:target=>strxml,:indent=>2)
    doc.instruct!
    doc.g_XMLfile {|g_XMLfile|
      g_XMLfile.coredata {|coredata|
        coredata.startdate('2010-01-01')
        coredata.enddate('2010-12-31')
        }
      g_XMLfile.g_strategyparams {|g_strategyparams|
        g_strategyparams.period(cperiod)
        g_strategyparams.losses(closses)
        g_strategyparams.wins(cwins)
        }
      g_XMLfile.g_commoditynames('')
      g_XMLfile.g_pairnames('')
      g_XMLfile.strategyid('010603')
      g_XMLfile.path('F:\RailsInstaller\Draft\ver0.1\public')
      }
    # file = File.new('public/configfile.xml','w')
    # file.puts strxml
    # file.close
    # FileUtils.cd "Strategy/010603" do
    # system "dir"
    # system "test1.exe","F:\\RailsInstaller\\Draft\\ver0.1\\public\\configfile.xml"
    # end

    # filelines = File.open('public/returnrate.xml','r')
    # lines = filelines.readlines
    # lines[1] = "<TABLE>"
    # lines[-1] = "</TABLE>"
    # returnfile = File.new('public/returnrate.html','w')
    # returnfile.puts lines
    # returnfile.close


    @cfg = XmlSimple::xml_in('public/reference.xml')
  #	puts cfg['rightid'][0]
  #	@return = XmlSimple::xml_in('public/returnrate.xml','key_attr'=>'returnrate')
  #	returns = XmlSimple::xml_in('public/returnrate.xml')
  #	custstrate = returns['item']
  #	custfirstyear = custstrate[0]["yearid"][0]
  #	custlastyear = custstrate[-1]["yearid"][0]
  #	custexistyears = Array(custfirstyear,custlastyear)
  #	p custfirstyear
  #	p custlastyear
  #	p custexistyears
  #	p custstrate[0]["rightid"][0]
  #	rtvalue = XmlSimple::xml_in('public/CSpreadCostStrRunOnTime.xml')
  #	system "dir"
  #	puts rtvalue['pair']

  #	puts rtvalue['pair'][0]["time"][0]
  #	puts rtvalue['pair'][1]["name"][0]
  end
end
