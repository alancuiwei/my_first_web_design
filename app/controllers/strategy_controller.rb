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

  def show
#    @strategyweb = Strategyweb.find(params[:id])
#    commonpairid = "000000"
#    strategy_id = @strategyweb.strategyid + commonpairid
#    strategy_id = "010001000000"

    if(params[:id]=="1") then

    end

#    if(params[:id]=="2") then
#		testrate = StrategyreturnrateT.all
#		firstyear = testrate[0].yearid
#		lastyear = testrate[-1].yearid
#		@existyears = Array(firstyear..lastyear)
#		@strate = Array.new
#		firstyear.upto(lastyear) do |year|
#			@strate[year] = StrategyreturnrateT.find_all_by_rightid_and_yearid(strategy_id,year)
#		end
#		@streference = StrategyreferenceT.find_all_by_rightid(strategy_id)
#
#		@traderecord = StrategypositionrecordT.find(:all,:conditions =>"closeposdate>'2011-12-15'")
#  #xml
#    mytime=Time.now
#    hour=mytime.strftime("%H")
#    min=mytime.strftime("%M")
#    sec=mytime.strftime("%S")
#    if hour=="23" && min=="59"&& min=="59"
#    @dwtest = XmlSimple::xml_in('public/strategyresults/010603/test.xml')
#    str1="<graph caption='Month' xAxisName='Days' yAxisName='Units' showvalues='0' showNames='1' decimalPrecision='0' formatNumberScale='0'> "
#    str11="<graph caption='Year' xAxisName='Months' yAxisName='Units' showNames='1' decimalPrecision='0' formatNumberScale='0'> "
#    p=0
#    for k  in 2002..2011 do
#    for i  in 1..12 do
#      istr=i.to_s
#      kstr=k.to_s
#      str2="public/strategyresults/010603/" +kstr+"/"+istr +".xml"
#      file = File.new(str2,'w')
#      file.puts str1
#      strxml1 = ''
#      doc = Builder::XmlMarkup.new(:target=>strxml1,:indent=>2)
#    for j  in 1..31 do
#      if @dwtest['set'][p]["year"].to_f==k && @dwtest['set'][p]["month"].to_f==i
#      doc.set(:name=>j,:value=>@dwtest['set'][p]["value"])
#      p+=1
#      end
#    end
#      file.puts strxml1
#      file.puts "</graph>"
#      file.close
#      end
#   end
#    #生成年
#    @dwtest1 = XmlSimple::xml_in('public/strategyresults/010603/test.xml')
#     q=0
#      for a  in 2002..2011 do
#      astr=a.to_s
#      str22="public/strategyresults/010603/YearsData/"+astr +".xml"
#      file = File.new(str22,'w')
#      file.puts str11
#      strxml2=''
#      doc1 = Builder::XmlMarkup.new(:target=>strxml2,:indent=>2)
#      #s=0 #月份记录
#    for b  in 1..12 do
#    for c  in 1..31 do
#      if @dwtest1['set'][q]["year"].to_f==a && @dwtest1['set'][q]["month"].to_f==b
#        q+=1
#         #file.puts s
#      end
#    end
#    #s+=1
#     q-=1
#      doc1.set(:name=>b,:value=>@dwtest1['set'][q]["value"])
#      q+=1
#    end
#      file.puts strxml2
#      file.puts "</graph>"
#      file.close
#    end
#   end #time end
#
#  #xml
#	end


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
