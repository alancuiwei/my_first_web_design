#encoding: utf-8
class NoriskmessagesController < ApplicationController
 #layout "application" ,:except=>[:edit,:index,:new,:show]
  # GET /noriskmessages
  # GET /noriskmessages.json
  def index
    @webusername=session[:webuser_name]
    @noriskmessages = Noriskmessage.order("created_at DESC")
	  @noriskmessages = @noriskmessages.paginate(:per_page => 4, :page => params[:page])
	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @noriskmessages }
    end
	
  end

  # GET /noriskmessages/1
  # GET /noriskmessages/1.json
  def show
    @noriskmessage = Noriskmessage.find(params[:id])
	if @webuser = Webuser.find_by_name(session[:webuser_name])
    @noriskmessage.name=@webuser.name
	else
	@noriskmessage.name="游客"
	end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @noriskmessage }
    end
  end

  # GET /noriskmessages/new
  # GET /noriskmessages/new.json
  def new
    @noriskmessage = Noriskmessage.new
	if @webuser = Webuser.find_by_name(session[:webuser_name])
    @noriskmessage.name=@webuser.name
	else
	@noriskmessage.name="游客"
	end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @noriskmessage }
    end
  end

  # GET /noriskmessages/1/edit
  def edit
    @noriskmessage = Noriskmessage.find(params[:id])
  end

  # POST /noriskmessages
  # POST /noriskmessages.json
  def create
    @noriskmessage = Noriskmessage.new(params[:noriskmessage])
    if @webuser = Webuser.find_by_name(session[:webuser_name])
    @noriskmessage.name=@webuser.name
	else
	@noriskmessage.name="游客"
	end
    respond_to do |format|
      if @noriskmessage.save
        format.html { redirect_to action: "new", notice: '您的评论发表成功。' }
        format.json { render json: @noriskmessage, status: :created, location: @noriskmessage }
      else
        format.html { render action: "new" }
        format.json { render json: @noriskmessage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /noriskmessages/1
  # PUT /noriskmessages/1.json
  def update
    @noriskmessage = Noriskmessage.find(params[:id])

    respond_to do |format|
      if @noriskmessage.update_attributes(params[:noriskmessage])
        format.html { redirect_to @noriskmessage, notice: '您的评论已经修改成功。' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @noriskmessage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /noriskmessages/1
  # DELETE /noriskmessages/1.json
  def destroy
    @noriskmessage = Noriskmessage.find(params[:id])
    @noriskmessage.destroy

    respond_to do |format|
      format.html { redirect_to noriskmessages_url }
      format.json { head :ok }
    end
  end
end
