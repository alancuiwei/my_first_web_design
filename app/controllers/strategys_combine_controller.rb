#encoding: utf-8
require 'rubygems'
require 'builder'
require 'rexml/document'
include REXML
class StrategysCombineController < ApplicationController
  # GET /usercommodity_ts
  # GET /usercommodity_ts.json
  def index
    @strategywebs = Strategyweb.all

  end

  def strategy_s1
    @strategyweb = Strategyweb.find(params[:id])
    @commodityrights=CommodityrightT.where("rightid like '"+@strategyweb.strategyid+"%'").all

    @rightids_arr= Array.new
    for i in 0..@commodityrights.size-1
      @rightids_arr[i]=@commodityrights[i].firstcommodityid+"-"+@commodityrights[i].secondcommodityid
    end

    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil&&params[:startdate]!=nil
    @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile'+@strategyweb.strategyid+'.xml'))
    @XMLfile.elements.to_a("//startdate")[0].text=params[:startdate]
    @XMLfile.elements.to_a("//period")[0].text=params[:period]
    @XMLfile.elements.to_a("//losses")[0].text=params[:losses]
    @XMLfile.elements.to_a("//wins")[0].text=params[:wins]
    @XMLfile.elements.to_a("//objecttype")[0].text="future"

    if params[:commoditynames]!=nil
    for i in 0..6
      if params[:commoditynames][i]!=nil
        @XMLfile.root.elements[3].add_element "item"
        @XMLfile.elements.to_a("//item")[i].text=params[:commoditynames][i]
      end
    end
    end

    @XMLfile.elements.to_a("//userid")[0].text=@webuser.id
    @XMLfile.elements.to_a("//strategyid")[0].text=@strategyweb.strategyid
    @test=@XMLfile
    file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml','w')
    file.puts @XMLfile
    file.close
    redirect_to(:controller=>"strategys_combine", :action=>"strategy_s2",:id=>params[:id])
    end

  end

  def strategy_s2
    @strategywebs = Strategyweb.all

  end

  def strategy_s3
    @strategyweb = Strategyweb.find(params[:id])
        @commodityrights=CommodityrightT.where("rightid like '"+@strategyweb.strategyid+"%'").all

        @rightids_arr= Array.new
        for i in 0..@commodityrights.size-1
          @rightids_arr[i]=@commodityrights[i].firstcommodityid+"-"+@commodityrights[i].secondcommodityid
        end

        @webuser = Webuser.find_by_name(session[:webuser_name])
        if @webuser!=nil&&params[:startdate]!=nil
        @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile'+@strategyweb.strategyid+'.xml'))
        @XMLfile.elements.to_a("//startdate")[0].text=params[:startdate]
        @XMLfile.elements.to_a("//period")[0].text=params[:period]
        @XMLfile.elements.to_a("//losses")[0].text=params[:losses]
        @XMLfile.elements.to_a("//wins")[0].text=params[:wins]
        @XMLfile.elements.to_a("//objecttype")[0].text="future"

        if params[:commoditynames]!=nil
        for i in 0..6
          if params[:commoditynames][i]!=nil
            @XMLfile.root.elements[3].add_element "item"
            @XMLfile.elements.to_a("//item")[i].text=params[:commoditynames][i]
          end
        end
        end

        @XMLfile.elements.to_a("//userid")[0].text=@webuser.id
        @XMLfile.elements.to_a("//strategyid")[0].text=@strategyweb.strategyid
        @test=@XMLfile
        file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'_2.xml','w')
        file.puts @XMLfile
        file.close
        redirect_to(:controller=>"strategys_combine", :action=>"finish")
        end
  end

  def finish

  end

end