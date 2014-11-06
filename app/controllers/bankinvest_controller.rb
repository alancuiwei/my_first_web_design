#encoding: utf-8
require 'date'
class BankinvestController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
  def pace
    @pace=Pace.all
  end

  def classify
   if params[:id]!=nil
    @category=Admin_asset_type_l2.find_by_id(params[:id])
    @probability=Loss_probability.find_all_by_typeid(@category.L2_typeid)
    @max=Max_return_rate.find_all_by_typeid(@category.L2_typeid)
    @average=Average_return_rate.find_all_by_typeid(@category.L2_typeid)
    t = Time.new
    year = t.strftime("%Y")
    @average2=Average_return_rate.find_by_typeid_and_years(@category.L2_typeid,year.to_i-1)
   else
     redirect_to(:controller=>"home",:action=>"index")
   end
  end

  def press
    @press=Press.order("pdate desc").all
  end

  def products
    @blog=Blog.find_by_id(469)
    @blog2=Blog.find_by_id(472)
    @blog3=Blog.find_by_id(467)
    @blog4=Blog.find_by_id(468)
    @hash2={}
    @typel2=Admin_asset_type_l2.all
    for i in 0..@typel2.size-1
      @hash2.store(@typel2[i].L2_typeid,[@typel2[i].classify])
    end

    @monetaryfundquote=Monetary_fund_quote.all
    @hash={}
    for i in 0..@monetaryfundquote.size-1
      @fundproduct=Fund_product.find_by_product_code(@monetaryfundquote[i].product_code)
      t = Time.new
      date = t.strftime("%Y-%m-%d")
      if @fundproduct!=nil
        if @fundproduct.create_date!=nil
          @hash.store(@monetaryfundquote[i].product_code,[@fundproduct.min_purchase_account,@fundproduct.fund_size,@fundproduct.create_date,DateTime.parse(date)-DateTime.parse(@fundproduct.create_date.to_s),@fundproduct.buy_link])
        else
          @hash.store(@monetaryfundquote[i].product_code,[@fundproduct.min_purchase_account,@fundproduct.fund_size,@fundproduct.create_date,nil,@fundproduct.buy_link])
        end
      else
        @hash.store(@monetaryfundquote[i].product_code,[nil,nil,nil,nil,'http://fund.fund123.cn/html/'+@monetaryfundquote[i].product_code+'/index.html'])
      end
    end
    @hash3={}
    @generalfundquote=General_fund_quote.all
    for i in 0..@generalfundquote.size-1
      @product=General_fund_product.find_by_product_code(@generalfundquote[i].product_code)
      if @product!=nil
        if @product.date!=nil
          @hash3.store(@generalfundquote[i].product_code,[1000,DateTime.parse(date)-DateTime.parse(@product.date.to_s),@product.fund_size,@product.buy_link])
        else
          @hash3.store(@generalfundquote[i].product_code,[1000,nil,@product.fund_size,@product.buy_link])
        end
      else
        @hash3.store(@generalfundquote[i].product_code,[nil,nil,nil,'http://fund.fund123.cn/html/'+@generalfundquote[i].product_code+'/index.html'])
      end
    end
    @banks=Banks_self_products.all
  end

  def buylinks
    if params[:id]!=nil
      @financial=Monetary_fund_quote.find_by_id(params[:id])
      @productcompany=Productcompany.find_all_by_pname(@financial.productname)
      @hash={}
      for i in 0..@productcompany.size-1
        @salescompany=Salescompany.find_by_fundname(@productcompany[i].fundname)
        if @salescompany!=nil
          @hash.store(@productcompany[i].fundname,[@salescompany.logo,@salescompany.guide,@salescompany.time])
        else
          @hash.store(@productcompany[i].fundname,[nil,nil,nil])
        end
      end
    else
      redirect_to(:controller=>"bankinvest", :action=>"products")
    end
  end

  def salescompany
    if params[:id]!=nil
      @salescompany=Salescompany.find_by_id(params[:id])
      if @salescompany.assist!=nil
      @saleshelp=@salescompany.assist.split(",")
      end
      if params[:pid]!=nil
        @financial=Monetary_fund_quote.find_by_id(params[:pid])
        @productcompany=Productcompany.find_by_pname_and_fundname(@financial.productname,@salescompany.fundname)
      end
    else
      redirect_to(:controller=>"home", :action=>"index")
    end
  end

  def huobi
    @blog3=Blog.find_by_id(467)
    @blog4=Blog.find_by_id(468)
    if params[:id]!=nil
      @fundquote=Monetary_fund_quote.find_by_id(params[:id])
      @link={}
      if @fundquote!=nil
        @fundproduct=Fund_product.find_by_product_code(@fundquote.product_code)
        if @fundproduct!=nil && @fundproduct.buy_link!=nil
          @link=@fundproduct.buy_link
        else
          @link='http://fund.fund123.cn/html/'+@fundproduct.product_code+'/index.html'
        end
      else
        redirect_to(:controller=>"bankinvest", :action=>"products")
      end
    else
      redirect_to(:controller=>"bankinvest", :action=>"products")
    end
  end

  def highprofit
    @blog3=Blog.find_by_id(467)
    @blog4=Blog.find_by_id(468)
    if params[:id]!=nil
      @fundquote=General_fund_quote.find_by_id(params[:id])
      @hash={}
      @hash2={}
      @adminassettype=Admin_asset_type_l2.all
      for i in 0..@adminassettype.size-1
        @hash2.store(@adminassettype[i].L2_typeid,[@adminassettype[i].classify])
      end
      @link={}
      if @fundquote!=nil
        @fundproduct=General_fund_product.find_by_product_code(@fundquote.product_code)
        if @fundproduct!=nil && @fundproduct.buy_link!=nil
          @link=@fundproduct.buy_link
        else
          @link='http://fund.fund123.cn/html/'+@fundproduct.product_code+'/index.html'
        end
      else
        redirect_to(:controller=>"bankinvest", :action=>"products")
      end
    else
      redirect_to(:controller=>"bankinvest", :action=>"products")
    end
  end

  def productdetails
    if params[:id]!=nil
      @financial=Financial.find_by_id(params[:id])
      @category=Admin_asset_type_l2.find_by_classify(@financial.classify)
      @productcompany=Productcompany.find_all_by_pname(@financial.pname)
      @hash={}
      for i in 0..@productcompany.size-1
        @salescompany=Salescompany.find_by_fundname(@productcompany[i].fundname)
        if @salescompany!=nil
          @hash.store(@productcompany[i].fundname,[@salescompany.id])
        else
          @hash.store(@productcompany[i].fundname,[nil,nil,nil])
        end
        if i==0
          @min=@productcompany[i].poundage
        elsif @min>@productcompany[i].poundage
          @min=@productcompany[i].poundage
        end
      end
    else
      redirect_to(:controller=>"bankinvest", :action=>"products")
    end
  end

  def compare
    @compareid=session[:compareid].split("|")
    @compareid.delete("")
    for i in 0..@compareid.size-1
        for j in i+1..@compareid.size-1
            if  @compareid[i]==@compareid[j]
              @compareid.delete_at(j)
            end
        end
    end
    @compareobj=[]
    @hash={}
    for i in 0..@compareid.size-1
      @compareobj[i]= Financial.find(@compareid[i]);
      @category=Admin_asset_type_l2.find_by_classify(@compareobj[i].classify)
     if @category!=nil
       @hash.store(i,[@category.risk1,@category.return1,@category.prisk])
     else
       @hash.store(i,[nil,nil,nil])
     end
    end
  end
  def comparesession
    if params[:comparenum]=='0'
      session[:compareid]=""
    end
    if  params[:type]=="clearid"
      session[:compareid]=""
    else if params[:type]=="deleteid"
      session[:compareid]=session[:compareid].gsub(params[:compareid],"")
      else
     session[:compareid]=session[:compareid]+"|"+params[:compareid]
    end
   end
     render :json => "s".to_json
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