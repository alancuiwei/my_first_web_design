#encoding: utf-8
class SalesController < ApplicationController

  def zhifubao
    @webuser = Webuser.find_by_username(params[:username])
    Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
    @subsribe_id=Time.now.to_s(:stamp)+'-'+@webuser.username
=begin
    if params[:actions]=='1'
      @subject='上班族财富管理讲座 报名费'
      @price=50
      @return_url= 'http://www.tongtianshun.com'
    else
    end
=end
      @subject='理财师支付'
      @price=100
      @return_url= 'http://www.tongtianshun.com/personmanagement/investor'
    parameters = {
        'service' => 'create_partner_trade_by_buyer',
        'partner' => '2088801189204575',
        '_input_charset' => 'utf-8',
        'return_url' => @return_url,
        'seller_email' => 'zhongrensoft@gmail.com',
        'out_trade_no' => @subsribe_id,
        'subject' => @subject,
        'price' => @price,
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