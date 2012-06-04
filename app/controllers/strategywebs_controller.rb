#encoding: utf-8
class StrategywebsController < ApplicationController

  def index
    @strategywebs = Strategyweb.all
    @webuser = Webuser.find_by_name(session[:webuser_name])
    if @webuser!=nil
      if @webuser.name=='administrator'
        @show_flag=1
      end
    end
    @allmaxreturnrate=ArbcostmaxreturnrateT.find(:all, :order =>"returnrate DESC",:limit => 1)
    @strategyweb = Strategyweb.find_by_name("无风险套利")
   @strategyweb.update_attributes(:anreturn=>@allmaxreturnrate[0].returnrate)
    respond_to do |format|
      format.html
      format.json { render json: @strategywebs }
    end
  end
  

  # GET /strategywebs/1
  # GET /strategywebs/1.json
  def show
    @strategyweb = Strategyweb.find(params[:id])

    respond_to do |format|
      format.html
#      format.json { render json: @strategyweb }
    end
  end


  # GET /strategywebs/new
  # GET /strategywebs/new.json
  def new
    @strategyweb = Strategyweb.new

    respond_to do |format|
      format.html
      format.json { render json: @strategyweb }
    end
  end

  # GET /strategywebs/1/edit
  def edit
    @strategyweb = Strategyweb.find(params[:id])
#	render:layout => 'admin'
  end

  # POST /strategywebs
  # POST /strategywebs.json
  def create
    
	@strategyweb = Strategyweb.new(params[:strategyweb])

    respond_to do |format|
      if @strategyweb.save
        format.html { redirect_to :action=>"index", notice: 'Strategyweb was successfully created.' }
        format.json { render json: @strategyweb, status: :created, location: @strategyweb }
      else
        format.html { render action: "new" }
        format.json { render json: @strategyweb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /strategywebs/1
  # PUT /strategywebs/1.json
  def update
    @strategyweb = Strategyweb.find(params[:id])

    respond_to do |format|
      if @strategyweb.update_attributes(params[:strategyweb])
        format.html { redirect_to :action=>"index", notice: 'Strategyweb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @strategyweb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategywebs/1
  # DELETE /strategywebs/1.json
  def destroy
    @strategyweb = Strategyweb.find(params[:id])
    @strategyweb.destroy

    respond_to do |format|
      format.html { redirect_to strategywebs_url }
      format.json { head :no_content }
    end
  end
end
