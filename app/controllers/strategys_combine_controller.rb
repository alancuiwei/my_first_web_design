﻿#encoding: utf-8
require 'rubygems'
require 'builder'
require 'rexml/document'
include REXML
class StrategysCombineController < ApplicationController
  def strategy_s1
    @url_1="/strategys_combine/strategy_s1"
    @url_2="javascript:void(0)"
    @url_3="javascript:void(0)"
    @url_4="javascript:void(0)"
    @url_5="javascript:void(0)"

    @strategywebs = Strategyweb.where("(strategyid like '0407%' or strategyid like '0408%') and userid=0 and ordernum=0").all

    if params[:id]!=nil
      @strategyweb = Strategyweb.find(params[:id])
      @strategy_params=StrategyparamT.find_all_by_strategyid_and_ordernum_and_userid(@strategyweb.strategyid,0,0)
      @hash_params=Hash.new
      if @strategy_params!=nil
        for i in 0..@strategy_params.size-1
          @hash_params.store(@strategy_params[i].paramname ,@strategy_params[i].strategy_para_range)
        end
      end

      @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile'+@strategyweb.strategyid+'.xml'))

      @webuser = Webuser.find_by_name(session[:webuser_name])
      if @webuser!=nil&&params[:"#{@strategy_params[0].paramname}"]!=nil

        #@XMLfile.elements.to_a("//startdate")[0].text=params[:startdate]

        for i in 0..@strategy_params.size-1
          @XMLfile.elements.to_a("//#{@strategy_params[i].paramname}")[0].text=params[:"#{@strategy_params[i].paramname}"]
        end
        @XMLfile.elements.to_a("//objecttype")[0].text="future"
        @XMLfile.elements.to_a("//userid")[0].text=@webuser.id
        @XMLfile.elements.to_a("//strategyid")[0].text=@strategyweb.strategyid
        if @webuser.level!=0
          @XMLfile.elements.to_a("//savepos")[0].text=1
        end
        file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml','w')
        file.puts @XMLfile
        file.close
        redirect_to(:controller=>"strategys_combine", :action=>"strategy_s2")
      end
    end

    if @strategyweb!=nil
      @strategy_name=@strategyweb.name
    else
      @strategy_name=nil
    end

  end

  def strategy_s2
    @url_1="/strategys_combine/strategy_s1"
    @url_2="/strategys_combine/strategy_s2"
    @url_3="javascript:void(0)"
    @url_4="javascript:void(0)"
    @url_5="javascript:void(0)"

    @strategywebs = Strategyweb.where("strategyid like '0407%' and userid=0 and ordernum=0").all

    if params[:id]!=nil
      @strategyweb = Strategyweb.find(params[:id])
      @strategy_params=StrategyparamT.find_all_by_strategyid_and_ordernum_and_userid(@strategyweb.strategyid,0,0)
      @hash_params=Hash.new
      if @strategy_params!=nil
        for i in 0..@strategy_params.size-1
          @hash_params.store(@strategy_params[i].paramname ,@strategy_params[i].strategy_para_range)
        end
      end
      @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile'+@strategyweb.strategyid+'.xml'))

      @webuser = Webuser.find_by_name(session[:webuser_name])
      if @webuser!=nil&&params[:"#{@strategy_params[0].paramname}"]!=nil
        #@XMLfile.elements.to_a("//startdate")[0].text=params[:startdate]
        for i in 0..@strategy_params.size-1
          @XMLfile.elements.to_a("//#{@strategy_params[i].paramname}")[0].text=params[:"#{@strategy_params[i].paramname}"]
        end
        @XMLfile.elements.to_a("//objecttype")[0].text="future"
        @XMLfile.elements.to_a("//userid")[0].text=@webuser.id
        @XMLfile.elements.to_a("//strategyid")[0].text=@strategyweb.strategyid
        if @webuser.level!=0
          @XMLfile.elements.to_a("//savepos")[0].text=1
        end
        file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'_2.xml','w')
        file.puts @XMLfile
        file.close
        redirect_to(:controller=>"strategys_combine", :action=>"strategy_s3",:id=>params[:id])
      end
    end

    if @strategyweb!=nil
      @strategy_name=@strategyweb.name
    else
      @strategy_name=nil
    end

  end

  def strategy_s3
    @url_1="/strategys_combine/strategy_s1"
    @url_2="/strategys_combine/strategy_s2"
    @url_3="javascript:void(0)"
    @url_4="javascript:void(0)"
    @url_5="javascript:void(0)"

    if params[:id]!=nil
      @strategyweb = Strategyweb.find(params[:id])
      @commodityrights=CommodityrightT.where("rightid like '"+@strategyweb.strategyid+"%'").all
      @rightids_arr= Array.new
      @rightids_arr_d= Array.new
      for i in 0..@commodityrights.size-1
        @rightids_arr[i]=@commodityrights[i].firstcommodityid+"-"+@commodityrights[i].secondcommodityid
        @rightids_arr_d[i]=@commodityrights[i].firstcommodityid
      end

      @webuser = Webuser.find_by_name(session[:webuser_name])
      if @webuser!=nil&&params[:startdate]!=nil
        @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml'))

        if params[:commoditynames]!=nil
          for i in 0..@commodityrights.size
            if params[:commoditynames][i]!=nil
              @XMLfile.root.elements[3].add_element "item"
              @XMLfile.elements.to_a("//item")[i].text=params[:commoditynames][i]
            end
          end
        end

        @XMLfile.elements.to_a("//startdate")[0].text=params[:startdate]
        @XMLfile.elements.to_a("//enddate")[0].text=params[:enddate]
        file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml','w')
        file.puts @XMLfile
        file.close
        redirect_to(:controller=>"strategys_combine", :action=>"wait_d")
      end

    end


  end

  def showall
    @strategyweb = Strategyweb.find(params[:id])
    @traderecord_all=StrategypositionrecordT.find(:all, :order =>"openposdate DESC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum])
  end

  def individual
    @hash_commodityid=Hash["ag","白银","CF","棉花","ER","早籼稻","ME","甲醇","RO","菜籽油","SR","白糖","TA","精对苯二甲酸","WS","强麦",
                           "WT","硬麦","PM","普麦","IF","股指","a","黄大豆","al","铝","au","黄金","b","黄豆二","c","玉米",
                           "cu","铜","fu","燃料油","j","焦炭","l","聚乙烯","m","豆粕","p","棕榈油","pb","铅","rb","螺纹钢",
                           "ru","橡胶","v","聚氯乙烯","wr","线材","y","豆油","zn","锌"]

    @url_1="/strategys_combine/individual"
    @url_2="javascript:void(0)"
    @url_3="javascript:void(0)"
    @url_4="javascript:void(0)"

    @webuser = Webuser.find_by_name(session[:webuser_name])
    @strategywebs = Strategyweb.where("(strategyid like '01%'or strategyid like '02%'or strategyid like '03%') and strategyid!=010001").all

    if params[:id]!=nil
      @strategyweb = Strategyweb.find(params[:id])
      @commodityrights=CommodityrightT.where("rightid like '"+@strategyweb.strategyid+"%'").all
      @strategy_params=StrategyparamT.find_all_by_strategyid_and_ordernum_and_userid(@strategyweb.strategyid,0,0)

      @hash_params=Hash.new
      if @strategy_params!=nil
        for i in 0..@strategy_params.size-1
          @hash_params.store(@strategy_params[i].paramname ,@strategy_params[i].strategy_para_range)
        end
      end

      @rightids_arr= Array.new
      @rightids_arr_d= Array.new
      for i in 0..@commodityrights.size-1
        @rightids_arr[i]=@commodityrights[i].firstcommodityid+"-"+@commodityrights[i].secondcommodityid
        @rightids_arr_d[i]=@commodityrights[i].firstcommodityid
      end
      @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile'+@strategyweb.strategyid+'.xml'))

      if @webuser!=nil&&params[:startdate]!=nil
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
        if @webuser.level!=0
          @XMLfile.elements.to_a("//savepos")[0].text=1
        end
        file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml','w')
        file.puts @XMLfile
        file.close
        redirect_to(:controller=>"strategys_combine", :action=>"wait",:id=>params[:id])
      end

    else

    end
  end

  def reportshow
    if params[:stgtype]==nil
      @url_1="/strategys_combine/individual"
      @url_2="/strategys_combine/reportshow"
      @url_3="/strategys_combine/optimizedmethod"
      @url_4="/strategys_combine/mysubmit"
    else
      @url_1="/strategys_combine/strategy_s1"
      @url_2="/strategys_combine/strategy_s2"
      @url_3="/strategys_combine/reportshow?stgtype=d"
      @url_4="/strategys_combine/optimizedmethod?stgtype=d"
      @url_5="/strategys_combine/mysubmit?stgtype=d"
    end

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
      if @webuser.level!=0
        @dailyinfo_xml=Document.new(File.new('app/assets/xmls/posrecord-'+@webuser.id.to_s+'.xml'))

        @dailyinfo_data=Array.new
        daily_t=@dailyinfo_xml.elements.to_a("//tr")
        for i in 0..daily_t.size-1
          @dailyinfo_data[i]=[]
          for j in 0..daily_t[i].elements.to_a.size-1
            @dailyinfo_data[i][j]=daily_t[i].elements.to_a[j].text
          end
        end
      end

    end
  end

  def wait
    @url_1="/strategys_combine/individual"
    @url_2="javascript:void(0)"
    @url_3="javascript:void(0)"
    @url_4="javascript:void(0)"

    @webuser = Webuser.find_by_name(session[:webuser_name])
    if params[:wait]==nil
      Thread.new {
        system "/ZRSoftware/Tools/startBuildTests.sh 'xml' '/ZRSoftware/tongtianshun/app/assets/xmls/g_XMLfile-"+@webuser.id.to_s+".xml'"
      }
      if FileTest::exist?'app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml'
        @firstdata=File::mtime('app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml').to_i.to_json
      end
    end
    if params[:wait]!=nil
      if FileTest::exist?'app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml'
        render :json=>File::mtime('app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml').to_i.to_json
      else
        render :json=>"error".to_json
      end
    end

  end

  def wait_d
    @url_1="/strategys_combine/strategy_s1"
    @url_2="/strategys_combine/strategy_s2"
    @url_3="javascript:void(0)"
    @url_4="javascript:void(0)"

    @webuser = Webuser.find_by_name(session[:webuser_name])
    if params[:wait]==nil
      Thread.new {
        system "/ZRSoftware/Tools/startBuildTests.sh 'xml' '/ZRSoftware/tongtianshun/app/assets/xmls/g_XMLfile-"+@webuser.id.to_s+".xml' '/ZRSoftware/tongtianshun/app/assets/xmls/g_XMLfile-"+@webuser.id.to_s+"_2.xml'"
      }
      if FileTest::exist?'app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml'
        @firstdata=File::mtime('app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml').to_i.to_json
      end
    end
    if params[:wait]!=nil
      if FileTest::exist?'app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml'
        render :json=>File::mtime('app/assets/xmls/dailyinfo-'+@webuser.id.to_s+'.xml').to_i.to_json
      else
        render :json=>"error".to_json
      end
    end

  end

  def optimizedmethod

    if params[:stgtype]==""
      params[:stgtype]=nil
    end
    if params[:stgtype]==nil
      @url_1="/strategys_combine/individual"
      @url_2="/strategys_combine/reportshow"
      @url_3="/strategys_combine/optimizedmethod"
      @url_4="javascript:void(0)"
    else
      @url_1="/strategys_combine/strategy_s1"
      @url_2="/strategys_combine/strategy_s2"
      @url_3="/strategys_combine/reportshow?stgtype=d"
      @url_4="/strategys_combine/optimizedmethod?stgtype=d"
      @url_5="javascript:void(0)"
    end

    @strategywebs=Strategyweb.all
    @webuser = Webuser.find_by_name(session[:webuser_name])

    if @webuser!=nil&&params[:opmed]!=nil

      @XMLfile = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml'))
      @XMLfile.elements.to_a("//optimizedmethod")[0].text=params[:opmed]
      file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml','w')
      file.puts @XMLfile
      file.close

      if params[:stgtype]==nil
        redirect_to(:controller=>"strategys_combine", :action=>"wait_opmed")
      else
        redirect_to(:controller=>"strategys_combine", :action=>"wait_opmed",:stgtype=>"d")
      end

    end
  end

  def wait_opmed

    if params[:stgtype]==""
      params[:stgtype]=nil
    end
    if params[:stgtype]==nil
      @url_1="/strategys_combine/individual"
      @url_2="/strategys_combine/reportshow"
      @url_3="javascript:void(0)"
      @url_4="javascript:void(0)"
    else
      @url_1="/strategys_combine/strategy_s1"
      @url_2="/strategys_combine/strategy_s2"
      @url_3="/strategys_combine/reportshow?stgtype=d"
      @url_4="javascript:void(0)"
      @url_5="javascript:void(0)"
    end

    @webuser = Webuser.find_by_name(session[:webuser_name])
    if params[:wait]==nil
      if params[:stgtype]==nil
        Thread.new {
          system "/ZRSoftware/Tools/startOptimization.sh 'xml' '"+"/ZRSoftware/tongtianshun/app/assets/xmls/g_XMLfile-"+@webuser.id.to_s+".xml"+"'"
        }
      else
        Thread.new {
          system "/ZRSoftware/Tools/startOptimization.sh 'xml' '"+"/ZRSoftware/tongtianshun/app/assets/xmls/g_XMLfile-"+@webuser.id.to_s+".xml' '"+"/ZRSoftware/tongtianshun/app/assets/xmls/g_XMLfile-"+@webuser.id.to_s+"_2.xml'"
        }
      end
      if FileTest::exist?'app/assets/xmls/optimization-'+@webuser.id.to_s+'.xml'
        @firstdata=File::mtime('app/assets/xmls/optimization-'+@webuser.id.to_s+'.xml').to_i.to_json
      end
    end

    if params[:wait]!=nil
      if FileTest::exist?'app/assets/xmls/optimization-'+@webuser.id.to_s+'.xml'
        render :json=>File::mtime('app/assets/xmls/optimization-'+@webuser.id.to_s+'.xml').to_i.to_json
      else
        render :json=>"error".to_json
      end
    end

  end

  def opmed_rps
    if params[:stgtype]==""
      params[:stgtype]=nil
    end
    if params[:stgtype]==nil
      @url_1="/strategys_combine/individual"
      @url_2="/strategys_combine/reportshow"
      @url_3="/strategys_combine/optimizedmethod"
      @url_4="/strategys_combine/mysubmit"
    else
      @url_1="/strategys_combine/strategy_s1"
      @url_2="/strategys_combine/strategy_s2"
      @url_3="/strategys_combine/reportshow?stgtype=d"
      @url_4="javascript:void(0)"
      @url_5="javascript:void(0)"
    end

    @webuser = Webuser.find_by_name(session[:webuser_name])

    if @webuser
      @XMLfile = Document.new(File.new('app/assets/xmls/optimization-'+@webuser.id.to_s+'.xml'))

      @opt_title=Array.new
      @opt_data=Array.new
      opt_1=@XMLfile.elements.to_a("//tr")[0].elements.to_a
      for i in 0..opt_1.size-1
        @opt_title[i]=opt_1[i].text
      end
      opt_2=@XMLfile.elements.to_a("//tr")
      for i in 0..opt_2.size-1
        @opt_data[i]=[]
        for j in 0..opt_2[i].elements.to_a.size-1
          @opt_data[i][j]=opt_2[i].elements.to_a[j].text
        end
      end

      if params[:stgtype]==nil
        if params[:"#{@opt_title[0]}"]!=nil
          @XMLfile_2 = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml'))
          for i in 0..@opt_title.size-2
            @XMLfile_2.elements.to_a("//g_strategyparams")[0].elements.to_a[i].text=params[:"#{@opt_title[i]}"]
          end
          file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml','w')
          file.puts @XMLfile_2
          file.close

          redirect_to(:controller=>"strategys_combine", :action=>"wait")
        end
      else

        if params[:"#{@opt_title[0]}"]!=nil
          @XMLfile_3 = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml'))
          for i in 0..@XMLfile_3.elements.to_a("//g_strategyparams")[0].elements.to_a.size-1
            @XMLfile_3.elements.to_a("//g_strategyparams")[0].elements.to_a[i].text=params[:"#{@opt_title[i]}"]
          end
          file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml','w')
          file.puts @XMLfile_3
          file.close

          @XMLfile_4 = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'_2.xml'))
          for i in 0..@XMLfile_4.elements.to_a("//g_strategyparams")[0].elements.to_a.size-1
            @XMLfile_4.elements.to_a("//g_strategyparams")[0].elements.to_a[i].text=params[:"#{@opt_title[i+@XMLfile_3.elements.to_a("//g_strategyparams")[0].elements.to_a.size]}"]
          end
          file=File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'_2.xml','w')
          file.puts @XMLfile_4
          file.close
          redirect_to(:controller=>"strategys_combine", :action=>"wait_d")
        end

      end

    end
  end

  def mysubmit
    if params[:stgtype]==""
      params[:stgtype]=nil
    end
    if params[:stgtype]==nil
      @url_1="/strategys_combine/individual"
      @url_2="/strategys_combine/reportshow"
      @url_3="/strategys_combine/optimizedmethod"
      @url_4="/strategys_combine/mysubmit"
    else
      @url_1="/strategys_combine/strategy_s1"
      @url_2="/strategys_combine/strategy_s2"
      @url_3="/strategys_combine/reportshow?stgtype=d"
      @url_4="/strategys_combine/optimizedmethod?stgtype=d"
      @url_5="/strategys_combine/mysubmit?stgtype=d"
    end

    @webuser = Webuser.find_by_name(session[:webuser_name])

    #@test=@strategyparams.elements.to_a("//g_strategyparams")[0].elements.to_a[1].to_s
    #@test=@test.slice(1,@test.index(">")-1)
    if @webuser!=nil&&params[:strategyname]!=nil
      if params[:stgtype]==nil

        @strategyparams = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml'))
        @g_strategyparams=@strategyparams.elements.to_a("//g_strategyparams")[0].elements.to_a
        @g_strategyparams_arr=Array.new
        for i in 0..@g_strategyparams.size-1
          @g_strategyparams_arr[i]=@g_strategyparams[i].to_s.slice(1,@g_strategyparams[i].to_s.index(">")-1)
        end
        @stgp_arr=Array.new
        @stgp=StrategyparamT.find_by_username_and_strategyid(session[:webuser_name],@strategyparams.elements.to_a("//strategyid")[0].text)
        @ordernum=0
        @firstdb_flag=0
        if @stgp==nil
          @firstdb_flag=1
          for i in 0..@g_strategyparams.size-1
            StrategyparamT.new do |stgp|
              stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
              stgp.paramname= @g_strategyparams[i].to_s.slice(1,@g_strategyparams[i].to_s.index(">")-1)
              stgp.paramvalue=@g_strategyparams[i].text.to_f
              stgp.username=@webuser.name
              stgp.ordernum=0
              stgp.userid=0
              stgp.save
            end
          end
          @notice="策略保存成功！"
        else
          @notice="策略已存在！"
          for i in 0..@g_strategyparams_arr.size-1
            @stgp_arr[i]=StrategyparamT.find_all_by_strategyid_and_username_and_paramname(@strategyparams.elements.to_a("//strategyid")[0].text,session[:webuser_name],@g_strategyparams_arr[i])
          end
          @db_flag=0
          @ordernum_t=StrategyparamT.find(:all,:conditions =>["username=? and strategyid=?",session[:webuser_name],@strategyparams.elements.to_a("//strategyid")[0].text], :order =>"ordernum DESC",:limit => 1)
          @ordernum=@ordernum_t[0].ordernum
          for i in 0..@stgp_arr[0].size-1   #group
            count=0
            for j in 0..@stgp_arr.size-1
              if @stgp_arr[j][i].paramvalue==@g_strategyparams[j].text.to_f
                count=count+1
              end
            end
            if count==@stgp_arr.size
              @db_flag=1
              break
            end
          end
          if @db_flag==0
            @notice="策略保存成功！"
            @ordernum=@ordernum+1
            @firstdb_flag=1
            for i in 0..@g_strategyparams.size-1
              StrategyparamT.new do |stgp|
                stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text
                stgp.paramname=@g_strategyparams[i].to_s.slice(1,@g_strategyparams[i].to_s.index(">")-1)
                stgp.paramvalue=@g_strategyparams[i].text.to_f
                stgp.username=@webuser.name
                stgp.ordernum=@ordernum
                stgp.userid=@webuser.id
                stgp.save
              end
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
            system "/ZRSoftware/Tools/startBuildTests.sh 'database' '"+@strategyparams.elements.to_a("//strategyid")[0].text+"' '"+@webuser.id.to_s+"' '"+@ordernum.to_s+"'"
          }
        end

      else
        #combine
        @strategyparams = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'.xml'))
        @strategyparams_2 = Document.new(File.new('app/assets/xmls/g_XMLfile-'+@webuser.id.to_s+'_2.xml'))
        @g_strategyparams=@strategyparams.elements.to_a("//g_strategyparams")[0].elements.to_a
        @g_strategyparams_2=@strategyparams_2.elements.to_a("//g_strategyparams")[0].elements.to_a
        @g_strategyparams_arr=Array.new
        for i in 0..@g_strategyparams.size-1
          @g_strategyparams_arr[i]=@g_strategyparams[i].to_s.slice(1,@g_strategyparams[i].to_s.index(">")-1)
        end
        @stgp_arr=Array.new
        @g_strategyparams_arr_2=Array.new
        for i in 0..@g_strategyparams_2.size-1
          @g_strategyparams_arr_2[i]=@g_strategyparams_2[i].to_s.slice(1,@g_strategyparams_2[i].to_s.index(">")-1)
        end
        @stgp_arr_2=Array.new

        @stgp=StrategyparamT.find_by_username_and_strategyid(session[:webuser_name],@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text)

        @ordernum=1
        @firstdb_flag=0
        if @stgp==nil
          @firstdb_flag=1
          for i in 0..@g_strategyparams.size-1
            StrategyparamT.new do |stgp|
              stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text
              stgp.paramname= @g_strategyparams[i].to_s.slice(1,@g_strategyparams[i].to_s.index(">")-1)
              stgp.paramvalue=@g_strategyparams[i].text.to_f
              stgp.username=@webuser.name
              stgp.ordernum=@ordernum
              stgp.userid=@webuser.id
              stgp.save
            end
          end
          for i in 0..@g_strategyparams_2.size-1
            StrategyparamT.new do |stgp|
              stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text
              stgp.paramname= @g_strategyparams_2[i].to_s.slice(1,@g_strategyparams_2[i].to_s.index(">")-1)
              stgp.paramvalue=@g_strategyparams_2[i].text.to_f
              stgp.username=@webuser.name
              stgp.ordernum=1
              stgp.userid=@webuser.id
              stgp.save
            end
          end
          @notice="策略保存成功！"
        else
          #stgpara!=nil  comnbine   stgp_arr.size为xml参数数

          @notice="策略已存在！"

          @ordernum_t=StrategyparamT.find(:all,:conditions =>["username=? and strategyid=?",session[:webuser_name],@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text], :order =>"ordernum DESC",:limit => 1)
          @ordernum=@ordernum_t[0].ordernum

          for i in 0..@g_strategyparams_arr.size-1
            @stgp_arr[i]=StrategyparamT.find_all_by_strategyid_and_username_and_paramname(@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text,session[:webuser_name],@g_strategyparams_arr[i])
          end

          for i in 0..@stgp_arr.size-1
            if @stgp_arr[i].size>1 #多组
              if @stgp_arr[i][1].id-@stgp_arr[i][0].id<@g_strategyparams_arr.size+@g_strategyparams_arr_2.size
                @kk=1
                for j in 0..@stgp_arr[i].size-1
                  if j%2!=0
                    @stgp_arr[i][j]=nil

                  end
                end
                @stgp_arr[i]=@stgp_arr[i].compact
              end
            end
          end

          for i in 0..@g_strategyparams_arr_2.size-1
            @stgp_arr_2[i]=StrategyparamT.find_all_by_strategyid_and_username_and_paramname(@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text,session[:webuser_name],@g_strategyparams_arr_2[i])
          end

          for i in 0..@stgp_arr_2.size-1
            if @stgp_arr_2[i].size>1 #多组
              if @stgp_arr_2[i][1].id-@stgp_arr_2[i][0].id<@g_strategyparams_arr.size+@g_strategyparams_arr_2.size
                for j in 0..@stgp_arr_2[i].size-1
                  if j%2==0
                    @stgp_arr_2[i][j]=nil
                  end
                end
                @stgp_arr_2[i]=@stgp_arr_2[i].compact
              end
            end
          end

          @stgp_arr=@stgp_arr+@stgp_arr_2

          @db_flag=0

          for i in 0..@stgp_arr[0].size-1   #group  ordernum

            count=0
            for j in 0..@g_strategyparams.size-1
              if @stgp_arr[j][i].paramvalue==@g_strategyparams[j].text.to_f
                count=count+1
              end
            end
            for j in 0..@g_strategyparams_2.size-1
              if @stgp_arr[j+@g_strategyparams.size][i].paramvalue==@g_strategyparams_2[j].text.to_f
                count=count+1
              end
            end

            if count==@stgp_arr.size
              @db_flag=1
              break
            end
          end
          if @db_flag==0
            @notice="策略保存成功！"
            @ordernum=@ordernum+1
            @firstdb_flag=1
            for i in 0..@g_strategyparams.size-1
              StrategyparamT.new do |stgp|
                stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text
                stgp.paramname= @g_strategyparams[i].to_s.slice(1,@g_strategyparams[i].to_s.index(">")-1)
                stgp.paramvalue=@g_strategyparams[i].text.to_f
                stgp.username=@webuser.name
                stgp.ordernum=@ordernum
                stgp.userid=@webuser.id
                stgp.save
              end
            end
            for i in 0..@g_strategyparams_2.size-1
              StrategyparamT.new do |stgp|
                stgp.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text
                stgp.paramname= @g_strategyparams_2[i].to_s.slice(1,@g_strategyparams_2[i].to_s.index(">")-1)
                stgp.paramvalue=@g_strategyparams_2[i].text.to_f
                stgp.username=@webuser.name
                stgp.ordernum=@ordernum
                stgp.userid=@webuser.id
                stgp.save
              end
            end
          end

        end

        if @firstdb_flag==1
          Strategyweb.new do |stgweb|
            stgweb.name=params[:strategyname]
            stgweb.description=params[:description]
            stgweb.price=params[:price]
            stgweb.trydays=params[:trydays]
            stgweb.strategyid=@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text
            stgweb.strategytype=@strategyparams.elements.to_a("//objecttype")[0].text

            @commodity_1=Array.new
            @commodity_2=Array.new
            for i in 0..@strategyparams.elements.to_a("//item").size-1
              @commodity_1[i]=@strategyparams.elements.to_a("//item")[i].text
            end
            for i in 0..@strategyparams_2.elements.to_a("//item").size-1
              @commodity_2[i]=@strategyparams_2.elements.to_a("//item")[i].text
            end
            temp_arr=@commodity_1&@commodity_2
            temp=temp_arr[0]
            for i in 1..temp_arr.size-1
              temp=temp+"|"+temp_arr[i]
            end
            stgweb.commoditynames=temp
            if @ordernum==0
              stgweb.userid=0
            else
              stgweb.userid=@webuser.id
            end
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
            system "/ZRSoftware/Tools/startBuildTests.sh 'database' '"+@strategyparams.elements.to_a("//strategyid")[0].text+"-"+@strategyparams_2.elements.to_a("//strategyid")[0].text+"' '"+@webuser.id.to_s+"' '"+@ordernum.to_s+"'"
          }
        end

      end
    end

  end

end