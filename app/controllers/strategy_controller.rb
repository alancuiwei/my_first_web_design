require 'rubygems'
gem "xml-simple"
require 'xmlsimple'
require 'builder'

class StrategyController < ApplicationController
#  layout "rttabletemplate",:only=>:rtprice

  def index
    @strategywebs = Strategyweb.find(:all)

    respond_to do |format|
      format.html
      format.json { render json: @strategywebs }
    end

  end

  def rtprice
      render:layout=>'rttabletemplate'
  end

  def show
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

  end

  def customization
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
