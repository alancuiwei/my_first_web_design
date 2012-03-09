class StrategywebsController < ApplicationController
  # GET /strategywebs
  # GET /strategywebs.json
  def index
    @strategywebs = Strategyweb.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @strategywebs }
    end
  end

  # GET /strategywebs/1
  # GET /strategywebs/1.json
  def show
    @strategyweb = Strategyweb.find(params[:id])

	strategy_id = "010603000000"

	testrate = StrategyreturnrateT.all
	firstyear = testrate[0].yearid
	lastyear = testrate[-1].yearid
	@existyears = Array(firstyear..lastyear)
	@strate = Array.new
	firstyear.upto(lastyear) do |year|
	@strate[year] = StrategyreturnrateT.find_all_by_rightid_and_yearid(strategy_id,year)
	end
	
	@streference = StrategyreferenceT.find_all_by_rightid(strategy_id)
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @strategyweb }
    end
  end

  # GET /strategywebs/new
  # GET /strategywebs/new.json
  def new
    @strategyweb = Strategyweb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @strategyweb }
    end
  end

  # GET /strategywebs/1/edit
  def edit
    @strategyweb = Strategyweb.find(params[:id])

  end

  # POST /strategywebs
  # POST /strategywebs.json
  def create
    @strategyweb = Strategyweb.new(params[:strategyweb])

    respond_to do |format|
      if @strategyweb.save
        format.html { redirect_to @strategyweb, notice: 'Strategyweb was successfully created.' }
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
        format.html { redirect_to @strategyweb, notice: 'Strategyweb was successfully updated.' }
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
