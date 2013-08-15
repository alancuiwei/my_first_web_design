#encoding: utf-8
class PersonmanagementController < ApplicationController

  def selectproduct
    @webuser = Webuser.find_by_username(params[:username])
    @webuser.update_attributes(:selection=>params[:selection])
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
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
      @examination=Examination.find_by_username(session[:webusername])
      @record=Record.find_all_by_username(session[:webusername])
    else
      redirect_to(:controller=>"sales", :action=>"login", :summary=>"1")
    end
    @hash3={}
    @financial3=Financial.find_all_by_classify('货币基金')
    for i in 0..@financial3.size-1
      @financial5=Financial.find_all_by_productcode(@financial3[i].productcode)
      @f1=@financial3[i].pname
      @f5=@financial3[i].rate
      @f6=@financial3[i].rank
      for j in 0..@financial5.size-1
        if @financial5[j].pname!=@financial3[i].pname
          @f1=@financial5[j].pname
          @f5=@financial5[j].rate
          @f6=@financial5[j].rank
        end
      end
      @f2='否'
      @f3='否'
      @f4='否'
      if @financial3[i].way!=nil
      if @financial3[i].way.include? "iphone"
        @f2='是'
      end
      if @financial3[i].way.include? "android"
        @f3='是'
      end
      if @financial3[i].way.include? "weixin"
        @f4='是'
      end
      end
      @hash3.store(@financial3[i].id,[@financial5.length,@f1,@f2,@f3,@f4,@f5,@f6])
    end
    @financial4=Financial.find_all_by_category('保本型资产')
    @category1=Category_2.find_all_by_risklevel(1)
    @category2=Category_2.find_all_by_risklevel(2)
    @category3=Category_2.find_all_by_risklevel(3)
    @category4=Category_2.find_all_by_risklevel(4)
    @category5=Category_2.find_all_by_risklevel(5)
    @hash={}
    @hash2={}
    @category=Category_2.all
    for i in 0..@category.size-1
      @financial=Financial.find_all_by_classify(@category[i].classify)
      @hash2.store(@category[i].id,[@financial.length])
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
      @category1=Category_2.find_all_by_risklevel(1)
      @category2=Category_2.find_all_by_risklevel(2)
      @category3=Category_2.find_all_by_risklevel(3)
      @category4=Category_2.find_all_by_risklevel(4)
      @category5=Category_2.find_all_by_risklevel(5)
      @hash={}
      @category=Category_2.all
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
    @examination.update_attributes(:xianp=>params[:xianp],
                                   :wenp=>params[:wenp],:fengp=>params[:fengp])
    @webuser = Webuser.find_by_username(params[:username])
    if @webuser!=nil
      @webuser.update_attributes(:selection=>params[:selection],:selectproductl=>params[:selectproductl],:selectproductb=>params[:selectproductb])
    end
    render :json => "s".to_json
  end

  def personconfigajax
        @webuser=Webuser.find_by_username(session[:webusername])
    @webuser.update_attributes(:risktolerance=>params[:risktolerance]);
        @personalfinance=Personalfinance.find_by_username(session[:webusername])
      if @personalfinance==nil
        Personalfinance.new do |b|
          b.username=params[:username]
          b.investamount=params[:investamount]
          b.investcycle=params[:investcycle]
          b.returnrate=params[:returnrate]
          b.age=params[:age]
          b.riskrate=params[:riskrate]
          b.investvarieties=params[:investvarieties]
          b.wbreedinfo=params[:wbreedinfo]
          b.fluctuation=params[:fluctuation]
          b.quota=params[:quota]
          b.options=params[:options]
          b.goal=params[:goal]
          b.save
        end
        render :json => "s1".to_json
      else
      @personalfinance.update_attributes(:age=>params[:age],:fluctuation=>params[:fluctuation],
                                           :quota=>params[:quota],:investamount=>params[:investamount],:returnrate=>params[:returnrate],
                                           :investcycle=>params[:investcycle],:wbreedinfo=>params[:wbreedinfo],:investvarieties=>params[:investvarieties],
                                           :riskrate=>params[:riskrate],:options=>params[:options],:goal=>params[:goal])
      render :json => "s2".to_json
    end
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
      r.save
    end
    render :json => "s1".to_json
   else
     @record=Record.find_by_id(params[:id])
     @record.update_attributes(:username=>params[:username],:date=>params[:date],:pname=>params[:pname],:amount=>params[:amount],:nature=>params[:nature])
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
    end

    render :json => "s1".to_json
  end

  def personfinance
    @financial=Financial.all
    if  session[:webusername]!=nil
      @webusers=Webuser.find_by_username(session[:webusername])
    else
      @webusers=Webuser.find_by_username('admin')
    end
    if  params[:id]!=nil
      @webuser=Webuser.find_by_id(params[:id])
      @record=Record.find_all_by_username(@webuser.username)
      @date=Record.find_by_sql('select min(date) from recore where username="'+@webuser.username+'"')
      @finance1=Financial.find_by_pname(@webuser.selectproductl)
        if @finance1!=nil
          @category1=Category_2.find_by_classify(@finance1.classify)
        end
      @finance2=Financial.find_by_pname(@webuser.selectproductb)
      if @finance2!=nil
        @category2=Category_2.find_by_classify(@finance2.classify)
      end
      @finance3=Financial.find_by_pname(@webuser.selection)
      if @finance3!=nil
        @category3=Category_2.find_by_classify(@finance3.classify)
      end
      @examination=Examination.find_by_username(@webuser.username)
      @comments=Comments.find_all_by_pid(params[:id])
    elsif session[:webusername]!=nil
        @webuser=Webuser.find_by_username(session[:webusername])
        @record=Record.find_all_by_username(session[:webusername])
        @finance1=Financial.find_by_pname(@webuser.selectproductl)
        if @finance1!=nil
          @category1=Category_2.find_by_classify(@finance1.classify)
        end
        @finance2=Financial.find_by_pname(@webuser.selectproductb)
        if @finance2!=nil
          @category2=Category_2.find_by_classify(@finance2.classify)
        end
        @finance3=Financial.find_by_pname(@webuser.selection)
        if @finance3!=nil
          @category3=Category_2.find_by_classify(@finance3.classify)
        end
        @examination=Examination.find_by_username(@webuser.username)
        @comments=Comments.find_all_by_pid(@webuser.id)
    else
      redirect_to(:controller=>"home")
    end
  end
end