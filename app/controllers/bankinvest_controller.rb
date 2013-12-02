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
    @monetary=Monetary_fund_quote.all
    @hash={}
    for i in 0..@monetary.size-1
      @fundproduct=Monetary_fund_product.find_by_product_code(@monetary[i].product_code)
      t = Time.new
      date = t.strftime("%Y-%m-%d")
      if @fundproduct!=nil
        if @fundproduct.create_date!=nil
          @hash.store(@monetary[i].product_code,[@fundproduct.min_purchase_account,@fundproduct.fund_size,@fundproduct.create_date,DateTime.parse(date)-DateTime.parse(@fundproduct.create_date.to_s)])
      else
          @hash.store(@monetary[i].product_code,[@fundproduct.min_purchase_account,@fundproduct.fund_size,@fundproduct.create_date,nil])
      end
      else
        @hash.store(@monetary[i].product_code,[nil,nil,nil,nil])
    end
        end

    @general=General_fund_quote.all
    @hash2={}
    @typel2=Admin_asset_type_l2.all
    for i in 0..@typel2.size-1
      @hash2.store(@typel2[i].L2_typeid,[@typel2[i].classify])
    end
  end

  def buylinks
    if params[:id]!=nil
      @financial=Financial.find_by_id(params[:id])
      @productcompany=Productcompany.find_all_by_pname(@financial.pname)
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
        @financial=Financial.find_by_id(params[:pid])
        @productcompany=Productcompany.find_by_pname_and_fundname(@financial.pname,@salescompany.fundname)
      end
    else
      redirect_to(:controller=>"home", :action=>"index")
    end
  end

  def huobi
    if params[:id]!=nil
      @fundquote=Monetary_fund_quote.find_by_id(params[:id])
      @hash={}
      if @fundquote!=nil
        @fundproduct=Monetary_fund_product.find_by_product_code(@fundquote.product_code)
        @productcompany=Productcompany.find_all_by_pname(@fundquote.productname)
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
        @average1=Average_return_rate.find_by_typeid_and_years(101,1)
        @average2=Average_return_rate.find_by_typeid_and_years(101,2)
        @average3=Average_return_rate.find_by_typeid_and_years(101,3)
      else
        redirect_to(:controller=>"bankinvest", :action=>"products")
      end
    else
      redirect_to(:controller=>"bankinvest", :action=>"products")
    end
  end

  def highprofit
    if params[:id]!=nil
      @fundquote=General_fund_quote.find_by_id(params[:id])
      @hash={}
      @hash2={}
      @adminassettype=Admin_asset_type_l2.all
      for i in 0..@adminassettype.size-1
        @hash2.store(@adminassettype[i].L2_typeid,[@adminassettype[i].classify])
      end
      if @fundquote!=nil
        @fundproduct=General_fund_product.find_by_product_code(@fundquote.product_code)
        @productcompany=Productcompany.find_all_by_pname(@fundquote.product_name)
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
        @average1=Average_return_rate.find_by_typeid_and_years(@fundquote.L2_typeid,1)
        @average3=Average_return_rate.find_by_typeid_and_years(@fundquote.L2_typeid,3)
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