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
    end

  def reserve
    if  params[:investamount]==""
      render :json=>'购买金额为空！'.to_json
    elsif  params[:email]==""
      render :json=>'电子邮箱为空！'.to_json
    elsif  params[:tel]==""
      render :json=>'联系电话为空！'.to_json
    elsif  params[:card]==""  &&  params[:isuser]=="是"
      render :json=>'银行卡号为空！'.to_json
    elsif  params[:bankbranch]=="" &&  params[:isuser]=="是"
      render :json=>'分行名为空！'.to_json
    elsif  params[:investamount].to_i<params[:startvalue].to_i
      render :json=>'购买金额不足'.to_json
    elsif /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.match(params[:email])==nil
      render :json=>'请输入正确的电子邮箱！'.to_json
    else
      render :json => "s".to_json
    end
  end

  def myorder
      @reserve=Reserve.find_all_by_username(session[:webusername])
    end

  def confirm
    @banfinance=Bankfinance.find_by_id(params[:bid])
  end
end