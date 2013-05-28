#encoding: utf-8
class UsersurveyController < ApplicationController
  def userinfo
    if params[:id]!=nil
       @webuser=Webuser.find_by_id(params[:id])
       if @webuser==nil
         redirect_to(:controller=>"admin", :action=>"index")
       else
         @personalfinance=Personalfinance.find_by_username(@webuser.username)
         if @personalfinance==nil
            @person=1
         end
       end
    else
      redirect_to(:controller=>"admin", :action=>"index")
    end
  end

  def freeapply
    if session[:webusername]!=nil
     @webuser=Webuser.find_by_username(session[:webusername])
    else
     @webuser=Webuser.find_by_username("admin")
    end
  end

  def dreamconfig
    @webuser=Webuser.find_by_username(params[:username])
    @personalfinance=Personalfinance.find_by_username(params[:username])

    @webuser.update_attributes(:dream=>params[:dream],:province=>params[:province],:city=>params[:city],
                               :amount=>params[:amount],:realizetime=>params[:realizetime],:monthpay=>params[:monthpay],:scharge=>params[:scharge],:remark=>params[:remark],:isauto=>0)
    if @personalfinance!=nil
      @personalfinance.update_attributes(:investamount=>params[:investamount])
    else
      Personalfinance.new do |w|
        w.username=params[:username]
        w.investamount=params[:investamount]
        w.save
      end
    end
    render :json => "s".to_json
  end

  def zhifubao
      @webuser = Webuser.find_by_username(session[:webusername])
      Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
      @subsribe_id=Time.now.to_s(:stamp)+'-'+@webuser.id.to_s
      parameters = {
          'service' => 'create_partner_trade_by_buyer',
          'partner' => '2088801189204575',
          '_input_charset' => 'utf-8',
          'return_url' => 'http://www.tongtianshun.com/personmanagement/investor',
          'seller_email' => 'zhongrensoft@gmail.com',
          'out_trade_no' => @subsribe_id,
          'subject' => '梦想实现',
        'price' => params[:scharge],
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
end
