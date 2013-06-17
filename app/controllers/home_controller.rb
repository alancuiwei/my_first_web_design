#encoding: utf-8
class HomeController < ApplicationController
  def index
    @personfinance=Personalfinance.all
    @username=Personalfinance.find_by_sql('select distinct username from personalfinance')
    @num=@username.length
  end

  def scheme
    @comments=Comments.find_by_sql('select * from comments where pid is not null order by id desc')
    @hash={}
    @comments.each do |b|
      @add=Webuser.find_by_username(b.username)
      if @add!=nil
        @hash.store(b.id,[@add.dream,@add.realizetime,@add.exeitdeposit])
      else
        @hash.store(b.id,[nil,nil,nil])
      end
    end
  end

  def productindex
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

  def apply
    if session[:webusername]!=nil
      @webuser=Webuser.find_by_username(session[:webusername])
    else
      @webuser=Webuser.find_by_username("admin")
    end
  end

  def plan
    if session[:webusername]!=nil
      @personalfinance=Personalfinance.find_by_username(session[:webusername])
      @webuser2=Webuser.find_by_username(session[:webusername])
      if @personalfinance!=nil
        session[:personname]=@personalfinance.username
      end
      if @webuser2.risktolerance==nil && params[:username]==nil && cookies[:asset_allocation]==nil
        redirect_to(:controller=>"home", :action=>"questions")
      end
      if @webuser2.risktolerance==nil && params[:username]==session[:webusername]
        redirect_to(:controller=>"home", :action=>"questions")
      end
    elsif cookies[:asset_allocation]==nil && params[:username]==nil
      redirect_to(:controller=>"home", :action=>"questions")
    else
      @webuser2=Webuser.find_by_username('admin')
    end
    if params[:user]!=nil && cookies[:asset_allocation]!=nil && session[:webusername]!=nil
        @provides=Provide.find_all_by_username(session[:webusername])
        @invest=cookies[:asset_allocation].split('|')[5].to_f
    elsif params[:username]!=nil
      @provides=Provide.find_all_by_username(params[:username])
      @personal=Personalfinance.find_by_username(params[:username])
      if @personal!=nil
        @invest=@personal.investamount.to_f
      else
        @invest=50000
      end
    elsif session[:webusername]!=nil
      @provides=Provide.find_all_by_username(session[:webusername])
      @personal=Personalfinance.find_by_username(session[:webusername])
      if @personal!=nil
        @invest=@personal.investamount.to_f
      else
        @invest=50000
      end
    else
      @provides=Provide.find_all_by_username('admin')
      if cookies[:asset_allocation]!=nil
        @invest=cookies[:asset_allocation].split('|')[5].to_f
      else
        @invest=50000
      end
    end
    if params[:username]!=nil
      @webuser=Webuser.find_by_username(params[:username])
      if @webuser==nil
        redirect_to(:controller=>"home", :action=>"questions")
      end
    elsif session[:webusername]!=nil  && cookies[:asset_allocation]==nil
      @webuser=Webuser.find_by_username(session[:webusername])
    else
      @webuser=Webuser.find_by_username('admin')
    end
  end

  def download
    send_file "app/assets/download/"+params[:filename] unless params[:filename].blank?
  end

  def guide
    @number=Downloadnum.find_by_id(1);
    @pdfnumber=@number.pdfnumber
    @jpgnumber=@number.jpgnumber
  end

  def downloadconfigajax
    @number=Downloadnum.find_by_id(1);
    @number.update_attributes(:pdfnumber=>params[:pdfnumber],:jpgnumber=>params[:jpgnumber])
  end
end
