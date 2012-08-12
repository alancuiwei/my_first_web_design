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

  def strategy_s0
    @strategywebs = Strategyweb.where("strategyid like '0407%' or strategyid like '0408%'").all

  end
  def strategy_s1
    @strategyweb = Strategyweb.find(params[:id])
    @commodityrights=CommodityrightT.where("rightid like '"+@strategyweb.strategyid+"%'").all

    @strategy_params=StrategyparamT.find_all_by_strategyid_and_ordernum_and_userid(@strategyweb.strategyid,0,0)

    @rightids_arr= Array.new
    @rightids_arr_d= Array.new
    for i in 0..@commodityrights.size-1
      @rightids_arr[i]=@commodityrights[i].firstcommodityid+"-"+@commodityrights[i].secondcommodityid
      @rightids_arr_d[i]=@commodityrights[i].firstcommodityid
    end

    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil&&params[:startdate]!=nil
    @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile'+@strategyweb.strategyid+'.xml'))
    @XMLfile.elements.to_a("//startdate")[0].text=params[:startdate]
    for i in 0..@strategy_params.size-1
      @XMLfile.elements.to_a("//#{@strategy_params[i].paramname}")[0].text=params[:"#{@strategy_params[i].paramname}"]
    end
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
    @strategywebs = Strategyweb.where("strategyid like '0407%'").all

  end

  def strategy_s3
    @strategyweb = Strategyweb.find(params[:id])
        @commodityrights=CommodityrightT.where("rightid like '"+@strategyweb.strategyid+"%'").all

    @strategy_params=StrategyparamT.find_all_by_strategyid_and_ordernum_and_userid(@strategyweb.strategyid,0,0)

        @rightids_arr= Array.new
    @rightids_arr_d= Array.new
        for i in 0..@commodityrights.size-1
          @rightids_arr[i]=@commodityrights[i].firstcommodityid+"-"+@commodityrights[i].secondcommodityid
      @rightids_arr_d[i]=@commodityrights[i].firstcommodityid
        end

        @webuser = Webuser.find_by_name(session[:webuser_name])
        if @webuser!=nil&&params[:startdate]!=nil
        @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile'+@strategyweb.strategyid+'.xml'))
        @XMLfile.elements.to_a("//startdate")[0].text=params[:startdate]
        for i in 0..@strategy_params.size-1
          @XMLfile.elements.to_a("//#{@strategy_params[i].paramname}")[0].text=params[:"#{@strategy_params[i].paramname}"]
        end
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

  def showall
    @strategyweb = Strategyweb.find(params[:id])
    @traderecord_all=StrategypositionrecordT.find(:all, :order =>"openposdate DESC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum])
  end

  def individual
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @strategywebs = Strategyweb.where("strategyid like '01%'or strategyid like '02%'or strategyid like '03%'").all
    @strategyweb = Strategyweb.find(params[:id])
    @commodityrights=CommodityrightT.where("rightid like '"+@strategyweb.strategyid+"%'").all
    @strategy_params=StrategyparamT.find_all_by_strategyid_and_ordernum_and_userid(@strategyweb.strategyid,0,0)
    @rightids_arr= Array.new
    @rightids_arr_d= Array.new
    for i in 0..@commodityrights.size-1
      @rightids_arr[i]=@commodityrights[i].firstcommodityid+"-"+@commodityrights[i].secondcommodityid
      @rightids_arr_d[i]=@commodityrights[i].firstcommodityid
    end

    if @webuser!=nil&&params[:startdate]!=nil
    @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile'+@strategyweb.strategyid+'.xml'))
    @XMLfile.elements.to_a("//startdate")[0].text=params[:startdate]
    for i in 0..@strategy_params.size-1
      @XMLfile.elements.to_a("//#{@strategy_params[i].paramname}")[0].text=params[:"#{@strategy_params[i].paramname}"]
    end
    #@XMLfile.elements.to_a("//period")[0].text=params[:period]
    #@XMLfile.elements.to_a("//losses")[0].text=params[:losses]
    #@XMLfile.elements.to_a("//wins")[0].text=params[:wins]
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
    redirect_to(:controller=>"strategys_combine", :action=>"wait",:id=>params[:id])
    end

  end

  def reportshow
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @reference_arr=Hash.new
    #@dailyinfo_arr=Array.new
    if @webuser!=nil
      @uid=@webuser.id.to_s
     @reference = Document.new(File.new('app/assets/xmls/reference-'+@webuser.id.to_s+'.xml'))
      @reference_arr.store(@reference.root.elements[1].text,[0,0])
        for i in 0..@reference.root.elements.size-2
        @reference_arr[@reference.root.elements[1].text][i]=@reference.root.elements[i+2].text
        end

     # @dailyinfo=Document.new(File.new('app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml'))
     #@dailyinfo_arr=@dailyinfo.root.elements[1].text
      @dailyinfo=Document.new(File.new('app/assets/xmls/posrecord-'+@webuser.id.to_s+'.xml'))
      file=File.new('app/assets/xmls/posrecord-'+@webuser.id.to_s+'.html','w')
      file.puts '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><table>'
      file.puts @dailyinfo
      file.puts "</table>"
      file.close
    end
  end

  def mysubmit
    @webuser = Webuser.find_by_name(session[:webuser_name])

    if @webuser!=nil&&params[:strategyname]!=nil
    @strategyparams = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml'))
    @stgp=StrategyparamT.find_by_username_and_strategyid(session[:webuser_name],@strategyparams.elements.to_a("//strategyid")[0].text)
    @ordernum=0
    @firstdb_flag=0
    if @stgp==nil
      @ordernum=1
      @firstdb_flag=1
      StrategyparamT.new do |stgp|
         stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
         stgp.paramname='period'
        stgp.paramvalue=@strategyparams.elements.to_a("//period")[0].text.to_f
        stgp.username=@webuser.name
         stgp.ordernum=1
         stgp.userid=@webuser.id
        stgp.save
      end
      StrategyparamT.new do |stgp|
         stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
         stgp.paramname='losses'
        stgp.paramvalue=@strategyparams.elements.to_a("//losses")[0].text.to_f
        stgp.username=@webuser.name
         stgp.ordernum=1
         stgp.userid=@webuser.id
         stgp.save
      end
      StrategyparamT.new do |stgp|
         stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
         stgp.paramname='wins'
        stgp.paramvalue=@strategyparams.elements.to_a("//wins")[0].text.to_f
        stgp.username=@webuser.name
         stgp.ordernum=1
         stgp.userid=@webuser.id
         stgp.save
      end
    else
      @stgp_p=StrategyparamT.find_all_by_username_and_paramname(session[:webuser_name],'period')
      @stgp_l=StrategyparamT.find_all_by_username_and_paramname(session[:webuser_name],'losses')
      @stgp_w=StrategyparamT.find_all_by_username_and_paramname(session[:webuser_name],'wins')
      @db_flag=0
      params[:username]=session[:webuser_name]
       @ordernum_t=StrategyparamT.find(:all,:conditions =>["username=:username",params], :order =>"ordernum DESC",:limit => 1)
      @ordernum=@ordernum_t[0].ordernum
      for i in 1..@stgp_p.size
         if @stgp_p[i-1].paramvalue==@strategyparams.elements.to_a("//period")[0].text.to_f&&@stgp_l[i-1].paramvalue==@strategyparams.elements.to_a("//losses")[0].text.to_f&&@stgp_w[i-1].paramvalue==@strategyparams.elements.to_a("//wins")[0].text.to_f
           @db_flag=1
           break
         end
      end
      if @db_flag==0
      @ordernum=@ordernum+1
      @firstdb_flag=1
        StrategyparamT.new do |stgp|
           stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
           stgp.paramname='period'
          stgp.paramvalue=@strategyparams.elements.to_a("//period")[0].text.to_f
          stgp.username=@webuser.name
           stgp.ordernum=@ordernum
           stgp.userid=@webuser.id
          stgp.save
        end
        StrategyparamT.new do |stgp|
           stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
           stgp.paramname='losses'
          stgp.paramvalue=@strategyparams.elements.to_a("//losses")[0].text.to_f
          stgp.username=@webuser.name
           stgp.ordernum=@ordernum
           stgp.userid=@webuser.id
           stgp.save
        end
        StrategyparamT.new do |stgp|
           stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
           stgp.paramname='wins'
          stgp.paramvalue=@strategyparams.elements.to_a("//wins")[0].text.to_f
          stgp.username=@webuser.name
           stgp.ordernum=@ordernum
           stgp.userid=@webuser.id
           stgp.save
        end

      end
    end

      if @firstdb_flag==1

        Strategyweb.new do |stgweb|
          stgweb.name=params[:strategyname]
          stgweb.description=params[:description]
          stgweb.price=params[:price]
          stgweb.trydays=params[:trydays]
          stgweb.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
          stgweb.strategytype=@strategyparams.elements.to_a("//objecttype")[0].text
          temp=@strategyparams.elements.to_a("//item")[0].text
          for i in 1..@strategyparams.elements.to_a("//item").size-1
            temp=temp+"|"+@strategyparams.elements.to_a("//item")[i].text
          end
          stgweb.commoditynames=temp
          stgweb.userid=@webuser.id
          stgweb.ordernum=@ordernum
          stgweb.created_at=Time.now.to_s(:db)
          stgweb.action='show'
          stgweb.control='strategys'
          stgweb.startdate=DateTime.strptime(@strategyparams.elements.to_a("//startdate")[0].text,"%Y-%m-%d").to_s(:db)
          stgweb.anreturn=1
          stgweb.configtype='database'
          stgweb.save
        end

        Thread.new {
            system "/ZRSoftware/Tools/startBuildTest.sh 'database' '"+@strategyparams.elements.to_a("//strategyid")[0].text+"' '"+@webuser.id.to_s+"' '"+@ordernum.to_s+"'"
            }
      end

     end

  end

  def wait
    @strategyweb = Strategyweb.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
    Thread.new {
    system "/ZRSoftware/Tools/startBuildTest.sh 'xml' '/ZRSoftware/tongtianshun/app/assets/xmls/g_XMLfile-"+@webuser.id.to_s+".xml'"
    }

  end
end