#encoding: utf-8
require 'date'
class PersonmanagementController < ApplicationController

  def selectproduct
    @webuser = Webuser.find_by_username(params[:username])
    @userfinancedata=User_finance_data.find_by_username(@webuser.username)
    if @userfinancedata!=nil
      @userfinancedata.update_attributes(:risk_productid=>params[:risk_productid])
    else
      User_finance_data.new do |u|
        u.username=params[:username]
        u.fluid_productid=params[:fluid_productid]
        u.save
      end
    end
    render :json => "s".to_json
  end

   def movablewall
     @activity=Activity.find_by_sql("select * from activity order by id desc")
   end

   def activity
    if params[:id]!=nil
      @activity=Activity.find_by_id(params[:id])
    else
      redirect_to(:controller=>"personmanagement", :action=>"movablewall")
    end
   end

  def summary
    @blog=Blog.find_by_id(469)
    @blog2=Blog.find_by_id(472)
    @blog3=Blog.find_by_id(467)
    @blog4=Blog.find_by_id(468)
    @blog5=Blog.find_by_id(111)
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @userfinancedata=User_finance_data.find_by_username(@webuser.username)
      @assetsheet=User_asset_sheet.find_all_by_username(session[:webusername])
      @assettype=Admin_asset_type.all
      @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
      @hash4={}
      for i in 0..@assettype.size-1
        @hash4.store(@assettype[i].asset_typeid.to_i,[@assettype[i].asset_typename,@assettype[i].asset_type_L1])
      end
      @record=Record.find_all_by_username(session[:webusername])
      @userdatamonth=Userdata_month.find_by_username(session[:webusername])
    else
      redirect_to(:controller=>"usermanagement", :action=>"login", :summary=>"1")
    end
    @fundproduct=Fund_product.all

    @hash3={}
    @hash5={}
    for i in 0..@fundproduct.size-1
      @average=Average_return_rate.find_by_typeid_and_years(@fundproduct[i].productid,1)
      if @average!=nil
      f1=@average.average_return_rate
      else
       f1=''
      end
      @rank=Rank.find_by_productid_and_years(@fundproduct[i].productid,1)
      if @rank!=nil
        f2=@rank.rank_num
        f3=@rank.total_num
      else
        f2=''
        f3=''
      end
      @quote=Monetary_fund_quote.find_by_product_code(@fundproduct[i].product_code)
      t = Time.new
      date = t.strftime("%Y-%m-%d")
      if @quote!=nil
        if @fundproduct[i].create_date!=nil
        @hash5.store(@fundproduct[i].product_code,[@quote.date,@quote.million_income,@quote.sevenD_years_return,@quote.one_year_return,@quote.two_year_return,@quote.three_year_return,@quote.one_year_rank,@quote.two_year_rank,@quote.three_year_rank,DateTime.parse(date)-DateTime.parse(@fundproduct[i].create_date.to_s)])
        else
          @hash5.store(@fundproduct[i].product_code,[@quote.date,@quote.million_income,@quote.sevenD_years_return,@quote.one_year_return,@quote.two_year_return,@quote.three_year_return,@quote.one_year_rank,@quote.two_year_rank,@quote.three_year_rank,nil])
        end
      else
        if @fundproduct[i].create_date!=nil
          @hash5.store(@fundproduct[i].product_code,[nil,nil,nil,nil,nil,nil,nil,nil,nil,DateTime.parse(date)-DateTime.parse(@fundproduct[i].create_date.to_s)])
        else
          @hash5.store(@fundproduct[i].product_code,[nil,nil,nil,nil,nil,nil,nil,nil,nil,nil])
        end
      end
      @hash3.store(@fundproduct[i].productid,[f1,f2,f3])
    end

    @financial4=Financial.find_all_by_category('保本性资产')
    @category1=Admin_asset_type_l2.find_all_by_risklevel(1)
    @category2=Admin_asset_type_l2.find_all_by_risklevel(2)
    @category3=Admin_asset_type_l2.find_all_by_risklevel(3)
    @category4=Admin_asset_type_l2.find_all_by_risklevel(4)
    @category5=Admin_asset_type_l2.find_all_by_risklevel(5)
    @hash={}
    @hash2={}
    @category=Admin_asset_type_l2.all
    for i in 0..@category.size-1
      loss1='--';loss2='--';loss3='--';max1='--';max2='--';max3='--';
      @loss=Loss_probability.find_by_typeid_and_years(@category[i].L2_typeid,1)
      if @loss!=nil
        loss1=@loss.probability.round(3)
      end
      @loss=Loss_probability.find_by_typeid_and_years(@category[i].L2_typeid,2)
      if @loss!=nil
        loss2=@loss.probability.round(3)
      end
      @loss=Loss_probability.find_by_typeid_and_years(@category[i].L2_typeid,3)
      if @loss!=nil
        loss3=@loss.probability.round(3)
      end
      @max=Max_return_rate.find_by_typeid_and_years(@category[i].L2_typeid,1)
      if @max!=nil
        max1=@max.returnrate
      end
      @max=Max_return_rate.find_by_typeid_and_years(@category[i].L2_typeid,2)
      if @max!=nil
        max2=@max.returnrate
      end
      @max=Max_return_rate.find_by_typeid_and_years(@category[i].L2_typeid,3)
      if @max!=nil
        max3=@max.returnrate
      end
      @hash2.store(@category[i].L2_typeid,[@category[i].classify,loss1,loss2,loss3,max1,max2,max3])
      @hash.store(i,[@category[i].id,@category[i].classify])
    end
    @financial2=Financial.all
    @hash6={}
    @monetaryfundquote=Monetary_fund_quote.all
    t = Time.new
    date = t.strftime("%Y-%m-%d")
    for i in 0..@monetaryfundquote.size-1
      @product=Fund_product.find_by_product_code(@monetaryfundquote[i].product_code)
      if @product!=nil
        if @product.create_date!=nil
          @hash6.store(@monetaryfundquote[i].product_code,[@product.min_purchase_account,DateTime.parse(date)-DateTime.parse(@product.create_date.to_s),@product.fund_size])
        else
          @hash6.store(@monetaryfundquote[i].product_code,[@product.min_purchase_account,nil,@product.fund_size])
        end
      else
        @hash6.store(@monetaryfundquote[i].product_code,[nil,nil,nil])
      end
    end
    @generalfundquote=General_fund_quote.all
    for i in 0..@generalfundquote.size-1
      @product=General_fund_product.find_by_product_code(@generalfundquote[i].product_code)
      if @product!=nil
        if @product.date!=nil
          @hash6.store(@generalfundquote[i].product_code,[1000,DateTime.parse(date)-DateTime.parse(@product.date.to_s),@product.fund_size])
        else
          @hash6.store(@generalfundquote[i].product_code,[1000,nil,@product.fund_size])
        end
      else
        @hash6.store(@generalfundquote[i].product_code,[nil,nil,nil])
      end
    end
  end

  def zhifubao
    @webuser = Webuser.find_by_username(session[:webusername])
    Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
    @subsribe_id=Time.now.to_s(:stamp)+'-'+@webuser.username
    if session[:webusername]=='tester'
      @tester='0.01'
    else
      @tester=params[:scharge]
    end
    parameters = {
        'service' => 'create_partner_trade_by_buyer',
        'partner' => '2088801189204575',
        '_input_charset' => 'utf-8',
        'return_url' => 'http://www.tongtianshun.com/personmanagement/activity/'+params[:aid]+'?username='+session[:webusername],
        'seller_email' => 'zhongrensoft@gmail.com',
        'out_trade_no' => @subsribe_id,
        'subject' => '活动报名',
        'price' => @tester,
        'quantity' => '1',
        'payment_type' => '1',
        'logistics_type'=>'EMS',
        'logistics_fee' => '0',
        'logistics_payment'=>'BUYER_PAY',
        'logistics_type_1'=>'POST',
        'logistics_fee_1' => '0',
        'logistics_payment_1'=>'BUYER_PAY',
        'logistics_type_2'=>'EXPRESS',
        'logistics_fee_2' => '0',
        'logistics_payment_2'=>'BUYER_PAY'
    }
    values = {}
    # 支付宝要求传递的参数必须要按照首字母的顺序传递，所以这里要sort
    parameters.keys.sort.each do |k|
      values[k] = parameters[k];
    end
    # 一定要先unescape后再生成sign，否则支付宝会报ILLEGAL SIGN
    sign = Digest::MD5.hexdigest(CGI.unescape(values.to_query) + 'xf1fj8kltbbc766co0ziulq1wowejpzm')
    gateway = 'https://mapi.alipay.com/gateway.do?'
    @alipy_url= gateway + values.to_query + '&sign=' + sign + '&sign_type=MD5'
    render :json => @alipy_url.to_json
  end

  def share
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
    end
      @category1=Admin_asset_type_l2.find_all_by_risklevel(1)
      @category2=Admin_asset_type_l2.find_all_by_risklevel(2)
      @category3=Admin_asset_type_l2.find_all_by_risklevel(3)
      @category4=Admin_asset_type_l2.find_all_by_risklevel(4)
      @category5=Admin_asset_type_l2.find_all_by_risklevel(5)
      @hash={}
      @category=Admin_asset_type_l2.all
      for i in 0..@category.size-1
        @financial=Financial.find_all_by_classify(@category[i].classify)
        a=''
        for j in 0..@financial.size-1
          if j==0
            a=@financial[j].id
          else
            a=a.to_s+','+@financial[j].id.to_s
          end
        end
        @hash.store(i,[@category[i].id,@category[i].classify,a])
      end
      @financial2=Financial.all
  end

  def userajax
    @examination=Examination.find_by_username(params[:username])
    if @examination!=nil
    @examination.update_attributes(:xianp=>params[:xianp],
                                   :wenp=>params[:wenp],:fengp=>params[:fengp])
    end
    @userfinancedata=User_finance_data.find_by_username(params[:username])
    if @userfinancedata!=nil
      @userfinancedata.update_attributes(:risk_productid=>params[:risk_productid],:fluid_productid=>params[:fluid_productid],:safe_productid=>params[:safe_productid])
    else
      User_finance_data.new do |u|
        u.username=params[:username]
        u.risk_productid=params[:risk_productid]
        u.fluid_productid=params[:fluid_productid]
        u.safe_productid=params[:safe_productid]
        u.save
      end
    end
    render :json => "s".to_json
  end

  def personconfigajax
    @webuser=Webuser.find_by_username(session[:webusername])
    @userfinancedata=User_finance_data.find_by_username(session[:webusername])
    if @userfinancedata==nil
      User_finance_data.new do |w|
        w.username=params[:username]
        w.risk_score=params[:risk_score]
        w.save
      end
    else
      @userfinancedata.update_attributes(:risk_score=>params[:risk_score])
    end
    render :json => "s".to_json
  end

  def record
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
        @record=Record.find_all_by_username(@webuser.username)
      elsif session[:webusername]!=nil
        @record=Record.find_all_by_username(session[:webusername])
      else
         redirect_to(:controller=>"home")
      end
  end

  def recordconfigajax
   if params[:id]=='0'
    Record.new do |r|
      r.username=params[:username]
      r.date=params[:date]
      r.pname=params[:pname]
      r.amount=params[:amount]
      r.nature=params[:nature]
      if params[:ptype]=='1'
        r.productcode=params[:productcode]
        r.productshare=params[:productshare]
      end
      r.save
    end
    render :json => "s1".to_json
   else
     @record=Record.find_by_id(params[:id])
     @record.update_attributes(:username=>params[:username],:date=>params[:date],:pname=>params[:pname],:amount=>params[:amount],:nature=>params[:nature])
     if params[:ptype]=='1'
       @record.update_attributes(:productcode=>params[:productcode],:productshare=>params[:productshare])
     end
     render :json => "s2".to_json
   end
  end

  def recorddeleteajax
    @record=Record.find_by_id(params[:id])
    if @record!=nil
      if @record.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def monthconfigajax
    @examination=Examination.find_by_username(session[:webusername])
    if @examination!=nil
      @examination.update_attributes(:month01=>params[:month01],:month02=>params[:month02],:month03=>params[:month03],:month11=>params[:month11],:month12=>params[:month12],:month13=>params[:month13],
                                       :month21=>params[:month21],:month22=>params[:month22],:month23=>params[:month23],:month31=>params[:month31],:month32=>params[:month32],:month33=>params[:month33],
                                       :month41=>params[:month41],:month42=>params[:month42],:month43=>params[:month43],:month51=>params[:month51],:month52=>params[:month52],:month53=>params[:month53],
                                       :month61=>params[:month61],:month62=>params[:month62],:month63=>params[:month63],:month71=>params[:month71],:month72=>params[:month72],:month73=>params[:month73],
                                       :month81=>params[:month81],:month82=>params[:month82],:month83=>params[:month83],:month91=>params[:month91],:month92=>params[:month92],:month93=>params[:month93],
                                       :month101=>params[:month101],:month102=>params[:month102],:month103=>params[:month103],:month111=>params[:month111],:month112=>params[:month112],:month113=>params[:month113]);
    if params[:tol1]!=nil && params[:tol1]!=''
      @examination.update_attributes(:tol1=>params[:tol1],:tol2=>params[:tol2]);
    end
    else
      Examination.new do |w|
        w.username=params[:username]
        w.month01=params[:month01]
        w.month02=params[:month02]
        w.month03=params[:month03]
        w.month11=params[:month11]
        w.month12=params[:month12]
        w.month13=params[:month13]
        w.month21=params[:month21]
        w.month22=params[:month22]
        w.month23=params[:month23]
        w.month31=params[:month31]
        w.month32=params[:month32]
        w.month33=params[:month33]
        w.month41=params[:month41]
        w.month42=params[:month42]
        w.month43=params[:month43]
        w.month51=params[:month51]
        w.month52=params[:month52]
        w.month53=params[:month53]
        w.month61=params[:month61]
        w.month62=params[:month62]
        w.month63=params[:month63]
        w.month71=params[:month71]
        w.month72=params[:month72]
        w.month73=params[:month73]
        w.month81=params[:month81]
        w.month82=params[:month82]
        w.month83=params[:month83]
        w.month91=params[:month91]
        w.month92=params[:month92]
        w.month93=params[:month93]
        w.month101=params[:month101]
        w.month102=params[:month102]
        w.month103=params[:month103]
        w.month111=params[:month111]
        w.month112=params[:month112]
        w.month113=params[:month113]
        w.save
      end
    end

    render :json => "s1".to_json
  end

  def personfinance
    @financial=Financial.all
    @assettype=Admin_asset_type.all
    if  session[:webusername]!=nil
      @webusers=Webuser.find_by_username(session[:webusername])
    else
      @webusers=Webuser.find_by_username('admin')
    end
    if  params[:id]!=nil
      @webuser=Webuser.find_by_id(params[:id])
      @userfinancedata=User_finance_data.find_by_username(@webuser.username)
      @userbalancesheet=User_balance_sheet.find_by_username(@webuser.username)
      @record=Record.find_all_by_username(@webuser.username)
      @userdatamonth=Userdata_month.find_by_username(@webuser.username)
      if @userfinancedata!=nil
        @finance1=Fund_product.find_by_productname(@userfinancedata.fluid_productid)
        if @finance1!=nil
          @category1=Admin_asset_type_l2.find_by_classify(@finance1.L2_typename)
        end
        @finance2=Financial.find_by_pname(@userfinancedata.safe_productid)
        if @finance2!=nil
          @category2=Admin_asset_type_l2.find_by_classify(@finance2.classify)
        end
        @finance3=Financial.find_by_pname(@userfinancedata.risk_productid)
        if @finance3!=nil
          @category3=Admin_asset_type_l2.find_by_classify(@finance3.classify)
        end
      end
      @examination=Examination.find_by_username(@webuser.username)
      @comments=Comments.find_all_by_pid(params[:id])
    elsif session[:webusername]!=nil
        @webuser=Webuser.find_by_username(session[:webusername])
        @userfinancedata=User_finance_data.find_by_username(@webuser.username)
        @userbalancesheet=User_balance_sheet.find_by_username(session[:webusername])
        @record=Record.find_all_by_username(session[:webusername])
        @userdatamonth=Userdata_month.find_by_username(session[:webusername])
        if @userfinancedata!=nil
          @finance1=Fund_product.find_by_productname(@userfinancedata.fluid_productid)
          if @finance1!=nil
            @category1=Admin_asset_type_l2.find_by_classify(@finance1.L2_typename)
          end
          @finance2=Financial.find_by_pname(@userfinancedata.safe_productid)
          if @finance2!=nil
            @category2=Admin_asset_type_l2.find_by_classify(@finance2.classify)
          end
          @finance3=Financial.find_by_pname(@userfinancedata.risk_productid)
          if @finance3!=nil
            @category3=Admin_asset_type_l2.find_by_classify(@finance3.classify)
          end
        end
        @examination=Examination.find_by_username(@webuser.username)
        @comments=Comments.find_all_by_pid(@webuser.id)
    else
      redirect_to(:controller=>"home")
    end
  end
end