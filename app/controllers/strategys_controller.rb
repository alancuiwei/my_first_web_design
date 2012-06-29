#encoding: utf-8
require 'rubygems'
require 'builder'
require 'rexml/document'
include REXML
class StrategysController < ApplicationController

  def show
    @strat_profit=200000
    @strategyweb = Strategyweb.find(params[:id])
    @traderecord=StrategypositionrecordT.find(:all, :order =>"openposdate DESC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum],:limit => 10)
    @streference = StrategyreferenceT.find_all_by_strategyid_and_userid_and_ordernum_and_rightid(@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000")
   # @strategyreturnrates=StrategyreturnrateT.find_all_by_rightid("010603000000")
   # @returnrate_arr=Array.new
   # if params[:getjson]!=nil
   #   i=0
   #      @strategyreturnrates.each do |stgreturnrate|
   #       str=stgreturnrate.yearid.to_s+"-"+stgreturnrate.monthid.to_s+"-"+get_days(stgreturnrate.yearid,stgreturnrate.monthid).to_s
   #         @returnrate_arr[i]=[DateTime.strptime(str, "%Y-%m-%d").to_i*1000,stgreturnrate.returnrate*100]
   #        i=i+1
   #      end
   # render :json => @returnrate_arr #render json #render json
   # end
   # @s_profits=StrategypositionrecordT.all
    #@hash_profit=Hash.new
    #@profit_arr=Array.new
    @profits_lastday=StrategypositionrecordT.find(:all, :order =>"closeposdate DESC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum],:limit => 1)[0].closeposdate
    @profits_first=StrategypositionrecordT.find(:all, :order =>"closeposdate ASC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum],:limit => 1)[0].closeposdate

    @days=(DateTime.strptime(@profits_lastday.to_s(:db),"%Y-%m-%d").to_i-DateTime.strptime(@profits_first.to_s(:db),"%Y-%m-%d").to_i)/86400

    #for i in 0..@days
    #  @hash_profit.store(1026777600000+i*86400000,0)
    #end

    #  @s_profits.each do |profit|
    #    if @hash_profit[DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000]==0
    #       @hash_profit.store(DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000,profit.profit)
    #    else
    #      @profit_temp=@hash_profit[DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000]+profit.profit
    #      @hash_profit.store(DateTime.strptime(profit.closeposdate.to_s(:db), "%Y-%m-%d").to_i*1000,@profit_temp)
    #   end
    #  end
    #for i in 0..@days
    #  if i==0
    #    @profit_t=0
    #  end
   #   if @hash_profit[1026777600000+i*86400000]!=0
   #     @profit_t=@profit_t+@hash_profit[1026777600000+i*86400000]
   #     @hash_profit.store(1026777600000+i*86400000,@profit_t)
   #     else
    #    @hash_profit.store(1026777600000+i*86400000,@profit_t)
    #    end
    #end

    #for i in 0..@days
    #Profitchart.new do |profit|
    #  profit.dateint=@hash_profit.keys[i]
    #  profit.profit= @hash_profit[@hash_profit.keys[i]]
    #  profit.save
    #end
    #end

    @profits=Profitchart.all
    @profit_arr=Array.new
    i=0
      @profits.each do |profit|
       @profit_arr[i]=[profit.dateint,profit.profit+@strat_profit]
      i=i+1
      end

    if params[:getprofit]!=nil

     render :json => @profit_arr #render json #render json
     #@strategyweb = Strategyweb.find_by_name("羽根英树正向套利")
     #@strategyweb.update_attributes(:anreturn=>((@profit_arr[@days][1]-@strat_profit)/@strat_profit))
    end

    #return table
    @returnrate_lastyearnum=StrategyreturnrateT.find(:all, :order =>"yearid DESC,monthid DESC" ,:limit => 1,:conditions =>["strategyid=? and userid=? and ordernum=? and rightid=?",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"])
    @returnrate_lastyear=StrategyreturnrateT.find(:all, :conditions =>["yearid=? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_lastyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"],:order =>"monthid ASC" )
    @returnrate_others=StrategyreturnrateT.find(:all, :conditions =>["yearid<? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_lastyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"],:order =>"yearid DESC,monthid ASC")
    if @returnrate_others.size%12==0
    @returnrate_others_size=@returnrate_others.size/12
    else
      @returnrate_others_size=@returnrate_others.size/12+1
    end

    @returnrate_firstyearnum=StrategyreturnrateT.find(:all, :order =>"yearid ASC" ,:limit => 1,:conditions =>["strategyid=? and userid=? and ordernum=? and rightid=?",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"])
    @returnrate_firstyear=StrategyreturnrateT.find(:all, :conditions =>["yearid=? and strategyid=? and userid=? and ordernum=? and rightid=?",@returnrate_firstyearnum[0].yearid,@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum,@strategyweb.strategyid+"000000"],:order =>"monthid ASC" )

  end

  def showall
    @traderecord_all=StrategypositionrecordT.find(:all, :order =>"openposdate DESC",:conditions =>["strategyid=? and userid=? and ordernum=? ",@strategyweb.strategyid,@strategyweb.userid,@strategyweb.ordernum])
  end

  def intro
    @strategyweb = Strategyweb.find(params[:id])
  end

  def individual
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
    redirect_to(:controller=>"strategys", :action=>"wait",:id=>params[:id])
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
    end
  end

  def wait
    @strategyweb = Strategyweb.find(params[:id])
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
          stgweb.save
        end

      end

     end
  end

  def subscribe
    @strategy=Strategyweb.find(params[:id])
  end

  def pay
    @strategy=Strategyweb.find(params[:id])
  end

  def myprocess
    #system 'app/assets/xmls/ZR_PROGRAM_BuiltTestResult.exe'
  end

  def get_days(y,m)
    case m
      when 1,3,5,7,8,10,12
        31
      when 4,6,9,11
        30
      when 2
        if leap_year(y)==1
          29
          else
            28
            end
    end
  end

  def leap_year(year)
  if year%400==0
    else
      if year%100==0
        return 0
        else
          if year%4==0
            return 1
            else
            return 0
          end
        end
      end
    end
end

