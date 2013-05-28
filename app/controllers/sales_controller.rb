#encoding: utf-8
class SalesController < ApplicationController
  def index
    @banfinance=Bankfinance.find_by_id(params[:bid])
    if @banfinance==nil
      redirect_to(:controller=>"bankinvest", :action=>"index")
    end
    if session[:webusername]=="admin"
      if params[:id]!=nil
        @webuser=Webuser.find_by_id(params[:id])
      else
        @webuser=Webuser.find_by_username(session[:webusername])
  end
    else
      @webuser=Webuser.find_by_username(session[:webusername])
    end
    if session[:webusername]!=nil
      @personalfinance=Personalfinance.find_by_username(session[:webusername])
    end
    end

  def myorder
      @reserve=Reserve.find_all_by_username(session[:webusername])
    end

  def confirm
    @banfinance=Bankfinance.find_by_id(params[:bid])
  end

  def getpassword
    @webuser=Webuser.find_by_username(params[:username])
    if  @webuser==nil
      render :json => "s".to_json
    else
      password=decode(@webuser.password)
      password2=encode(params[:password2])
      if params[:password]!=password
        render :json => "s1".to_json
      else
        @webuser.update_attributes(:password=>password2)
        render :json => "s2".to_json
        session[:webusername]=nil
      end
    end

  end

  def reserve
    @personalfinance=Personalfinance.find_by_username(params[:username])
    if  @personalfinance==nil
      render :json => "f1".to_json
    else
      render :json => "f2".to_json
    end
  end

  def zhifubao
    @webuser = Webuser.find_by_username(params[:username])
    Time::DATE_FORMATS[:stamp] = '%Y%m%d%H%M%S'
    @subsribe_id=Time.now.to_s(:stamp)+'-'+@webuser.id.to_s
    parameters = {
        'service' => 'create_partner_trade_by_buyer',
        'partner' => '2088801189204575',
        '_input_charset' => 'utf-8',
        'return_url' => 'http://www.tongtianshun.com/personmanagement/investor',
        'seller_email' => 'zhongrensoft@gmail.com',
        'out_trade_no' => @subsribe_id,
        'subject' => '理财师支付',
        'price' => '50',
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


require 'openssl'
require 'base64'
ALG = 'DES-EDE3-CBC'  #算法
KEY = "mZ4Wjs6L"  #8位密钥
DES_KEY = "nZ4wJs6L"

#加密
def encode(str)
  des = OpenSSL::Cipher::Cipher.new(ALG)
  des.pkcs5_keyivgen(KEY, DES_KEY)
  des.encrypt
  cipher = des.update(str)
  cipher << des.final
  return Base64.encode64(cipher) #Base64编码，才能保存到数据库
end

#解密
def decode(str)
  str = Base64.decode64(str)
  des = OpenSSL::Cipher::Cipher.new(ALG)
  des.pkcs5_keyivgen(KEY, DES_KEY)
  des.decrypt
  des.update(str) + des.final
end