class WebusersController < ApplicationController
#  before_filter :authenticate
#  layout "admin"
  # GET /webusers
  # GET /webusers.json
  def index
    @webusers = Webuser.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @webusers }
    end
  end

  # GET /webusers/1
  # GET /webusers/1.json
  def show
    @webuser = Webuser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webuser }
    end
  end

  # GET /webusers/new
  # GET /webusers/new.json
  def new
    @webuser = Webuser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @webuser }
    end
  end

  # GET /webusers/1/edit
  def edit
    @webuser = Webuser.find(params[:id])
  end

  # POST /webusers
  # POST /webusers.json
  def create
    @webuser = Webuser.new(params[:webuser])

    respond_to do |format|
      if @webuser.save
        format.html { redirect_to(:controller=>"home", :action=>"index", :notice => "Webuser #{@webuser.name} was sucessfully created.")}
        format.json { render json: @webuser, status: :created, location: @webuser }
      else
        format.html { render action: "new" }
        format.json { render json: @webuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /webusers/1
  # PUT /webusers/1.json
  def update
    @webuser = Webuser.find(params[:id])

    respond_to do |format|
      if @webuser.update_attributes(params[:webuser])
        format.html { redirect_to(webuser_url, :notice => "Webuser #{@webuser.name} was sucessfully updated.") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @webuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webusers/1
  # DELETE /webusers/1.json
  def destroy
    @webuser = Webuser.find(params[:id])
    @webuser.destroy

    respond_to do |format|
      format.html { redirect_to webusers_url }
      format.json { head :ok }
    end
  end
  protected

#  def authenticate
#    authenticate_or_request_with_http_basic do |username,password|
#      username == "admin" && password == "admin"
#    end

#  end
end
