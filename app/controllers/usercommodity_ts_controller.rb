#encoding: utf-8
class UsercommodityTsController < ApplicationController
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
      if @usercommodity_t.update_attributes(params[:usercommodity_t])
        format.html { redirect_to @usercommodity_t, notice:@webuser.name+ '，您的交易价格已经修改成功！' }
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
