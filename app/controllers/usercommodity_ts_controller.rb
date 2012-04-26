#encoding: utf-8
require 'rexml/document'
#require 'rexml/streamlistener'
include REXML
#include StreamListener

class UsercommodityTsController < ApplicationController
layout 'usermanagement'
  # GET /usercommodity_ts
  # GET /usercommodity_ts.json
  def index
    @usercommodity_ts = UsercommodityT.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usercommodity_ts }
    end
  end

  # GET /usercommodity_ts/1
  # GET /usercommodity_ts/1.json
  def show
    @usercommodity_t = UsercommodityT.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @usercommodity_t }
    end
  end
  def showtm
    @usercommodity_t = UsercommodityT.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])

    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
   #xml读取操作
   @doc = Document.new(File.new('public/commodity.xml'))
   @exchtrademargin=Array.new
   @commodityid=Array.new
   for i in 0..@usercommodity.size-1
   @commodityid[i] = @doc.elements.to_a("//commodityid")[i].text
   @exchtrademargin[i] = @doc.elements.to_a("//exchtrademargin")[i].text
   end

    for i in 0..@usercommodity.size-1
       if @commodityid[i]==@usercommodity_t.commodityid
         @usernum=i
         break
       end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @usercommodity_t }
    end
  end

  def showlr
    @usercommodity_t = UsercommodityT.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
  end
  # GET /usercommodity_ts/new
  # GET /usercommodity_ts/new.json
  def new
    @usercommodity_t = UsercommodityT.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @usercommodity_t }
    end
  end

  # GET /usercommodity_ts/1/edit
  def edit
    @usercommodity_t = UsercommodityT.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])
    @usercommodity=UsercommodityT.find_all_by_userid(@webuser.name)
   #xml读取操作
   @doc = Document.new(File.new('public/commodity.xml'))
   @exchtrademargin=Array.new
   @commodityid=Array.new
   for i in 0..@usercommodity.size-1
   @commodityid[i] = @doc.elements.to_a("//commodityid")[i].text
   @exchtrademargin[i] = @doc.elements.to_a("//exchtrademargin")[i].text
   end

    for i in 0..@usercommodity.size-1
       if @commodityid[i]==@usercommodity_t.commodityid
         @usernum=i
         break
       end
    end

  end

  # POST /usercommodity_ts
  # POST /usercommodity_ts.json

  def create
    @usercommodity_t = UsercommodityT.new(params[:usercommodity_t])

    respond_to do |format|
      if @usercommodity_t.save
        format.html { redirect_to @usercommodity_t, notice: 'Usercommodity t was successfully created.' }
        format.json { render json: @usercommodity_t, status: :created, location: @usercommodity_t }
      else
        format.html { render action: "new" }
        format.json { render json: @usercommodity_t.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /usercommodity_ts/1
  # PUT /usercommodity_ts/1.json
  def update
    @usercommodity_t = UsercommodityT.find(params[:id])
    @webuser = Webuser.find_by_name(session[:webuser_name])

    respond_to do |format|
      params[:usercommodity_t][:trademargingap]=params[:usercommodity_t][:trademargingap].to_f-session[:exchtrademargin].to_f
      if @usercommodity_t.update_attributes(params[:usercommodity_t])
        if $commodity_form==0
        format.html { redirect_to @usercommodity_t, notice:@webuser.name+ '，您的交易价格修改成功！' }
        else
          format.html { redirect_to :controller=>"usercommodity_ts" ,:action=>"showtm", :id=>@usercommodity_t.id }
        end
        format.json { head :ok }

      else
        format.html { render action: "edit" }
        format.json { render json: @usercommodity_t.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usercommodity_ts/1
  # DELETE /usercommodity_ts/1.json
  def destroy
    @usercommodity_t = UsercommodityT.find(params[:id])
    @usercommodity_t.destroy

    respond_to do |format|
      format.html { redirect_to usercommodity_ts_url }
      format.json { head :ok }
    end
  end
end
