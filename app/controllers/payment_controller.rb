#encoding: utf-8
class PaymentController < ApplicationController
   def index
     if session[:webusername]!=nil
       @webuser = Webuser.find_by_username(session[:webusername])
     else
       redirect_to(:controller=>"usermanagement", :action=>"login", :payment=>"1")
     end
   end

   def buyhouse
     if session[:webusername]!=nil
       @webuser = Webuser.find_by_username(session[:webusername])
     end
   end

   def ischarge
     if params[:userid]!=nil
       @webuser = Webuser.find_by_id(params[:userid])
       if @webuser!=nil
         @webuser.update_attributes(:ischarge=>1)
       end
     end
   end

   def zhifubao
     @webuser = Webuser.find_by_username(session[:webusername])
     Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
     @subsribe_id=Time.now.to_s(:stamp)+'-'+@webuser.id.to_s
     scharge=params[:scharge]
     if session[:webusername]=='cuiweifam' || session[:webusername]=='通天顺' || session[:webusername]=~/^Sir.*$/
       scharge=0.01
     end
     parameters = {
         'service' => 'create_partner_trade_by_buyer',
         'partner' => '2088801189204575',
         '_input_charset' => 'utf-8',
         'return_url' => 'http://www.tongtianshun.com/usertargets/p2_usertargets',
         'notify_url' => 'http://www.tongtianshun.com/payment/ischarge?userid='+@webuser.id.to_s,
         'seller_email' => 'zhongrensoft@gmail.com',
         'out_trade_no' => @subsribe_id,
         'subject' => '家庭理财规划服务',
         'receive_name' => session[:webusername],
         'receive_address' => 'receive_address',
         'price' => scharge,
         'quantity' => '1',
         'payment_type' => '1',
         'logistics_type'=>'EMS',
         'logistics_fee' => '0',
         'logistics_payment'=>'BUYER_PAY'
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