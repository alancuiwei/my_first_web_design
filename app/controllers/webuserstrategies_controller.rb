#encoding: utf-8

class WebuserstrategiesController < ApplicationController
  before_filter :authorize
  helper :all
  # GET /webuserstrategies
  # GET /webuserstrategies.json
  def index
#    @webuserstrategies = Webuserstrategy.find_all_by_username(session[:webuser_name])
    @webuserstrategies = Webuserstrategy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @webuserstrategies }
    end
  end

  # GET /webuserstrategies/1
  # GET /webuserstrategies/1.json
  def show
    strategyinstance = Strategyweb.find(params[:id])
    mystrategyid = strategyinstance.strategyid
    myusername = session[:webuser_name]
    @webuserstrategy = Webuserstrategy.find_by_username_and_strategyid(myusername,mystrategyid)
    if !@webuserstrategy then
       @webuserstrategy = Webuserstrategy.new
       render action: "new"
    else
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webuserstrategy }
    end
    end
  end

  # GET /webuserstrategies/new
  # GET /webuserstrategies/new.json
  def new
    @webuserstrategy = Webuserstrategy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @webuserstrategy }
    end
  end

  # GET /webuserstrategies/1/edit
  def edit
    @webuserstrategy = Webuserstrategy.find(params[:id])
  end

  # POST /webuserstrategies
  # POST /webuserstrategies.json
  def create
    @webuserstrategy = Webuserstrategy.new(params[:webuserstrategy])

    respond_to do |format|
      if @webuserstrategy.save
        format.html { redirect_to @webuserstrategy, notice: 'Webuserstrategy was successfully created.' }
        format.json { render json: @webuserstrategy, status: :created, location: @webuserstrategy }
      else
        format.html { render action: "new" }
        format.json { render json: @webuserstrategy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /webuserstrategies/1
  # PUT /webuserstrategies/1.json
  def update
    @webuserstrategy = Webuserstrategy.find(params[:id])

    respond_to do |format|
      if @webuserstrategy.update_attributes(params[:webuserstrategy])
        format.html { redirect_to @webuserstrategy, notice: 'Webuserstrategy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @webuserstrategy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webuserstrategies/1
  # DELETE /webuserstrategies/1.json
  def destroy
    @webuserstrategy = Webuserstrategy.find(params[:id])
    @webuserstrategy.destroy

    respond_to do |format|
      format.html { redirect_to webuserstrategies_url }
      format.json { head :no_content }
    end
  end

protected
  def authorize
    unless Webuser.find_by_name(session[:webuser_name])
      session[:original_uri] = request.fullpath
#      flash[:notice] = " 如果需要使用该功能，请先登录 "
      redirect_to :controller => 'sessions', :action =>'new'
    end
  end
end
