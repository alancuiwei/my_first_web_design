class AdminController < ApplicationController
#  before_filter :authenticate

  def index
  @webuser = Webuser.find_by_name(session[:webuser_name])
  if @webuser!=nil
   if @webuser.name!="administrator"
     redirect_to(:controller=>"usermanagement", :action=>"index")
   end
   else
   redirect_to(:controller=>"home", :action=>"index")
    end
  end

  def comparison
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser==nil|| @webuser.name!="administrator"
      redirect_to(:controller=>"usermanagement", :action=>"index")
  end
  end

  def currentversion
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser==nil|| @webuser.name!="administrator"
         redirect_to(:controller=>"usermanagement", :action=>"index")
    else
    @versions=Versionstable.find(:all, :order =>"update_date DESC")
    end
  end

  def creatversion
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser==nil|| @webuser.name!="administrator"
         redirect_to(:controller=>"usermanagement", :action=>"index")
    elsif params[:current_version_id]!=nil
    Versionstable.new do |v|
      v.current_version_id=params[:current_version_id]
      v.current_comments=params[:current_comments]
      v.rails_comments=params[:rails_comments]
      v.rails_branch_id=params[:rails_branch_id]
      v.rails_commit_id=params[:rails_commit_id]
      v.mysql_comments=params[:mysql_comments]
      v.mysql_branch_id=params[:mysql_branch_id]
      v.mysql_commit_id=params[:mysql_commit_id]
      v.ctp_comments=params[:ctp_comments]
      v.ctp_branch_id=params[:ctp_branch_id]
      v.ctp_commit_id=params[:ctp_commit_id]
      v.update_date=Time.now.to_s(:db)
      v.save
    end
    redirect_to(:controller=>"admin", :action=>"currentversion")
    end
  end

  def showversion
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser==nil|| @webuser.name!="administrator"
         redirect_to(:controller=>"usermanagement", :action=>"index")
    else
    @version=Versionstable.find(params[:id])
    end
  end

  def editversion
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser==nil|| @webuser.name!="administrator"
         redirect_to(:controller=>"usermanagement", :action=>"index")
    else
    @version=Versionstable.find(params[:id])
    if params[:current_version_id]!=nil
    @version.current_version_id=params[:current_version_id]
    @version.current_comments=params[:current_comments]
    @version.rails_comments=params[:rails_comments]
    @version.rails_branch_id=params[:rails_branch_id]
    @version.rails_commit_id=params[:rails_commit_id]
    @version.mysql_comments=params[:mysql_comments]
    @version.mysql_branch_id=params[:mysql_branch_id]
    @version.mysql_commit_id=params[:mysql_commit_id]
    @version.ctp_comments=params[:ctp_comments]
    @version.ctp_branch_id=params[:ctp_branch_id]
    @version.ctp_commit_id=params[:ctp_commit_id]
    @version.update_date=Time.now.to_s(:db)
    @version.save
    redirect_to(:controller=>"admin", :action=>"currentversion")
    end
    end
  end

  def deleteversion
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser==nil|| @webuser.name!="administrator"
         redirect_to(:controller=>"usermanagement", :action=>"index")
    else
    @version=Versionstable.find(params[:id])
    @version.destroy
    redirect_to(:controller=>"admin", :action=>"currentversion")
    end
  end

end
